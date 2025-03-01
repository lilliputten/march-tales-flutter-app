import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart' hide TrackInfo;
import 'package:logger/logger.dart';

import 'package:march_tales_app/components/PlayerWrapper.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/core/singletons/playingTrackEvents.dart';
import 'package:march_tales_app/core/types/PlayingTrackUpdate.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

// NOTE: This module can't use `AppState` due to one-way control flow (it's used in `ActivePlayerState`)

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class PlayerBox extends StatefulWidget {
  const PlayerBox({
    super.key,
    // this.track,
  });

  // final Track? track;

  @override
  State<PlayerBox> createState() => PlayerBoxState();
}

class PlayerBoxState extends State<PlayerBox> {
  late AudioPlayer _player;
  Track? _track;
  Duration? _position;
  bool _isPlaying = false;
  bool _isPaused = false;
  bool __listenerInstalled = false;
  Timer? __activeTimer;

  bool _checkConfiguration() => true;

  @override
  void dispose() {
    this._player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this._player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    if (_checkConfiguration()) {
      this._initWithContext();
    }
  }

  _initWithContext() {
    /* // DEBUG: Access context during initState stage
     * Future.delayed(Duration.zero, () {
     *   if (context.mounted) {
     *     final appState = context.read<AppState>(); // .watch<AppState>();
     *     final playerState = appState.playerBoxKey?.currentState;
     *     final playerWidget = appState.playerBoxKey?.currentWidget;
     *     logger.t(
     *         '[PlayerBox:initState] playerWidget=${playerWidget} playerState=${playerState} context=${context} appState=${appState} player=${this._player}');
     *     debugger();
     *     appState.setAudioPlayer(this._player);
     *   }
     * });
     */
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  void _savePlayingPosition(Duration? position, {bool notify = true}) {
    setState(() {
      this._position = position;
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.position);
      }
    });
    // Save position to local db
    tracksInfoDb.updatePosition(this._track!.id, position: position ?? Duration.zero); // await!
    // TODO -- 2025.03.01, 21:06 -- Update position on the server
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

  // Local API

