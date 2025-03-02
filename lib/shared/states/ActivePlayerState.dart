import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/singletons/playingTrackEvents.dart';
import 'package:march_tales_app/core/types/PlayingTrackUpdate.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

mixin ActivePlayerState {
  // Abstract interfaces for other mixins/parents...
  void notifyListeners();
  void updateSingleTrack(Track track, {bool notify = true}); // TrackState

  // Player & active track

  // TODO: To use PlayerBox as an audio controller (use it via `playerBoxKey?.currentState`)
  GlobalKey<PlayerBoxState>? playerBoxKey; // NOTE: One-way flow!

  Track? playingTrack;

  bool isPlaying = false;
  bool isPaused = false;

  _processPlayingTrackUpdate(PlayingTrackUpdate update) {
    bool updateRequires = false;
    if (update.track != null && update.type == PlayingTrackUpdateType.playedCount) {
      this.updateSingleTrack(update.track!);
    }
    if (update.type == PlayingTrackUpdateType.track) {
      this.playingTrack = update.track;
      updateRequires = true;
    }
    if ((update.type == PlayingTrackUpdateType.track ||
            update.type == PlayingTrackUpdateType.trackData ||
            update.type == PlayingTrackUpdateType.playingStatus ||
            update.type == PlayingTrackUpdateType.pausedStatus) &&
        (update.isPlaying != this.isPlaying || update.isPaused != this.isPaused)) {
      this.isPlaying = update.isPlaying;
      this.isPaused = update.isPaused;
      updateRequires = true;
    }
    if (updateRequires) {
      this.notifyListeners();
    }
  }

  initActivePlayerState() {
    playingTrackEvents.subscribe(this._processPlayingTrackUpdate);
  }

  PlayerBoxState? getPlayerBoxState() {
    return this.playerBoxKey?.currentState;
  }

  AudioPlayer? getPlayer() {
    final playerBoxState = getPlayerBoxState();
    final AudioPlayer? player = playerBoxState?.getPlayer();
    return player;
  }
}
