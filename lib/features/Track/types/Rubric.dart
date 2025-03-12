// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

final formatter = YamlFormatter();

class Rubric {
  final int id;
  final String text;
  final bool promote;
  final List<int> track_ids;
  final List<TrackAuthor> authors;
  final List<TrackTag> tags;
  const Rubric({
    required this.id,
    required this.text,
    required this.promote,
    required this.track_ids,
    required this.authors,
    required this.tags,
  });
  factory Rubric.fromJson(Map<String, dynamic> json) {
    try {
      return Rubric(
        id: json['id'],
        text: json['text'].toString(),
        promote: json['promote'],
        track_ids: List<dynamic>.from(json['track_ids']).map((val) => val as int).toList(),
        authors: List<dynamic>.from(json['authors']).map((data) => TrackAuthor.fromJson(data)).toList(),
        tags: List<dynamic>.from(json['tags']).map((data) => TrackTag.fromJson(data)).toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Rubric data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
  @override
  String toString() {
    return 'Rubric(id=${id}, text=${text})';
  }
}
