// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';

final logger = Logger();

final formatter = YamlFormatter();

class UserTrack {
  final int id;
  final int track_id;
  final int user_id;
  final bool? is_favorite;
  final int? played_count;
  final Duration? position;
  // final int? favorited_at_sec;
  final DateTime? favorited_at; // <- favorited_at_sec
  // final int? played_at_sec;
  final DateTime? played_at; // <- played_at_sec
  // final int updated_at_sec;
  final DateTime updated_at; // <- updated_at_sec

  const UserTrack({
    required this.id,
    required this.track_id,
    required this.user_id,
    required this.is_favorite,
    required this.played_count,
    required this.position,
    // required this.favorited_at_sec,
    required this.favorited_at, // <- favorited_at_sec
    // required this.played_at_sec,
    required this.played_at, // <- played_at_sec
    // required this.updated_at_sec,
    required this.updated_at, // <- updated_at_sec
  });

  Map<String, dynamic> toJson() {
    try {
      return {
        'id': this.id,
        'track_id': this.track_id,
        'user_id': this.user_id,
        'is_favorite': this.is_favorite,
        'played_count': this.played_count,
        'position': position != null ? double.parse((position!.inMilliseconds / 1000).toStringAsFixed(3)) : null,
        'favorited_at_sec':
            this.favorited_at != null ? (this.favorited_at!.millisecondsSinceEpoch / 1000).round() : null,
        'played_at_sec': this.played_at != null ? (this.played_at!.millisecondsSinceEpoch / 1000).round() : null,
        'updated_at_sec': (this.updated_at.millisecondsSinceEpoch / 1000).round(),
      };
    } catch (err, stacktrace) {
      final String msg = 'Can not convert UserTrack to raw data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }

  factory UserTrack.fromJson(Map<String, dynamic> json) {
    try {
      final int? positionMs = json['position'] != null ? (json['position'].toDouble() * 1000).round() : null;
      final user_track = UserTrack(
        id: json['id'] as int,
        track_id: json['track_id'] as int,
        user_id: json['user_id'] as int,
        is_favorite: json['is_favorite'] != null ? json['is_favorite'] as bool : null,
        played_count: json['played_count'] != null ? json['played_count'] as int : null,
        position: positionMs != null ? Duration(milliseconds: positionMs) : null,
        favorited_at: json['favorited_at_sec'] != null
            ? new DateTime.fromMillisecondsSinceEpoch((json['favorited_at_sec'] as int) * 1000)
            : null,
        played_at: json['played_at_sec'] != null
            ? new DateTime.fromMillisecondsSinceEpoch((json['played_at_sec'] as int) * 1000)
            : null,
        updated_at: new DateTime.fromMillisecondsSinceEpoch((json['updated_at_sec'] as int) * 1000),
      );
      // logger.t('[UserTrack:fromJson] updated_at_sec=${json['updated_at_sec']} updated_at=${user_track.updated_at} json=${json} user_track=${user_track}');
      return user_track;
    } catch (err, stacktrace) {
      final String msg = 'Can not parse UserTrack data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }

  @override
  String toString() {
    return 'UserTrack(id=${id} track_id=${track_id} user_id=${user_id})';
  }
}
