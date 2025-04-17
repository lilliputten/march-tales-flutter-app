import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

/* See the march-tales server api method `tales_django/core/pages/get_recents_context.py`:

  recentTracks: recent_tracks
  popularTracks: popular_tracks
  mostRecentTrack: most_recent_track
  randomTrack: random_track

*/

class RecentResults {
  final List<Track> recentTracks;
  final List<Track> popularTracks;
  final Track mostRecentTrack;
  final Track randomTrack;

  const RecentResults({
    required this.recentTracks,
    required this.popularTracks,
    required this.mostRecentTrack,
    required this.randomTrack,
  });

  factory RecentResults.fromJson(Map<String, dynamic> json) {
    try {
      return RecentResults(
        recentTracks: List<dynamic>.from(json['recent_tracks']).map<Track>((data) => Track.fromJson(data)).toList(),
        popularTracks: List<dynamic>.from(json['popular_tracks']).map<Track>((data) => Track.fromJson(data)).toList(),
        mostRecentTrack: Track.fromJson(json['most_recent_track']),
        randomTrack: Track.fromJson(json['random_track']),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse RecentResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}
