import 'dart:developer';
import 'package:logger/logger.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';

final logger = Logger();

final formatter = YamlFormatter();

class TrackInfo {
  final int id; // track.id
  final Duration position; // positionMs; // position?.inMilliseconds ?? 0
  final Duration duration; // durationMs; // duration?.inMilliseconds ?? 0
  final int playedCount; // // track.played_count (but only for current user!).
  final DateTime
      lastUpdated; // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  final DateTime
      lastPlayed; // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)

  const TrackInfo({
    required this.id,
    required this.position,
    required this.duration,
    required this.lastUpdated,
    required this.lastPlayed,
    required this.playedCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'positionMs': this.position.inMilliseconds,
      'durationMs': this.duration.inMilliseconds,
      'playedCount': this.playedCount,
      'lastUpdatedMs': this.lastUpdated.millisecondsSinceEpoch,
      'lastPlayedMs': this.lastPlayed.millisecondsSinceEpoch,
    };
  }

  factory TrackInfo.fromMap(Map<String, dynamic> data) {
    try {
      return TrackInfo(
        id: data['id'],
        position: Duration(milliseconds: data['positionMs']),
        duration: Duration(milliseconds: data['durationMs']),
        lastUpdated: DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedMs']),
        lastPlayed: DateTime.fromMillisecondsSinceEpoch(data['lastPlayedMs']),
        playedCount: data['playedCount'],
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse track info data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      logger
          .d('Raw data for the previous error is: : ${formatter.format(data)}');
      debugger();
      throw FormatException(msg);
    }
  }
}
