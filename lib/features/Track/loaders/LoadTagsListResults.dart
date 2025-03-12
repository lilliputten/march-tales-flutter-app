import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Tag.dart';

final logger = Logger();

class LoadTagsListResults {
  final int count;
  final List<Tag> results;
  const LoadTagsListResults({
    required this.count,
    required this.results,
  });
  factory LoadTagsListResults.fromJson(Map<String, dynamic> json) {
    try {
      return LoadTagsListResults(
        count: json['count'] as int,
        results: List<dynamic>.from(json['results']).map<Tag>((data) => Tag.fromJson(data)).toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse LoadTagsListResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}
