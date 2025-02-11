import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

class LoadTracksListResults {
  final int count;
  final List<Track> results;
  const LoadTracksListResults({
    required this.count,
    required this.results,
  });
  factory LoadTracksListResults.fromJson(Map<String, dynamic> json) {
    try {
      return LoadTracksListResults(
        count: json['count'] as int,
        results: List<dynamic>.from(json['results'])
            .map<Track>((data) => Track.fromJson(data))
            .toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse LoadTracksListResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}
