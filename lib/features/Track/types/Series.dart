// ignore_for_file: non_constant_identifier_names

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

final formatter = YamlFormatter();

class Series {
  final int id;
  final String title;
  final String description;
  final bool promote;
  final bool is_visible;
  final DateTime created_at;
  final DateTime updated_at;
  final int tracks_count;
  final int published_tracks_count;
  final List<int> track_ids;
  final List<int> author_ids;
  final List<int> rubric_ids;
  final List<int> tag_ids;
  final List<Track> tracks;
  final List<TrackAuthor> authors;
  final List<TrackRubric> rubrics;
  final List<TrackTag> tags;

  const Series({
    required this.id,
    required this.title,
    required this.description,
    required this.promote,
    required this.is_visible,
    required this.created_at,
    required this.updated_at,
    required this.tracks_count,
    required this.published_tracks_count,
    required this.track_ids,
    required this.author_ids,
    required this.rubric_ids,
    required this.tag_ids,
    required this.tracks,
    required this.authors,
    required this.rubrics,
    required this.tags,
  });

  @override
  String toString() {
    return 'Series(id=${id}, title=${title})';
  }

  factory Series.fromJson(Map<String, dynamic> json) {
    try {
      return Series(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        promote: json['promote'] ?? false,
        is_visible: json['is_visible'] ?? false,
        created_at: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
        updated_at: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
        tracks_count: (json['tracks_count'] as num?)?.toInt() ?? 0,
        published_tracks_count: (json['published_tracks_count'] as num?)?.toInt() ?? 0,
        track_ids: json.containsKey('track_ids') ? List<int>.from(json['track_ids'] ?? []) : [],
        author_ids: json.containsKey('author_ids') ? List<int>.from(json['author_ids'] ?? []) : [],
        rubric_ids: json.containsKey('rubric_ids') ? List<int>.from(json['rubric_ids'] ?? []) : [],
        tag_ids: json.containsKey('tag_ids') ? List<int>.from(json['tag_ids'] ?? []) : [],
        tracks: json.containsKey('tracks')
            ? List<dynamic>.from(json['tracks'] ?? []).map((data) => Track.fromJson(data)).toList()
            : [],
        authors: json.containsKey('authors')
            ? List<dynamic>.from(json['authors'] ?? []).map((data) => TrackAuthor.fromJson(data)).toList()
            : [],
        rubrics: json.containsKey('rubrics')
            ? List<dynamic>.from(json['rubrics'] ?? []).map((data) => TrackRubric.fromJson(data)).toList()
            : [],
        tags: json.containsKey('tags')
            ? List<dynamic>.from(json['tags'] ?? []).map((data) => TrackTag.fromJson(data)).toList()
            : [],
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse Series data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      logger.w('Raw json data for the previous error is: : ${formatter.format(json)}');
      // Removed debugger() call which was potentially causing infinite loop in tests
      throw FormatException(msg);
    }
  }
}
