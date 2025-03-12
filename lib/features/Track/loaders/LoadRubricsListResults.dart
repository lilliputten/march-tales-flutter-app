import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Rubric.dart';

final logger = Logger();

class LoadRubricsListResults {
  final int count;
  final List<Rubric> results;
  const LoadRubricsListResults({
    required this.count,
    required this.results,
  });
  factory LoadRubricsListResults.fromJson(Map<String, dynamic> json) {
    try {
      return LoadRubricsListResults(
        count: json['count'] as int,
        results: List<dynamic>.from(json['results']).map<Rubric>((data) => Rubric.fromJson(data)).toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse LoadRubricsListResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}
