// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:logger/logger.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';

final logger = Logger();

final formatter = YamlFormatter();

class TrackAuthor {
  final int id;
  final String name;
  const TrackAuthor({
    required this.id,
    required this.name,
  });
  factory TrackAuthor.fromJson(Map<String, dynamic> json) {
    try {
      return TrackAuthor(
        id: json['id'],
        name: json['name'].toString(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse TrackAuthor data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
  @override
  String toString() {
    return 'Author: [${id}] ${name}';
  }
}

class TrackTag {
  final int id;
  final String text;
  const TrackTag({
    required this.id,
    required this.text,
  });
  factory TrackTag.fromJson(Map<String, dynamic> json) {
    try {
      return TrackTag(
        id: json['id'],
        text: json['text'].toString(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse TrackTag data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
  @override
  String toString() {
    return 'Tag: [${id}] ${text}';
  }
}

class TrackRubric {
  final int id;
  final String text;
  const TrackRubric({
    required this.id,
    required this.text,
  });
  factory TrackRubric.fromJson(Map<String, dynamic> json) {
    try {
      return TrackRubric(
        id: json['id'],
        text: json['text'].toString(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse TrackRubric data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
  @override
  String toString() {
    return 'Rubric: [${id}] ${text}';
  }
}

class Track {
  final int id;
  final String title;
  final String description;
  final String track_status;
  final TrackAuthor author;
  final List<TrackTag> tags;
  final List<TrackRubric> rubrics;
  final String audio_file;
  final int audio_duration;
  final int audio_size;
  final String preview_picture;
  final bool for_members;
  final int played_count;
  final String youtube_url;
  final String published_at;
  final int published_by_id;
  final int updated_by_id;
  final String updated_at;

  const Track({
    required this.id,
    required this.title,
    required this.description,
    required this.audio_duration,
    required this.audio_file,
    required this.audio_size,
    required this.for_members,
    required this.played_count,
    required this.preview_picture,
    required this.track_status,
    required this.youtube_url,
    required this.author,
    required this.rubrics,
    required this.tags,
    required this.published_at,
    required this.published_by_id,
    required this.updated_at,
    required this.updated_by_id,
  });

  @override
  String toString() {
    return 'Track ${id} (${title})';
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    try {
      return Track(
        id: json['id'],
        title: json['title'].toString(),
        description: json['description'].toString(),
        track_status: json['track_status'].toString(),
        author: TrackAuthor.fromJson(json['author']),
        tags: List<dynamic>.from(json['tags'])
            .map((data) => TrackTag.fromJson(data))
            .toList(),
        rubrics: List<dynamic>.from(json['rubrics'])
            .map((data) => TrackRubric.fromJson(data))
            .toList(),
        audio_file: json['audio_file'].toString(),
        audio_duration: json['audio_duration'],
        audio_size: json['audio_size'],
        preview_picture: json['preview_picture'].toString(),
        for_members: json['for_members'],
        played_count: json['played_count'],
        youtube_url: json['youtube_url'].toString(),
        published_at: json['published_at'].toString(),
        published_by_id: json['published_by_id'],
        updated_at: json['updated_at'].toString(),
        updated_by_id: json['updated_by_id'],
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Track data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      // logger.d('Json data for the previous error is: ${json}');
      logger.d(
          'Formatted json data for the previous error is: : ${formatter.format(json)}');
      debugger();
      throw FormatException(msg);
    }
  }
}
