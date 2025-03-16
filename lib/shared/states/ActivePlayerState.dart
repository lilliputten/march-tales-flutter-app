import 'package:logger/logger.dart';

import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/constants/stateKeys.dart';
import 'package:march_tales_app/core/singletons/playingTrackEvents.dart';
import 'package:march_tales_app/core/types/PlayingTrackUpdate.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

mixin ActivePlayerState {
  // Abstract interfaces for other mixins/parents...
  void notifyListeners();
  void updateSingleTrack(Track track, {bool notify = true}); // TrackState

  // Player & active track

  Track? playingTrack;

  bool isPlaying = false;
  bool isPaused = false;

  bool isPlayingAndNotPaused() {
    return this.isPlaying && !this.isPaused;
  }

  _processPlayingTrackUpdate(PlayingTrackUpdate update) {
    bool updateRequires = false;
    final type = update.type;
    final track = update.track;
    // logger.d('[ActivePlayerState:_processPlayingTrackUpdate] update=${update}');
    if (track != null && type == PlayingTrackUpdateType.playedCount) {
      // logger.t('[ActivePlayerState:_processPlayingTrackUpdate] playedCount track=${track}');
      this.updateSingleTrack(track);
    }
    if (type == PlayingTrackUpdateType.trackData || type == PlayingTrackUpdateType.track) {
      // logger.t('[ActivePlayerState:_processPlayingTrackUpdate] track track=${track}');
      this.playingTrack = track;
      updateRequires = true;
    }
    if ((type == PlayingTrackUpdateType.track ||
            type == PlayingTrackUpdateType.trackData ||
            type == PlayingTrackUpdateType.playingStatus ||
            type == PlayingTrackUpdateType.pausedStatus) &&
        (update.isPlaying != this.isPlaying || update.isPaused != this.isPaused)) {
      // logger.t('[ActivePlayerState:_processPlayingTrackUpdate] status track=${track}');
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
    return playerBoxKey.currentState;
  }
}
