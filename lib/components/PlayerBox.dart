import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart' hide TrackInfo;
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/components/HidableWrapper.dart';
import 'package:march_tales_app/components/PlayerWrapper.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/singletons/playingTrackEvents.dart';
import 'package:march_tales_app/core/types/PlayingTrackUpdate.dart';
import 'package:march_tales_app/features/Track/api-methods/postIncrementPlayedCount.dart';
import 'package:march_tales_app/features/Track/api-methods/postUpdatePosition.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/screens/TrackDetailsScreen.dart';
import 'PlayerBox/PlayerBox.i18n.dart';
import 'PlayerBox/common.dart';

final logger = Logger();

const useLocalDelays = true;
const saveServerPositionDelayMs = useLocalDelays && AppConfig.DEBUG ? 1 * 1000 : 10 * 1000;

// NOTE: This module shouldn't use `AppState` due to one-way control flow (it's used in `ActivePlayerState`)

class PlayerBox extends StatefulWidget {
  final bool show;
  final bool isAuthorized;
  final NavigatorState? navigatorState;
  final VoidCallback showPlayer;

  const PlayerBox({
    super.key,
    this.show = true,
    this.isAuthorized = true,
    this.navigatorState,
    required this.showPlayer,
  });

  @override
  State<PlayerBox> createState() => PlayerBoxState();
}

class PlayerBoxState extends State<PlayerBox> {
  late AudioPlayer _player;
  Track? _track;
  late SharedPreferences _prefs;
  Duration? _position;
  // Duration? _buffered;
  bool _hasIncremented = false;
  bool _isIncrementingNow = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool __listenerInstalled = false;
  Timer? __activeTimer;
  int savedServerPositionAtMs = 0;

