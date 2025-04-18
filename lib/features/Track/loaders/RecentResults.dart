import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

/* See the march-tales server api method `tales_django/core/pages/get_recents_context.py`:

  stats:

  tracksCount: tracks_count
  authorsCount: authors_count
  rubricsCount: rubrics_count
  tagsCount: tags_count

  results:

  recentTracks: recent_tracks
  popularTracks: popular_tracks
  mostRecentTrack: most_recent_track
  randomTrack: random_track

*/

class RecentStats {
  final int tracksCount;
  final int authorsCount;
  final int rubricsCount;
  final int tagsCount;

  const RecentStats({
    required this.tracksCount,
    required this.authorsCount,
    required this.rubricsCount,
    required this.tagsCount,
  });

  factory RecentStats.fromJson(Map<String, dynamic> json) {
    try {
      return RecentStats(
        tracksCount: json['tracks_count'],
        authorsCount: json['authors_count'],
        rubricsCount: json['rubrics_count'],
        tagsCount: json['tags_count'],
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse RecentStats data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}

class RecentResults {
  final RecentStats stats;
  final List<Track> recentTracks;
  final List<Track> popularTracks;
  final Track mostRecentTrack;
  final Track randomTrack;

  const RecentResults({
    required this.stats,
    required this.recentTracks,
    required this.popularTracks,
    required this.mostRecentTrack,
    required this.randomTrack,
  });

  factory RecentResults.fromJson(Map<String, dynamic> json) {
    try {
      return RecentResults(
        stats: RecentStats.fromJson(json['stats']),
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
