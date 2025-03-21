import 'package:event/event.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

enum PlayingTrackUpdateType {
  track,
  trackData,
  position,
  playingStatus,
  pausedStatus,
  completedStatus,
  playedCount,
}

class PlayingTrackUpdate extends EventArgs {
  PlayingTrackUpdateType type;
  bool isPlaying;
  bool isPaused;
  Track? track;
  Duration? position;

  PlayingTrackUpdate({
    required this.type,
    required this.isPlaying,
    required this.isPaused,
    this.track,
    this.position,
  });

  @override
  String toString() {
    return 'PlayingTrackUpdate(type=${type}; track=${track}; isPlaying=${isPlaying}; isPaused=${isPaused}; position=${position})';
  }
}
