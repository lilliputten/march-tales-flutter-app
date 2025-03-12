// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

final formatter = YamlFormatter();

class Tag {
  final int id;
  final String text;
  final bool promote;
  final List<int> track_ids;
  final List<TrackAuthor> authors;
  final List<TrackRubric> rubrics;
  const Tag({
    required this.id,
    required this.text,
    required this.promote,
    required this.track_ids,
    required this.authors,
    required this.rubrics,
  });
  factory Tag.fromJson(Map<String, dynamic> json) {
    try {
      return Tag(
        id: json['id'],
        text: json['text'].toString(),
        promote: json['promote'],
        track_ids: List<dynamic>.from(json['track_ids']).map((val) => val as int).toList(),
        authors: List<dynamic>.from(json['authors']).map((data) => TrackAuthor.fromJson(data)).toList(),
        rubrics: List<dynamic>.from(json['rubrics']).map((data) => TrackRubric.fromJson(data)).toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Tag data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
  @override
  String toString() {
    return 'Tag(id=${id}, text=${text})';
  }
}