  @override
  void dispose() {
    this._player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream {
    return Rx.combineLatest2<
            Duration,
            // Duration,
            Duration?,
            PositionData>(
        this._player.positionStream,
        // this._player.bufferedPositionStream,
        this._player.durationStream, (position,
            // bufferedPosition,
            duration) {
      return PositionData(
        position,
        Duration.zero,
        duration ?? Duration.zero,
      );
    });
    /*
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      this._player.positionStream,
      this._player.bufferedPositionStream,
      this._player.durationStream,
      (position, bufferedPosition, duration) {
        return PositionData(position, bufferedPosition, duration ?? Duration.zero);
      });
    */
  }

  @override
  void initState() {
    super.initState();
    this._prefs = Init.prefs!;
    this._player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    this._initWithContext();
    // NOTE: Set listener in advance to allow processing of background player acitons
    this._ensurePlayerListener();
  }

  _initWithContext() {
    Future.delayed(Duration.zero, () {
      this._loadSavedPrefs();
    });
  }

  void _savePlayingPosition(Duration? position, {bool notify = true, bool forceServerUpdate = false}) async {
    setState(() {
      this._position = position;
    });
    if (notify) {
      this._sendBroadcastUpdate(PlayingTrackUpdateType.position);
    }
    // Save position to local db
    final timestamp = DateTime.now();
    tracksInfoDb.updatePosition(this._track!.id, position ?? Duration.zero,
        timestamp: timestamp); // this is await function, we don't wait for the finish
    final int timestampMs = timestamp.millisecondsSinceEpoch;
    if (this._track != null &&
        this._position != null &&
        this.widget.isAuthorized &&
        (forceServerUpdate || timestampMs - this.savedServerPositionAtMs >= saveServerPositionDelayMs)) {
      await postUpdatePosition(id: this._track!.id, position: this._position!, timestamp: timestamp);
      this.savedServerPositionAtMs = timestampMs;
    }
  }

  Future<void> _loadTrackPosition() async {
    if (this._track != null) {
      final trackInfo = await tracksInfoDb.getById(this._track!.id);
      setState(() {
        this._position = trackInfo?.position; // ?? Duration.zero;
      });
    }
  }

  _sendBroadcastUpdate(PlayingTrackUpdateType type) {
    final update = PlayingTrackUpdate(
      type: type,
      isPlaying: this._isPlaying,
      isPaused: this._isPaused,
      track: this._track,
      position: this._position,
    );
    playingTrackEvents.broadcast(update);
  }

  // Network API

  void _incrementCurrentTrackPlayedCount() async {
    if (this._track == null || this._hasIncremented || this._isIncrementingNow) {
      return;
    }
    this._isIncrementingNow = true;
    final id = this._track!.id;
    try {
      // Increment the count simultaneously on the server and in the local database...
      final timestamp = DateTime.now();
      final List<Future> futures = [
        postIncrementPlayedCount(id: id, timestamp: timestamp),
        tracksInfoDb.incrementPlayedCount(this._track!.id, timestamp: timestamp),
      ];
      final results = await Future.wait(futures);
      // Get and store udpated server track data
      final Track updatedTrack = results[0];
      this._track = updatedTrack;
      this._hasIncremented = true;
      this._sendBroadcastUpdate(PlayingTrackUpdateType.playedCount);
    } catch (err, stacktrace) {
      logger.e('[_incrementCurrentTrackPlayedCount] ${err}', error: err, stackTrace: stacktrace);
      debugger();
    } finally {
      this._isIncrementingNow = false;
    }
  }

  Future<Track?> _loadPlayingTrackDetails({required int id, bool notify = true}) async {
    if (id != 0) {
      // Update `playingTrack` if language has been changed
      try {
        final track = await loadTrackDetails(id);
        this._track = track;
        logger.t('[PlayerBox:_loadPlayingTrackDetails] track=${track}');
        await this._setTrack(track, notify: notify);
      } catch (err, stacktrace) {
        final String msg = 'Error loading currently playing track data.';
        logger.e('${msg} id=${id}: $err', error: err, stackTrace: stacktrace);
        // debugger();
        final translatedMsg = msg.i18n; // '${msg.i18n} ${"Track ID:".i18n} #${id}.';
        showErrorToast(translatedMsg);
      }
    }
    return this._track;
  }

  Future<Track?> updatePlayingTrackDetails({bool notify = true}) async {
    if (this._track != null) {
      final track = this._track = await loadTrackDetails(this._track!.id);
      setState(() {
        this._track = track;
      });
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.trackData);
      }
    }
    return this._track;
  }

  // Playback handlers

  void _playerStateHandler([PlayerState? _]) {
    final PlayerState playerState = this._player.playerState;
    final bool playing = playerState.playing;
    final ProcessingState processingState = playerState.processingState;
    // Update only if player is playing or completed
    PlayingTrackUpdateType? updateType; // = PlayingTrackUpdateType.position;
    final isCurrentlyPlaying = this._isPlaying && !this._isPaused;
    if (playing) {
      // Really playing and...
      if (!isCurrentlyPlaying) {
        this._setPlayingStatus(notify: false);
        updateType = PlayingTrackUpdateType.playingStatus;
      } else if (processingState == ProcessingState.completed) {
        this._pausePlayback(notify: false);
        this._setPausedStatus(notify: false);
        // Set position to the full duration value: as sign of the finished playback
        this._savePlayingPosition(this._player.duration, notify: false);
        updateType = PlayingTrackUpdateType.completedStatus; // pausedStatus;
        this._incrementCurrentTrackPlayedCount();
      }
    } else {
      // Not really playing and...
      if (isCurrentlyPlaying) {
        this._setPausedStatus(notify: false);
        updateType = PlayingTrackUpdateType.pausedStatus;
      }
    }
    if (updateType != null) {
      this._sendBroadcastUpdate(updateType);
    }
  }

  void _playerTimerHandler(Timer timer) {
    final PlayerState playerState = this._player.playerState;
    final bool playing = playerState.playing;
    final ProcessingState processingState = playerState.processingState;
    final position = this._player.position;
    // Update only if player is playing or completed
    PlayingTrackUpdateType updateType = PlayingTrackUpdateType.position;
    if (playing &&
        processingState != ProcessingState.loading &&
        processingState != ProcessingState.buffering &&
        processingState != ProcessingState.idle) {
      this._savePlayingPosition(position, notify: false);
    }
    this._sendBroadcastUpdate(updateType);
  }

  // Local API

  bool _loadSavedPrefs({bool notify = true}) {
    bool hasChanges = false;
    final trackId = this._prefs.getInt('playingTrackId');
    if (trackId != null && trackId != 0) {
      this._loadPlayingTrackDetails(id: trackId, notify: notify);
      hasChanges = true;
    }
    if (hasChanges && notify) {
      this._sendBroadcastUpdate(PlayingTrackUpdateType.track);
    }
    return hasChanges;
  }

  _setPausedStatus({bool notify = true}) {
    this._stopTimer();
    setState(() {
      this._isPaused = true;
    });
    if (notify) {
      this._sendBroadcastUpdate(PlayingTrackUpdateType.pausedStatus);
    }
  }

  _setPlayingStatus({bool notify = true}) {
    this._rewindIfPlayedCompletely();
    this._ensurePlayerListener();
    setState(() {
      this._isPlaying = true;
      this._isPaused = false;
    });
    if (notify) {
      this._sendBroadcastUpdate(PlayingTrackUpdateType.playingStatus);
    }
    this._ensureTimer();
  }

  _pausePlayback({bool notify = true}) {
    try {
      this._stopTimer();
      this._player.pause();
    } catch (err, stacktrace) {
      logger.e('[PlayerBox:_pausePlayback] ${err}', error: err, stackTrace: stacktrace);
      debugger();
    }
  }

  _startPlayback({bool notify = true}) {
    try {
      this._rewindIfPlayedCompletely();
      this._ensurePlayerListener();
      this._player.play(); // Returns the playback Future
      this._ensureTimer();
      this.widget.showPlayer();
    } catch (err, stacktrace) {
      logger.e('[PlayerBox:_startPlayback] ${err}', error: err, stackTrace: stacktrace);
      debugger();
    }
  }

  void _ensurePlayerListener() {
    if (!this.__listenerInstalled) {
      this._player.playerStateStream.listen(this._playerStateHandler);
      this.__listenerInstalled = true;
    }
  }

  void _stopTimer() {
    if (this.__activeTimer != null) {
      this.__activeTimer!.cancel();
      this.__activeTimer = null;
    }
  }

  void _ensureTimer() {
    // XXX: To use player updater callback?
    if (this.__activeTimer == null) {
      this.__activeTimer = Timer.periodic(Duration(milliseconds: playerTickDelayMs), this._playerTimerHandler);
    }
  }

  void _clearTrack({bool notify = true}) {
    if (this._track == null) {
      return;
    }
    if (this._isPlaying) {
      this._pausePlayback();
    }
    setState(() {
      this._track = null;
      this._position = null;
      this._isPlaying = false;
      this._isPaused = false;
      this._hasIncremented = false;
      this._isIncrementingNow = false;
    });
    if (notify) {
      this._sendBroadcastUpdate(PlayingTrackUpdateType.track);
    }
    this._prefs.setInt('playingTrackId', 0);
  }

  Future _configurePlayerForTrack() async {
    final track = this._track;
    if (track != null) {
      final String url = '${AppConfig.TALES_SERVER_HOST}${track.audio_file}';
      final String previewUrl =
          track.preview_picture.isNotEmpty ? '${AppConfig.TALES_SERVER_HOST}${track.preview_picture}' : '';
      final audioUri = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          playable: true,
          duration: track.duration,
          // Specify a unique ID for each media item:
          id: track.id.toString(),
          // Metadata to display in the notification:
          album: 'March Cat Tales'.i18n,
          title: track.title,
          artUri: previewUrl.isNotEmpty ? Uri.parse(previewUrl) : null,
        ),
      );
      return this._player.setAudioSource(audioUri);
    }
  }

  Future<void> _setTrack(Track track, {bool play = false, bool notify = true}) async {
    setState(() {
      this._track = track;
      this._hasIncremented = false;
      this._isIncrementingNow = false;
    });
    this._prefs.setInt('playingTrackId', track.id);
    try {
      final List<Future> futures = [
        this._configurePlayerForTrack(),
        this._loadTrackPosition(),
      ];
      await Future.wait(futures);
      this._player.seek(this._position ?? Duration.zero);
      if (play) {
        this._startPlayback(notify: false);
      }
      this.widget.showPlayer();
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.track);
      }
    } catch (err, stacktrace) {
      logger.e('[PlayerBox:_setTrack] ${err}', error: err, stackTrace: stacktrace);
      debugger();
    }
  }

  bool _isTrackPlayedCompletely() {
    final positionMs = this._position?.inMilliseconds;
    final durationMs = this._player.duration?.inMilliseconds;
    if (positionMs != null && durationMs != null && positionMs >= durationMs) {
      return true;
    }
    return false;
  }

  bool _rewindIfPlayedCompletely() {
    final isTrackPlayedCompletely = this._isTrackPlayedCompletely();
    if (isTrackPlayedCompletely) {
      // Reset playing position...
      this._player.seek(Duration.zero);
      this._savePlayingPosition(null, notify: false);
      setState(() {
        this._hasIncremented = false;
        this._isIncrementingNow = false;
      });
      return true;
    }
    return false;
  }

  // Public API

  void playSeekBackward() {
    final currentPosition = this._position ?? this._track?.duration;
    if (currentPosition != null) {
      final position = currentPosition - playerSeekGap;
      this.playSeek(position);
    }
  }

  void playSeekForward() {
    final currentPosition = this._position ?? Duration.zero;
    final position = currentPosition + playerSeekGap;
    this.playSeek(position);
  }

  void playSeek(Duration position) {
    if (this._track != null) {
      if (position > this._track!.duration) {
        position = this._track!.duration;
      }
      if (position < Duration.zero) {
        position = Duration.zero;
      }
      this._player.seek(position);
      this._savePlayingPosition(position);
    }
  }

  void togglePause({bool notify = true}) {
    if (this._track == null) {
      return;
    }
    final isPlaying = this._isPlaying && !this._isPaused;
    if (isPlaying) {
      this._pausePlayback(notify: notify);
    } else {
      this._startPlayback(notify: notify);
    }
  }

  void togglePlay({bool? play, bool notify = true}) {
    if (this._track == null) {
      return;
    }
    final isPlaying = this._isPlaying && !this._isPaused;
    final setPlay = play ?? !isPlaying;
    if (!setPlay) {
      this._pausePlayback(notify: notify);
    } else {
      this._startPlayback(notify: notify);
    }
  }

  void clearTrack({bool notify = true}) {
    this._clearTrack(notify: notify);
  }

  void setTrack(Track? track, {bool play = false, bool notify = true}) {
    if (track == null) {
      return this._clearTrack(notify: notify);
    }
    this._setTrack(track, play: play, notify: notify);
  }

  void toggleTrackPlay(Track? track, {bool play = false, bool notify = true}) {
    if (track != null && this._track != null && track.id == this._track!.id) {
      this.togglePlay(play: play, notify: notify);
    } else {
      this.setTrack(track, play: play, notify: notify);
    }
  }

  void _handleClick() {
    // Show track details page
    // @see https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
    // @see https://api.flutter.dev/flutter/widgets/Navigator/restorablePush.html
    if (this.widget.navigatorState != null && this._track != null) {
      this.widget.navigatorState!.restorablePushNamed(
            TrackDetailsScreen.routeName,
            arguments: this._track!.id,
          );
    }
  }

  // Widget build

  @override
  Widget build(BuildContext context) {
    final track = this._track;
    final player = this._player;

    // No active track?
    if (track == null) {
      // Display nothing if no active track
      return Container();
    }

    final isPlaying = this._isPlaying && !this._isPaused;

    return HidableWrapper(
      widgetSize: 101,
      wrap: !isPlaying,
      show: this.widget.show,
      child: StreamBuilder(
        stream: player.playerStateStream,
        builder: (context, AsyncSnapshot snapshot) {
          return PlayerWrapper(
            key: Key('PlayerWrapper-${track.id}'),
            track: track,
            playSeek: this.playSeek,
            playSeekBackward: this.playSeekBackward,
            playSeekForward: this.playSeekForward,
            togglePause: this.togglePause,
            position: this._position,
            isPlaying: this._isPlaying,
            isPaused: this._isPaused,
            positionDataStream: this._positionDataStream,
            onClick: this._handleClick,
          );
        },
      ),
    );
  }
}