  void _playerStop({bool notify = true}) {
    this._playerTimerStop();
    final activePlayer = this.getPlayer();
    if (activePlayer != null && activePlayer.playing) {
      activePlayer.stop();
    }
    setState(() {
      this._isPlaying = false;
      this._isPaused = false;
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.playingStatus);
      }
    });
  }

  void _playerStart({bool notify = true}) async {
    final isTrackPlayedCompletely = this.isTrackPlayedCompletely();
    if (isTrackPlayedCompletely) {
      // Reset playing position...
      this._player.seek(Duration.zero);
      this._savePlayingPosition(null, notify: false);
    }
    this._setPlayerListener();
    this._player.play(); // Returns the playback Future
    setState(() {
      this._isPlaying = true;
      this._isPaused = false;
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.playingStatus);
      }
    });
    // TODO? 2025.03.01, 20:54
    // this.hasIncremented = false;
    // this.isIncrementingNow = false;
    // Start timer...
    _playerTimerStart();
  }

  void _updatePlayerStatus([PlayerState? _]) {
    final PlayerState playerState = this._player.playerState;
    final bool playing = playerState.playing;
    final ProcessingState processingState = playerState.processingState;
    final position = this._player.position;
    final duration = this._player.duration;
    // Update only if player is playing or completed
    PlayingTrackUpdateType updateType = PlayingTrackUpdateType.position;
    if (playing &&
        processingState != ProcessingState.loading &&
        processingState != ProcessingState.buffering &&
        processingState != ProcessingState.idle) {
      // logger.t('[PlayerBox:_updatePlayerStatus] playing=${playing} processingState=${processingState} position=${position}');
      this._savePlayingPosition(position, notify: false);
    }
    if (processingState == ProcessingState.completed) {
      // this._incrementCurrentTrackPlayedCount(); // TODO: 2025.03.01, 20:50
      this._playerStop(notify: false);
      // Set position to the full dration value: as sign of the finished playback
      this._savePlayingPosition(duration, notify: false);
      // logger.t('_updatePlayerStatus: Finished! ${position}/${duration}');
      updateType = PlayingTrackUpdateType.playingStatus;
    }
    // this.notifyListeners();
    this._sendBroadcastUpdate(updateType);
  }

  void _setPlayerListener() {
    if (!this.__listenerInstalled) {
      this._player.playerStateStream.listen(this._updatePlayerStatus);
      this.__listenerInstalled = true;
    }
  }

  void _playerTimerStop() {
    if (this.__activeTimer != null) {
      this.__activeTimer!.cancel();
      this.__activeTimer = null;
    }
  }

  void _playerTimerStart() {
    // XXX: To use player updater callback?
    this.__activeTimer = Timer.periodic(Duration(milliseconds: playerTickDelayMs), (_) => this._updatePlayerStatus());
  }

  void _clearTrack({bool notify = true}) {
    if (this._track == null) {
      return;
    }
    if (this._isPlaying) {
      this.pause();
    }
    setState(() {
      this._track = null;
      this._position = null;
      this._isPlaying = false;
      this._isPaused = false;
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.track);
      }
    });
  }

  Future<void> _setTrack(Track track, {bool play = false, bool notify = true}) async {
    setState(() {
      this._track = track;
      this._position = null;
      this._isPlaying = play;
      this._isPaused = false;
    });
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
        album: "March Cat Tales",
        title: track.title,
        artUri: previewUrl.isNotEmpty ? Uri.parse(previewUrl) : null,
      ),
    );
    logger.t('[PlayerBox:_setTrack] track=${track} play=${play} notify=${notify} audioUri=${audioUri}');
    try {
      final List<Future> futures = [
        this._player.setAudioSource(audioUri),
        this._loadTrackPosition(),
      ];
      await Future.wait(futures);
      this._player.seek(this._position ?? Duration.zero);
      if (play) {
        this._playerStart(notify: false);
      }
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.track);
      }
    } catch (err, stacktrace) {
      // Catch load errors: 404, invalid url ...
      logger.e('[PlayerBox:_setTrack] ${err}', error: err, stackTrace: stacktrace);
      debugger();
      // TODO: Show toast
    }
  }

  // Public API

  AudioPlayer? getPlayer() {
    return this._player;
  }

  Track? getTrack() {
    return this._track;
  }

  bool isTrackPlayedCompletely() {
    final positionMs = this._position?.inMilliseconds;
    final durationMs = this._player.duration?.inMilliseconds;
    if (positionMs != null && durationMs != null && positionMs >= durationMs) {
      return true;
    }
    return false;
  }

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

  void pause({bool notify = true}) {
    this._player.pause();
    setState(() {
      this._isPaused = true;
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.pausedStatus);
      }
    });
    this._playerTimerStop();
  }

  void resume({bool notify = true}) {
    this._player.play();
    setState(() {
      this._isPaused = false;
      if (notify) {
        this._sendBroadcastUpdate(PlayingTrackUpdateType.pausedStatus);
      }
    });
    this._playerTimerStart();
  }

  void togglePause({bool notify = true}) {
    if (!this._isPaused) {
      this.pause(notify: notify);
    } else {
      this.resume(notify: notify);
    }
  }

  void stop({bool notify = true}) {
    this._playerStop(notify: notify);
  }

  void start({bool notify = true}) {
    this._playerStart(notify: notify);
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

  // Widget build

  @override
  Widget build(BuildContext context) {
    final track = this._track; // widget.track;
    final player = this._player;

    // No active track?
    if (track == null) {
      // this._clearTrack();
      // Display nothing if no active track
      return Container();
    }

    return StreamBuilder(
      // key: _key,
      stream: player.playerStateStream,
      builder: (context, AsyncSnapshot snapshot) {
        // final PlayerState? playerState = snapshot.data;
        // final bool? playing = playerState?.playing;
        // final ProcessingState? processingState = playerState?.processingState;
        // final position = player.position;
        // final duration = player.duration;
        // logger.t('PlayerBox: playing: ${playing} processingState: ${processingState} position: ${position} duration: ${duration} ${playerState}');
        // appState.updatePlayerStatus(playerState);
        // int currentIndex = snapshot.data ?? 0;
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
