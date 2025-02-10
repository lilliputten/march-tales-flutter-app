import 'dart:developer';

import 'package:logger/logger.dart';
import 'package:test/test.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

// import 'Track.dart';
// ignore: depend_on_referenced_packages
// @see https://docs.flutter.dev/cookbook/testing/unit/introduction

final logger = Logger();

void main() {
  test('Track should be created from a dynamic data (parsed json)', () async {
    final data = {
      "id": 2,
      "title": "Новогодняя сказка",
      "track_status": "PUBLISHED",
      "author": {"id": 2, "name": "Ханс Кристиан Андерсен"},
      "tags": [
        {"id": 2, "text": "Пример"}
      ],
      "rubrics": [
        {"id": 1, "text": "Сказки"},
        {"id": 2, "text": "Рассказы"}
      ],
      "audio_file":
          "http://localhost:8000/media/samples/sample-with-wrong-metadata-duration.mp3",
      "audio_duration": 167.183673,
      "audio_size": 1031154,
      "preview_picture": "http://localhost:8000/media/samples/ny-800x450.jpg",
      "for_members": false,
      "played_count": 0,
      "published_at": "2025-01-11",
      "youtube_url": "",
    };
    try {
      final result = Track.fromJson(data);
      expect(result.id, data['id']);
    } catch (err, stacktrace) {
      final String msg = 'Failed test';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw Exception(msg);
    }
  });
  group('Track details', () {
    test('TrackTag list should be created from a dynamic list (parsed json)',
        () {
      final list = [
        {
          'id': 1,
          'text': 'First tag',
        },
        {
          'id': 2,
          'text': 'Second tag',
        },
      ];
      try {
        final trackTags = list.map((data) => TrackTag.fromJson(data)).toList();
        expect(trackTags[0].id, 1);
      } catch (err, stacktrace) {
        final String msg = 'Failed test';
        logger.e(msg, error: err, stackTrace: stacktrace);
        debugger();
        throw Exception(msg);
      }
    });
    test('TrackAuthor should be created from a dynamic data (parsed json)', () {
      final data = {
        'id': 1,
        'name': 'Test Author',
      };
      try {
        final trackAuthor = TrackAuthor.fromJson(data);
        expect(trackAuthor.id, 1);
      } catch (err, stacktrace) {
        final String msg = 'Failed test';
        logger.e(msg, error: err, stackTrace: stacktrace);
        debugger();
        throw Exception(msg);
      }
    });
  });
}
