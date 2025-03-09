import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart' hide TrackInfo;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/components/PlayerWrapper.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/core/singletons/playingTrackEvents.dart';
import 'package:march_tales_app/core/types/PlayingTrackUpdate.dart';
import 'package:march_tales_app/features/Track/api-methods/incrementPlayedCount.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'PlayerBox.i18n.dart';

// import 'package:audio_session/audio_session.dart';

final logger = Logger();

// NOTE: This module shouldn't use `AppState` due to one-way control flow (it's used in `ActivePlayerState`)

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class PlayerBox extends StatefulWidget {
  const PlayerBox({
    super.key,
  });

  @override
  State<PlayerBox> createState() => PlayerBoxState();
}

class PlayerBoxState extends State<PlayerBox> {
  late AudioPlayer _player;
  Track? _track;
  late SharedPreferences _prefs;
  Duration? _position;
  bool _hasIncremented = false;
  bool _isIncrementingNow = false;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool __listenerInstalled = false;
  Timer? __activeTimer;

  @override
  void dispose() {
    this._player.dispose();
    super.dispose();
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

  void _savePlayingPosition(Duration? position, {bool notify = true}) {
    setState(() {
      this._position = position;
    });
    if (notify) {
      this._sendBroadcastUpdate(PlayingTrackUpdateType.position);
    }
    // Save position to local db
    tracksInfoDb.updatePosition(this._track!.id, position: position ?? Duration.zero); // await!
    // TODO -- 2025.03.01, 21:06 -- Update position on the server
    // TODO: Involve last saved position and save once in a period, eg, 5 secs
  }

  Future<void> _loadTrackPosition() async {
    if (this._track != null) {
      // TODO: Load data from the server if isAuthorized
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
      final List<Future> futures = [
        incrementPlayedCount(id: id),
        tracksInfoDb.incrementPlayedCount(this._track!.id),
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
      final track = await loadTrackDetails(id);
      this._track = track;
      await this._setTrack(track, notify: notify);
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
    // logger.t('[PlayerBox:_playerStateHandler] playing=${playing} processingState=${processingState}');
    final duration = this._player.duration;
    // Update only if player is playing or completed
    PlayingTrackUpdateType? updateType;
    final isCurrentlyPlaying = this._isPlaying && !this._isPaused;
    if (playing) {
      // Really playing and...
      if (!isCurrentlyPlaying) {
        // logger.t('[PlayerBox:_playerStateHandler] set state: playing');
        this._setPlayingStatus(notify: false);
        updateType = PlayingTrackUpdateType.playingStatus;
      } else if (processingState == ProcessingState.completed) {
        // logger.t('[PlayerBox:_playerStateHandler] set state: finished');
        this._pausePlayback(notify: false);
        this._setPausedStatus(notify: false);
        // Set position to the full dration value: as sign of the finished playback
        this._savePlayingPosition(duration, notify: false);
        updateType = PlayingTrackUpdateType.pausedStatus;
        this._incrementCurrentTrackPlayedCount();
      }
    } else {
      // Not rally playing and...
      if (isCurrentlyPlaying) {
        // logger.t('[PlayerBox:_playerStateHandler] set state: paused');
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

    return StreamBuilder(
      stream: player.playerStateStream,
      builder: (context, AsyncSnapshot snapshot) {
        return PlayerWrapper(
          key: Key('PlayerWrapper_${track.id}'),
          track: track,
          playSeek: this.playSeek,
          playSeekBackward: this.playSeekBackward,
          playSeekForward: this.playSeekForward,
          togglePause: this.togglePause,
          position: this._position,
          isPlaying: this._isPlaying,
          isPaused: this._isPaused,
        );
      },
    );
  }
}
