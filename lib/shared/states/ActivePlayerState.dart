import 'dart:async';
import 'dart:developer';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

mixin ActivePlayerState {
  void notifyListeners();
  SharedPreferences? getPrefs();

  /// Player & active track

  Track? playingTrack;
  Duration? playingPosition;
  Duration? playingDuration;
  bool isPlaying = false;
  bool isPaused = false;
  AudioPlayer activePlayer = AudioPlayer();
  Timer? activeTimer;

  bool loadActivePlayerStateSavedPrefs({bool notify = true}) {
    final trackId = this.getPrefs()?.getInt('playingTrackId');
    bool hasChanges = false;
    if (trackId != null && trackId != 0) {
      loadPlayingTrackDetails(id: trackId, notify: notify);
      hasChanges = true;
    }
    final positionMs = this.getPrefs()?.getInt('playingPositionMs');
    if (positionMs != null && positionMs != 0) {
      this.playingPosition = Duration(milliseconds: positionMs);
      hasChanges = true;
    }
    final durationMs = this.getPrefs()?.getInt('playingDurationMs');
    if (durationMs != null && durationMs != 0) {
      this.playingDuration = Duration(milliseconds: durationMs);
      hasChanges = true;
    }
    if (hasChanges && notify) {
      // TODO: Avoid duplicated notifications here and in async `loadPlayingTrackDetails`
      this.notifyListeners();
    }
    return hasChanges;
  }

  Track? getPlayingTrack() {
    return this.playingTrack;
  }

  Future setPlayingTrack(Track? track, {bool notify = true}) async {
    if (this.playingTrack != track) {
      this.playingTrack = track;
      // this.setPlayingPosition(null, notify: false);
      this.getPrefs()?.setInt('playingTrackId', track?.id ?? 0);
      if (track != null) {
        final player = this.getPlayer();
        debugger;
        final String url = '${AppConfig.TALES_SERVER_HOST}${track.audio_file}';
        // @see https://github.com/ryanheise/just_audio/tree/minor/just_audio
        logger.t('setPlayingTrack: Start playing track ${track}: ${url}');
        final duration = await player.setUrl(url);
        // TODO: Process audio url loading errors
        this
            .getPrefs()
            ?.setInt('playingDurationMs', duration?.inMilliseconds ?? 0);
        player.setVolume(1); // ???
      }
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  void setPlayingPosition(Duration? position, {bool notify = true}) {
    this.playingPosition = position;
    final positionMs = position?.inMilliseconds ?? 0;
    this.getPrefs()?.setInt('playingPositionMs', positionMs);
    if (notify) {
      this.notifyListeners();
    }
  }

  void setPlayingDuration(Duration? duration, {bool notify = true}) {
    this.playingDuration = duration;
    final durationMs = duration?.inMilliseconds ?? 0;
    this.getPrefs()?.setInt('playingDurationMs', durationMs);
    if (notify) {
      this.notifyListeners();
    }
  }

  Future<Track?> loadPlayingTrackDetails(
      {required int id, bool notify = true}) async {
    if (id != 0) {
      // Update `playingTrack` if language has been changed
      final track = await loadTrackDetails(id: id);
      this.setPlayingTrack(track, notify: notify);
    }
    return this.playingTrack;
  }

  Future<Track?> ensureLoadedPlayingTrackDetails({bool notify = true}) async {
    if (this.playingTrack != null) {
      // Update `playingTrack` if language has been changed
      loadPlayingTrackDetails(id: this.playingTrack!.id, notify: notify);
    }
    return this.playingTrack;
  }

  AudioPlayer getPlayer() {
    return this.activePlayer;
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
    final player = this.activePlayer;
    if (!_listenerInstalled) {
      player.playerStateStream.listen(this._updatePlayerStatus);
      _listenerInstalled = true;
    }
  }
  void _updatePlayerStatus([PlayerState? _]) {
    final player = this.activePlayer;
    final PlayerState playerState = player.playerState;
    // final bool playing = playerState.playing;
    final ProcessingState processingState = playerState.processingState;
    final position = player.position;
    final duration = player.duration;
    // logger.t(
    //     '_updatePlayerStatus: playing: position=${position} duration=${duration} ${playerState}');
    logger.t('_updatePlayerStatus: ${position}/${duration}');
    this.setPlayingPosition(position, notify: false);
    if (processingState == ProcessingState.completed) {
      this._playerStop(notify: false);
      // // Set position to the full dration value: as sign of the finished playback
      this.setPlayingPosition(duration, notify: false);
      logger.t('_updatePlayerStatus: Finish! ${position}/${duration}');
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
    // TODO: Use player updater callback?
    this.activeTimer = Timer.periodic(Duration(milliseconds: playerTickDelayMs),
        (_) => this._updatePlayerStatus());
  }

  void _playerStart(Track track) async {
    // TODO: If player has loaded data
    this._setPlayerListener();
    final playing = this.activePlayer.play(); // Returns the Future
    // TODO: Increment played count (via API)
    this.isPlaying = true;
    this.isPaused = false;
    // Finished hadler
    playing.whenComplete(() {
      if (this.playingTrack?.id == track.id && this.isPlaying) {
        // If the same track is playing
        logger.t(
            '_playerStart: Finished: track: ${track}, playingTrack: ${this.playingTrack}, isPaused: ${this.isPaused}');
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

  bool isTrackPlayedCompletely() {
    final positionMs = this.playingPosition?.inMilliseconds;
    final durationMs = this.activePlayer.duration?.inMilliseconds;
    if (positionMs != null && durationMs != null && positionMs >= durationMs) {
      return true;
    }
    return false;
  }

  /// Track's play button handler
  void playTrack(Track track) async {
    logger.t('playTrack ${track}');
    if (this.playingTrack != null) {
      if (this.isPlaying && this.playingTrack!.id == track.id) {
        // Just pause/resume and exit if it was actively playing current track
        logger.t(
            'playTrack: Pausing/resuming active track: ${this.playingTrack} isPaused: ${this.isPaused}');
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
      // TODO: Get position for the new track from a local db
      this.activePlayer.seek(Duration.zero);
      this.setPlayingPosition(null, notify: false);
      this.setPlayingDuration(null, notify: false);
      // Set new track
      await this.setPlayingTrack(track, notify: false);
    } else if (this.isTrackPlayedCompletely()) {
      // Reset playing position...
      this.activePlayer.seek(Duration.zero);
      this.setPlayingPosition(null, notify: false);
    }
    this._playerStart(track);
  }
}
