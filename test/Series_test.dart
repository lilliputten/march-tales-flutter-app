import 'package:logger/logger.dart';
import 'package:test/test.dart';

import 'package:march_tales_app/features/Track/types/Series.dart';

// ignore: depend_on_referenced_packages
// @see https://docs.flutter.dev/cookbook/testing/unit/introduction

final logger = Logger();

void main() {
  test('Series should be created from a dynamic data (parsed json)', () async {
    final data = {
      "id": 5,
      "title": "Название серии",
      "description": "Описание серии (__markdown__).",
      "promote": true,
      "is_visible": true,
      "created_at": "2026-01-29T07:09:16.244538+03:00",
      "updated_at": "2026-05-15T00:10:24.033361+03:00",
      "tracks_count": 5,
      "published_tracks_count": 5,
      "track_ids": [6, 5, 7, 1, 3],
      "author_ids": [1],
      "rubric_ids": [1, 5, 3, 4],
      "tag_ids": [1, 2, 4, 5, 6],
      "tracks": [],
      "authors": [
        {
          "id": 1,
          "name": "Test Author",
          "promote": true,
          "portrait_picture": "http://example.com/portrait.jpg",
          "track_ids": [1, 2, 3]
        }
      ],
      "rubrics": [
        {"id": 1, "text": "Test Rubric", "promote": false}
      ],
      "tags": [
        {"id": 1, "text": "Test Tag", "promote": true}
      ]
    };

    try {
      final result = Series.fromJson(data);
      expect(result.id, data['id']);
      expect(result.title, data['title']);
      expect(result.description, data['description']);
      expect(result.promote, data['promote']);
      expect(result.is_visible, data['is_visible']);
      expect(result.tracks_count, data['tracks_count']);
      expect(result.published_tracks_count, data['published_tracks_count']);
      expect(result.track_ids.length, (data['track_ids'] as List).length);
      expect(result.author_ids.length, (data['author_ids'] as List).length);
      expect(result.rubric_ids.length, (data['rubric_ids'] as List).length);
      expect(result.tag_ids.length, (data['tag_ids'] as List).length);
    } catch (err, stacktrace) {
      final String msg = 'Failed test';
      logger.e(msg, error: err, stackTrace: stacktrace);
      throw Exception(msg);
    }
  });

  test('Series should handle empty data correctly', () {
    final data = {
      "id": 0,
      "title": "",
      "description": "",
      "promote": false,
      "is_visible": false,
      "created_at": "invalid date",
      "updated_at": "invalid date",
      "tracks_count": 0,
      "published_tracks_count": 0,
      "track_ids": [],
      "author_ids": [],
      "rubric_ids": [],
      "tag_ids": [],
      "tracks": [],
      "authors": [],
      "rubrics": [],
      "tags": []
    };

    try {
      final result = Series.fromJson(data);
      expect(result.id, 0);
      expect(result.title, '');
      expect(result.description, '');
      expect(result.promote, false);
      expect(result.is_visible, false);
      expect(result.tracks_count, 0);
      expect(result.published_tracks_count, 0);
      expect(result.track_ids, isEmpty);
      expect(result.author_ids, isEmpty);
      expect(result.rubric_ids, isEmpty);
      expect(result.tag_ids, isEmpty);
      expect(result.tracks, isEmpty);
      expect(result.authors, isEmpty);
      expect(result.rubrics, isEmpty);
      expect(result.tags, isEmpty);
    } catch (err, stacktrace) {
      final String msg = 'Failed test with empty data';
      logger.e(msg, error: err, stackTrace: stacktrace);
      throw Exception(msg);
    }
  });
}
