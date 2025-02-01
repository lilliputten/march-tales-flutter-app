import 'dart:async';
import 'package:logger/logger.dart';

import 'package:just_audio/just_audio.dart';

import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

const int defaultTracksDownloadLimit = 2;

final logger = Logger();

mixin ActivePlayerState {
  void notifyListeners();

  /// Player & active track

  Track? playingTrack;
  bool isPlaying = false;
  bool isPaused = false;
  AudioPlayer? activePlayer = AudioPlayer();
  Timer? activeTimer;
  Duration? activePosition;

  Track? getPlayingTrack() {
    return playingTrack;
  }

  Future<Track?> ensureLoadedPlayingTrackDetails({bool notify = true}) async {
    if (playingTrack != null) {
      // Update `playingTrack` if language has been changed
      playingTrack = await loadTrackDetails(id: playingTrack!.id);
    }
    notifyListeners();
    return playingTrack;
  }

  void setPlayingTrack(Track? value, {bool notify = true}) {
    playingTrack = value;
    if (notify) {
      notifyListeners();
    }
  }

  AudioPlayer getPlayer() {
    activePlayer ??= AudioPlayer();
    return activePlayer!;
  }

  void _playerStop({bool notify = true}) {
    activePosition = null;
    _playerTimerStop();
    if (activePlayer != null) {
      activePlayer!.stop();
      activePlayer = null;
    }
    isPlaying = false;
    isPaused = false;
    if (notify) {
      notifyListeners();
    }
  }

  void _playerTimerTick(Timer timer) {
    activePosition = activePlayer?.position;
    final position = activePosition?.inMilliseconds;
    final duration = activePlayer?.duration?.inMilliseconds;
    logger.t(
        '_playerTimerTick: Tick: ${timer.tick} position=${position} duration=${duration}');
    if (position! >= duration!) {
      _playerStop(notify: false);
    }
    notifyListeners();
  }

  void _playerTimerStop() {
    if (activeTimer != null) {
      activeTimer!.cancel();
      activeTimer = null;
    }
  }

  void _playerTimerStart() {
    activeTimer = Timer.periodic(Duration(seconds: 1), _playerTimerTick);
  }

  void _playerStart(Track track) async {
    playingTrack = track;
    final String url = '${AppConfig.TALES_SERVER_HOST}${track.audio_file}';
    final player = getPlayer();
    // @see https://github.com/ryanheise/just_audio/tree/minor/just_audio
    logger.t('_playerStart: Start playing track ${track}: ${url}');
    final duration = await player.setUrl(url);
    player.setVolume(1);
    final playing = player.play(); // Returns the Future
    // TODO: Increment played count (via API)
    isPlaying = true;
    isPaused = false;
    // Finished hadler
    playing.whenComplete(() {
      if (playingTrack?.id == track.id && isPlaying) {
        // If the same track is playing
        logger.t(
            '_playerStart: Finished: track: ${track}, playingTrack: ${playingTrack}, isPaused: ${isPaused}');
        if (!isPaused) {
          _playerStop(notify: true);
        }
      }
    });
    logger.t('_playerStart: Started playing track ${track}: ${duration}');
    // Start timer...
    _playerTimerStart();
    // Update all...
    notifyListeners();
  }

  /// Track's play button handler
  void playTrack(Track track) async {
    logger.t('playTrack ${track}');
    if (playingTrack != null) {
      if (isPlaying && playingTrack!.id == track.id) {
        // Just pause/resume and exit if it was actively playing current track
        logger.t(
            'playTrack: Pausing/resuming active track: ${playingTrack} isPaused: ${isPaused}');
        if (!isPaused) {
          activePlayer?.pause();
          isPaused = true;
          _playerTimerStop();
        } else {
          activePlayer?.play();
          isPaused = false;
          _playerTimerStart();
        }
        notifyListeners();
        return;
      }
      // Else stop playback and continue
      _playerStop(notify: false);
    }
    // Start playing the track
    _playerStart(track);
  }
}
