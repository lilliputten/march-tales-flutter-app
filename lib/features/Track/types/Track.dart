// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';

final logger = Logger();

final formatter = YamlFormatter();

class TrackAuthor {
  final int id;
  final bool promote;
  final String name;
  final String portrait_picture;
  final List<int> track_ids;
  const TrackAuthor({
    required this.id,
    required this.promote,
    required this.name,
    required this.portrait_picture,
    required this.track_ids,
  });
  factory TrackAuthor.fromJson(Map<String, dynamic> json) {
    try {
      return TrackAuthor(
        id: json['id'],
        promote: json['promote'] as bool,
        name: json['name'].toString(),
        portrait_picture: json['portrait_picture'].toString(),
        track_ids: List<dynamic>.from(json['track_ids']).map((val) => val as int).toList(),
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
    return 'Author(id=${id}, name=${name})';
  }
}

class TrackTag {
  final int id;
  final bool promote;
  final String text;
  const TrackTag({
    required this.id,
    required this.promote,
    required this.text,
  });
  factory TrackTag.fromJson(Map<String, dynamic> json) {
    try {
      return TrackTag(
        id: json['id'],
        promote: json['promote'],
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
  final bool promote;
  final String text;
  const TrackRubric({
    required this.id,
    required this.promote,
    required this.text,
  });
  factory TrackRubric.fromJson(Map<String, dynamic> json) {
    try {
      return TrackRubric(
        id: json['id'],
        promote: json['promote'],
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
  // final double audio_duration;
  final Duration duration;
  final int audio_size;
  final String preview_picture;
  final bool for_members;
  final int played_count;
  final String youtube_url;
  final DateTime published_at;
  final int published_by_id;
  final int updated_by_id;
  final DateTime updated_at;

  const Track({
    required this.id,
    required this.title,
    required this.description,
    // required this.audio_duration,
    required this.duration,
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
    return 'Track(id=${id}, title=${title})';
  }

  factory Track.fromJson(Map<String, dynamic> json) {
    try {
      final int durationMs = (json['audio_duration'].toDouble() * 1000).round();
      return Track(
        id: json['id'],
        title: json['title'].toString(),
        description: json['description'].toString(),
        track_status: json['track_status'].toString(),
        author: TrackAuthor.fromJson(json['author']),
        tags: List<dynamic>.from(json['tags']).map((data) => TrackTag.fromJson(data)).toList(),
        rubrics: List<dynamic>.from(json['rubrics']).map((data) => TrackRubric.fromJson(data)).toList(),
        audio_file: json['audio_file'].toString(),
        // audio_duration: json['audio_duration'].toDouble(),
        duration: Duration(milliseconds: durationMs), // json['audio_duration'].toDouble(),
        audio_size: json['audio_size'],
        preview_picture: json['preview_picture'].toString(),
        for_members: json['for_members'],
        played_count: json['played_count'],
        youtube_url: json['youtube_url'].toString(),
        published_at: DateTime.parse(json['published_at'].toString()),
        published_by_id: json['published_by_id'],
        updated_at: DateTime.parse(json['updated_at'].toString()),
        updated_by_id: json['updated_by_id'],
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Track data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      logger.d('Raw json data for the previous error is: : ${formatter.format(json)}');
      debugger();
      throw FormatException(msg);
    }
  }
}
