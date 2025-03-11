// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

final formatter = YamlFormatter();

class Author {
  final int id;
  final String name;
  final String short_description;
  final String description;
  final String portrait_picture;
  final bool promote;
  final List<int> track_ids;
  final List<TrackRubric> rubrics;
  final List<TrackTag> tags;
  const Author({
    required this.id,
    required this.name,
    required this.short_description,
    required this.description,
    required this.portrait_picture,
    required this.promote,
    required this.track_ids,
    required this.rubrics,
    required this.tags,
  });
  factory Author.fromJson(Map<String, dynamic> json) {
    try {
      return Author(
        id: json['id'],
        name: json['name'].toString(),
        portrait_picture: json['portrait_picture'].toString(),
        short_description: json['short_description'].toString(),
        description: json['description'].toString(),
        promote: json['promote'],
        track_ids: List<dynamic>.from(json['track_ids']).map((val) => val as int).toList(),
        rubrics: List<dynamic>.from(json['rubrics']).map((data) => TrackRubric.fromJson(data)).toList(),
        tags: List<dynamic>.from(json['tags']).map((data) => TrackTag.fromJson(data)).toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Author data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
  @override
  String toString() {
    return 'Author(id=${id}, name=${name})';
  }
}
