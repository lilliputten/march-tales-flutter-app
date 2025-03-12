import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Author.dart';

final logger = Logger();

class LoadAuthorsListResults {
  final int count;
  final List<Author> results;
  const LoadAuthorsListResults({
    required this.count,
    required this.results,
  });
  factory LoadAuthorsListResults.fromJson(Map<String, dynamic> json) {
    try {
      return LoadAuthorsListResults(
        count: json['count'] as int,
        results: List<dynamic>.from(json['results']).map<Author>((data) => Author.fromJson(data)).toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse LoadAuthorsListResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}
