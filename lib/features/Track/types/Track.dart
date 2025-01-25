// ignore_for_file: non_constant_identifier_names

import 'dart:developer';
import 'package:logger/logger.dart';

final logger = Logger();

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
}

class Track {
  final int id;
  final String title;
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
  final String published_at;
  final String youtube_url;

  const Track({
    required this.id,
    required this.title,
    required this.track_status,
    required this.author,
    required this.tags,
    required this.rubrics,
    required this.audio_file,
    required this.audio_duration,
    required this.audio_size,
    required this.preview_picture,
    required this.for_members,
    required this.played_count,
    required this.published_at,
    required this.youtube_url,
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
        published_at: json['published_at'].toString(),
        youtube_url: json['youtube_url'].toString(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Track data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}
