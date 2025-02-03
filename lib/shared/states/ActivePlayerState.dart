import 'dart:async';
import 'dart:developer';
import 'package:logger/logger.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/api-methods/incrementPlayedCount.dart';

final logger = Logger();

mixin ActivePlayerState {
  // Abstract interfaces for other mixins/parents...
  void notifyListeners();
  SharedPreferences? getPrefs();
  void updateSingleTrack(Track track, {bool notify = true});

  // Player & active track

  Track? playingTrack;

  Duration? playingPosition;
  Duration? playingDuration;

  bool hasIncremented = false;
  bool isIncrementingNow = false;
  bool isPlaying = false;
  bool isPaused = false;

  /// @see https://github.com/ryanheise/just_audio/tree/minor/just_audio
  AudioPlayer activePlayer = AudioPlayer();

  Timer? activeTimer;

  /// Callback to initalize player state from shared memory
  bool loadActivePlayerStateSavedPrefs({bool notify = true}) {
    final trackId = this.getPrefs()?.getInt('playingTrackId');
    bool hasChanges = false;
    if (trackId != null && trackId != 0) {
      this._loadPlayingTrackDetails(id: trackId, notify: notify);
      hasChanges = true;
    }
    if (hasChanges && notify) {
      // TODO: Avoid duplicated notifications here and in async `_loadPlayingTrackDetails`
      this.notifyListeners();
    }
    return hasChanges;
  }

  /// Get currently playing track
  Track? getPlayingTrack() {
    return this.playingTrack;
  }

  _loadPositionAndDurationForTrack(Track? track, {bool notify = true}) async {
    if (track == null) {
      return;
    }
    final trackInfo = await tracksInfoDb.getById(track.id);
    this.playingPosition = trackInfo?.position; // ?? Duration.zero;
    if (this.playingPosition == null ||
        this.playingPosition?.inMilliseconds == 0) {
      debugger();
    }
    // this.activePlayer.seek(this.playingPosition ?? Duration.zero);
    if (this.playingPosition?.inMilliseconds == 0) {
      debugger();
    }
    this.playingDuration =
        trackInfo?.duration; // ?? Duration(seconds: track.audio_duration);
    if (notify) {
      this.notifyListeners();
    }
  }

  Future _setPlayingTrack(Track? track, {bool notify = true}) async {
    if (this.playingTrack?.id != track?.id) {
      this.playingTrack = track;
      this.getPrefs()?.setInt('playingTrackId', track?.id ?? 0);
      if (track != null) {
        await this._loadPositionAndDurationForTrack(track, notify: false);
        final String url = '${AppConfig.TALES_SERVER_HOST}${track.audio_file}';
        final duration = await this.activePlayer.setUrl(url);
        // logger.t('[ActivePlayerState:_setPlayingTrack]: Start playing track ${track}: url=${url} playingPosition=${this.playingPosition}');
        this.activePlayer.seek(this.playingPosition ?? Duration.zero);
        this.playingDuration = duration;
        // Update duration in TracksInfoDb
        tracksInfoDb.updatePosition(this.playingTrack!.id, duration: duration);
      }
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  void _savePlayingPosition(Duration? position, {bool notify = true}) {
    this.playingPosition = position;
    if (notify) {
      this.notifyListeners();
    }
  }

  Future<Track?> _loadPlayingTrackDetails(
      {required int id, bool notify = true}) async {
    if (id != 0) {
      // Update `playingTrack` if language has been changed
      final track = await loadTrackDetails(id: id);
      await this._setPlayingTrack(track, notify: notify);
    }
    return this.playingTrack;
  }

  /// Load or update active track details
  Future<Track?> ensureLoadedPlayingTrackDetails({bool notify = true}) async {
    if (this.playingTrack != null) {
      // Update `playingTrack` if language has been changed
      this._loadPlayingTrackDetails(id: this.playingTrack!.id, notify: notify);
    }
    return this.playingTrack;
  }

  void _playerStop({bool notify = true}) {
    this._playerTimerStop();
    if (this.activePlayer.playing) {
      this.activePlayer.stop();
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
      this.activePlayer.playerStateStream.listen(this._updatePlayerStatus);
      _listenerInstalled = true;
    }
  }

  void _incrementCurrentTrackPlayedCount() async {
    if (this.playingTrack == null ||
        this.hasIncremented ||
        this.isIncrementingNow) {
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
      logger.e('[_incrementCurrentTrackPlayedCount] ${err}',
          error: err, stackTrace: stacktrace);
      debugger();
    } finally {
      this.isIncrementingNow = false;
    }
  }

  void _updatePlayerStatus([PlayerState? _]) {
    final PlayerState playerState = this.activePlayer.playerState;
    final bool playing = playerState.playing;
    final ProcessingState processingState = playerState.processingState;
    final position = this.activePlayer.position;
    final duration = this.activePlayer.duration;
    // Update only if player is playing or completed
    if (playing &&
        processingState != ProcessingState.loading &&
        processingState != ProcessingState.buffering &&
        processingState != ProcessingState.idle) {
      // logger.t('[ActivePlayerState:_updatePlayerStatus] playing=${playing} processingState=${processingState} position=${position}');
      this._savePlayingPosition(position, notify: false);
      // Update the data in the local db (don't waiting for the finish)
      /* await */
      tracksInfoDb.updatePosition(this.playingTrack!.id,
          position: position, duration: duration);
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
    this.activeTimer = Timer.periodic(Duration(milliseconds: playerTickDelayMs),
        (_) => this._updatePlayerStatus());
  }

  void _playerStart(Track track) async {
    // XXX: To check if player has loaded data
    this._setPlayerListener();
    final playing = this.activePlayer.play(); // Returns the Future
    this.isPlaying = true;
    this.isPaused = false;
    this.hasIncremented = false;
    this.isIncrementingNow = false;
    // Finished hadler
    playing.whenComplete(() {
      if (this.playingTrack?.id == track.id && this.isPlaying) {
        // If the same track is playing
        // logger.t('_playerStart: Finished: track: ${track}, playingTrack: ${this.playingTrack}, isPaused: ${this.isPaused}');
        if (!this.isPaused) {
          this._playerStop(notify: true);
        }
      }
    });
    // Start timer...
    _playerTimerStart();
    // Update all...
    this.notifyListeners();
  }

  bool _isTrackPlayedCompletely() {
    final positionMs = this.playingPosition?.inMilliseconds;
    final durationMs = this.activePlayer.duration?.inMilliseconds;
    if (positionMs != null && durationMs != null && positionMs >= durationMs) {
      return true;
    }
    return false;
  }

  /// Track's play button handler
  void playTrack(Track track) async {
    if (this.playingTrack != null) {
      if (this.isPlaying && this.playingTrack!.id == track.id) {
        // Just pause/resume and exit if it was actively playing current track
        if (!this.isPaused) {
          this.activePlayer.pause();
          this.isPaused = true;
          this._playerTimerStop();
        } else {
          this.activePlayer.play();
          this.isPaused = false;
          _playerTimerStart();
        }
        this.notifyListeners();
        return;
      }
      // Else stop playback and continue
      this._playerStop(notify: false);
    }
    // Start playing the track
    if (this.playingTrack?.id != track.id) {
      // Set new track
      await this._setPlayingTrack(track, notify: false);
    }
    if (this._isTrackPlayedCompletely()) {
      // Reset playing position...
      this.activePlayer.seek(Duration.zero);
      this._savePlayingPosition(null, notify: false);
    }
    this._playerStart(track);
  }
}
