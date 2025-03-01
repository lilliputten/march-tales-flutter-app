import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/features/Track/api-methods/incrementPlayedCount.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

mixin ActivePlayerState {
  // Abstract interfaces for other mixins/parents...
  void notifyListeners();
  SharedPreferences? getPrefs();
  void updateSingleTrack(Track track, {bool notify = true}); // TrackState

  // Player & active track

  // TODO: To use PlayerBox as an audio controller (use it via `playerBoxKey?.currentState`)
  GlobalKey<PlayerBoxState>? playerBoxKey; // NOTE: One-way flow!

  Track? playingTrack;

  Duration? playingPosition;
  // Duration? playingDuration;

  bool hasIncremented = false;
  bool isIncrementingNow = false;
  bool isPlaying = false;
  bool isPaused = false;

  // Timer? activeTimer;

  PlayerBoxState? getPlayerBoxState() {
    return this.playerBoxKey?.currentState;
  }

  AudioPlayer? getPlayer() {
    final playerBoxState = getPlayerBoxState();
    final AudioPlayer? player = playerBoxState?.getPlayer();
    return player;
  }

  /// Callback to initalize player state from shared memory
  bool loadActivePlayerStateSavedPrefs({bool notify = true}) {
    final trackId = this.getPrefs()?.getInt('playingTrackId');
    bool hasChanges = false;
    if (trackId != null && trackId != 0) {
      this._loadPlayingTrackDetails(id: trackId, notify: notify);
      hasChanges = true;
    }
    if (hasChanges && notify) {
      this.notifyListeners();
    }
    return hasChanges;
  }

  // /// Get currently playing track
  // Track? getPlayingTrack() {
  //   return this.playingTrack;
  // }

  /*
   * _loadPositionForTrack(Track? track, {bool notify = true}) async {
   *   if (track == null) {
   *     return;
   *   }
   *   final trackInfo = await tracksInfoDb.getById(track.id);
   *   this.playingPosition = trackInfo?.position; // ?? Duration.zero;
   *   if (notify) {
   *     this.notifyListeners();
   *   }
   * }
   */

  Future _setPlayingTrack(Track? track, {bool notify = true}) async {
    if (this.playingTrack?.id != track?.id) {
      this.playingTrack = track;
      /*
       * this.getPrefs()?.setInt('playingTrackId', track?.id ?? 0);
       * if (track != null) {
       *   await this._loadPositionForTrack(track, notify: false);
       *   final String url = '${AppConfig.TALES_SERVER_HOST}${track.audio_file}';
       *   final String previewUrl =
       *       track.preview_picture.isNotEmpty ? '${AppConfig.TALES_SERVER_HOST}${track.preview_picture}' : '';
       *   final audioUri = AudioSource.uri(
       *     Uri.parse(url),
       *     tag: MediaItem(
       *       playable: true,
       *       duration: track.duration,
       *       // Specify a unique ID for each media item:
       *       id: track.id.toString(),
       *       // Metadata to display in the notification:
       *       album: "March Cat Tales",
       *       title: track.title,
       *       artUri: previewUrl.isNotEmpty ? Uri.parse(previewUrl) : null,
       *     ),
       *   );
       *   logger.t('[ActivePlayerState:_setPlayingTrack] audioUri=${audioUri}');
       *   final activePlayer = this.getPlayer();
       *   await activePlayer?.setAudioSource(audioUri);
       *   // await this.activePlayer.setUrl(url);
       *   // logger.t('[ActivePlayerState:_setPlayingTrack]: Start playing track ${track}: url=${url} playingPosition=${this.playingPosition}');
       *   activePlayer?.seek(this.playingPosition ?? Duration.zero);
       * }
       */
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  /*
  void _savePlayingPosition(Duration? position, {bool notify = true}) {
    this.playingPosition = position;
    if (notify) {
      this.notifyListeners();
    }
  }
  */

  Future<Track?> _loadPlayingTrackDetails({required int id, bool notify = true}) async {
    // TODO: Move to PlayerBox?
    if (id != 0) {
      // Update `playingTrack` if language has been changed
      final track = await loadTrackDetails(id: id);
      await this._setPlayingTrack(track, notify: notify);
    }
    return this.playingTrack;
  }

  Future<Track?> updatePlayingTrackDetails({bool notify = true}) async {
    // TODO: Move to PlayerBox
    if (this.playingTrack != null) {
      this.playingTrack = await loadTrackDetails(id: this.playingTrack!.id);
      if (notify) {
        this.notifyListeners();
      }
    }
    return this.playingTrack;
  }

  /// Load or update active track details
  Future<Track?> ensureLoadedPlayingTrackDetails({bool notify = true}) async {
    if (this.playingTrack != null) {
      // Update `playingTrack` if language has been changed
      await this._loadPlayingTrackDetails(id: this.playingTrack!.id, notify: notify);
    }
    return this.playingTrack;
  }

  /*
  void _playerStop({bool notify = true}) {
    this._playerTimerStop();
    final activePlayer = this.getPlayer();
    if (activePlayer != null && activePlayer.playing) {
      activePlayer.stop();
    }
    this.isPlaying = false;
    this.isPaused = false;
    if (notify) {
      this.notifyListeners();
    }
  }

  bool _listenerInstalled = false;

  void _setPlayerListener() {
    if (!_listenerInstalled) {
      final activePlayer = this.getPlayer();
      activePlayer?.playerStateStream.listen(this._updatePlayerStatus);
      _listenerInstalled = true;
    }
  }
  */

  void _incrementCurrentTrackPlayedCount() async {
    // TODO: Move to `PlayerBox`
    if (this.playingTrack == null || this.hasIncremented || this.isIncrementingNow) {
      return;
    }
    this.isIncrementingNow = true;
    final id = this.playingTrack!.id;
    try {
      // Increment the count simultaneously on the server and in the local database...
      final List<Future> futures = [
        incrementPlayedCount(id: id),
        tracksInfoDb.incrementPlayedCount(this.playingTrack!.id),
      ];
      final results = await Future.wait(futures);
      // Get and store udpated server track data
      final Track updatedTrack = results[0];
      this.hasIncremented = true;
      this.updateSingleTrack(updatedTrack, notify: true);
    } catch (err, stacktrace) {
      logger.e('[_incrementCurrentTrackPlayedCount] ${err}', error: err, stackTrace: stacktrace);
      debugger();
    } finally {
      this.isIncrementingNow = false;
    }
  }

  /*
  void _updatePlayerStatus([PlayerState? _]) {
    final activePlayer = this.getPlayer();
    if (activePlayer == null) {
      return;
    }
    final PlayerState playerState = activePlayer.playerState;
    final bool playing = playerState.playing;
    final ProcessingState processingState = playerState.processingState;
    final position = activePlayer.position;
    final duration = activePlayer.duration;
    // Update only if player is playing or completed
    if (playing &&
        processingState != ProcessingState.loading &&
        processingState != ProcessingState.buffering &&
        processingState != ProcessingState.idle) {
      // logger.t('[ActivePlayerState:_updatePlayerStatus] playing=${playing} processingState=${processingState} position=${position}');
      this._savePlayingPosition(position, notify: false);
      // Update the data in the local db (and don't wait for the finish)
      tracksInfoDb.updatePosition(this.playingTrack!.id, position: position); // await!
    }
    if (processingState == ProcessingState.completed) {
      this._incrementCurrentTrackPlayedCount();
      this._playerStop(notify: false);
      // Set position to the full dration value: as sign of the finished playback
      this._savePlayingPosition(duration, notify: false);
      // logger.t('_updatePlayerStatus: Finished! ${position}/${duration}');
    }
    this.notifyListeners();
  }

  void _playerTimerStop() {
    if (this.activeTimer != null) {
      this.activeTimer!.cancel();
      this.activeTimer = null;
    }
  }

  void _playerTimerStart() {
    // XXX: To use player updater callback?
    this.activeTimer = Timer.periodic(Duration(milliseconds: playerTickDelayMs), (_) => this._updatePlayerStatus());
  }

  void _playerStart(Track track) async {
    final activePlayer = this.getPlayer();
    if (activePlayer == null) {
      return;
    }
    final playerBoxState = this.getPlayerBoxState();
    final isTrackPlayedCompletely = playerBoxState?.isTrackPlayedCompletely() ?? false;
    if (isTrackPlayedCompletely) {
      // Reset playing position...
      activePlayer.seek(Duration.zero);
      this._savePlayingPosition(null, notify: false);
    }
    this._setPlayerListener();
    activePlayer.play(); // Returns the playback Future
    this.isPlaying = true;
    this.isPaused = false;
    this.hasIncremented = false;
    this.isIncrementingNow = false;
    // Start timer...
    _playerTimerStart();
    // Update all...
    this.notifyListeners();
  }
  */

  /// Track's play button handler
  void setPlayingTrack(Track track, {bool play = true}) async {
    final playerBoxState = this.getPlayerBoxState();
    if (playerBoxState == null) {
      return;
    }
    playerBoxState.setTrack(track, play: play);
    return;
    final Track? playingTrack = playerBoxState.getTrack();
    if (playingTrack != null) {
      if (this.isPlaying && playingTrack.id == track.id) {
        playerBoxState.togglePause(notify: true);
        /*
         * final activePlayer = this.getPlayer();
         * // Just pause/resume and exit if it was actively playing current track
         * if (!this.isPaused) {
         *   activePlayer?.pause();
         *   this.isPaused = true;
         *   this._playerTimerStop();
         * } else {
         *   activePlayer?.play();
         *   this.isPaused = false;
         *   _playerTimerStart();
         * }
         * this.notifyListeners();
         */
        return;
      }
      // Else stop playback and continue
      // this._playerStop(notify: false);
      playerBoxState.stop(notify: false);
    }
    // // Start playing the track
    // if (playingTrack?.id != track.id) {
    //   // Set new track
    //   await this._setPlayingTrack(track, notify: false);
    // }
    await this._setPlayingTrack(track, notify: false);
    // if (play) {
    //   // this._playerStart(track);
    //   playerBoxState.play(notify: true);
    // } else {
    //   // this.notifyListeners();
    // }
  }

  /*
  void playSeekBackward() {
    final currentPosition = this.playingPosition ?? this.playingTrack?.duration;
    if (currentPosition != null) {
      final position = currentPosition - playerSeekGap;
      this.playSeek(position);
    }
  }

  void playSeekForward() {
    final currentPosition = this.playingPosition ?? Duration.zero;
    final position = currentPosition + playerSeekGap;
    this.playSeek(position);
  }

  void playSeek(Duration position) {
    if (this.playingTrack != null) {
      if (position > this.playingTrack!.duration) {
        position = this.playingTrack!.duration;
      }
      if (position < Duration.zero) {
        position = Duration.zero;
      }
      final activePlayer = this.getPlayer();
      activePlayer?.seek(position);
      tracksInfoDb.updatePosition(this.playingTrack!.id, position: position); // await!
      this._savePlayingPosition(position);
    }
  }
  */
}
