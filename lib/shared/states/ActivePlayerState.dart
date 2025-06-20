import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/constants/player.dart';
import 'package:march_tales_app/core/constants/stateKeys.dart';
import 'package:march_tales_app/core/singletons/playingTrackEvents.dart';
import 'package:march_tales_app/core/types/PlayingTrackUpdate.dart';
import 'package:march_tales_app/features/Track/loaders/fetchNextTrackDetails.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

mixin ActivePlayerState {
  // Abstract interfaces for other mixins/parents...
  void notifyListeners();
  void updateSingleTrack(Track track, {bool notify = true}); // TrackState
  Track? findNextLocalTrack(int id); // TrackState

  // Player & active track

  Track? playingTrack;

  bool isPlaying = false;
  bool isPaused = false;
  bool isPlayerVisible = true;

  hidePlayer() {
    if (this.isPlayerVisible) {
      this.isPlayerVisible = false;
      this.notifyListeners();
    }
  }

  showPlayer() {
    if (!this.isPlayerVisible) {
      this.isPlayerVisible = true;
      this.notifyListeners();
    }
  }

  bool isPlayingAndNotPaused() {
    return this.isPlaying && !this.isPaused;
  }

  Future<Track?> _getNextTrack() async {
    final track = this.playingTrack;
    if (track == null) {
      return null;
    }
    try {
      return await fetchNextTrackDetails(track.id);
    } catch (err) {
      return this.findNextLocalTrack(track.id);
    }
  }

  _playNextTrack() async {
    final nextTrack = await this._getNextTrack();
    if (nextTrack == null) {
      debugger();
      return;
    }
    final playerBoxState = this.getPlayerBoxState();
    // Start a track with a delay, to allow PlayerBox timer stop
    Future.delayed(Duration(milliseconds: playerTickDelayMs), () {
      playerBoxState?.setTrack(nextTrack, play: true);
    });
  }

  _processPlayingTrackUpdate(PlayingTrackUpdate update) {
    bool updateRequires = false;
    final type = update.type;
    final track = update.track;
    if (track != null && type == PlayingTrackUpdateType.playedCount) {
      this.updateSingleTrack(track);
    }
    if (type == PlayingTrackUpdateType.trackData || type == PlayingTrackUpdateType.track) {
      this.playingTrack = track;
      updateRequires = true;
    }
    if ((type == PlayingTrackUpdateType.track ||
            type == PlayingTrackUpdateType.trackData ||
            type == PlayingTrackUpdateType.playingStatus ||
            type == PlayingTrackUpdateType.pausedStatus ||
            type == PlayingTrackUpdateType.completedStatus) &&
        (update.isPlaying != this.isPlaying || update.isPaused != this.isPaused)) {
      this.isPlaying = update.isPlaying;
      this.isPaused = update.isPaused;
      updateRequires = true;
    }
    if (updateRequires) {
      this.notifyListeners();
    }
    // Determine and start playback for the next track
    if (type == PlayingTrackUpdateType.completedStatus) {
      this._playNextTrack();
    }
  }

  initActivePlayerState() {
    playingTrackEvents.subscribe(this._processPlayingTrackUpdate);
  }

  PlayerBoxState? getPlayerBoxState() {
    return playerBoxKey.currentState;
  }
}
