import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';

final logger = Logger();

final formatter = YamlFormatter();

class TrackInfo {
  int id; // track.id
  bool favorite;
  int totalPlayedCount; // track.played_count
  int localPlayedCount; // userTrack.played_count (only for current user!).
  Duration position; // position?.inMilliseconds ?? 0
  DateTime lastUpdated; // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  DateTime lastPlayed; // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  DateTime lastFavorited; // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)

  TrackInfo({
    required this.id,
    required this.favorite,
    required this.totalPlayedCount,
    required this.localPlayedCount,
    required this.position,
    required this.lastUpdated,
    required this.lastPlayed,
    required this.lastFavorited,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'favorite': this.favorite ? 1 : 0,
      'totalPlayedCount': this.totalPlayedCount,
      'localPlayedCount': this.localPlayedCount,
      'position': this.position.inMilliseconds / 1000,
      'lastUpdatedMs': this.lastUpdated.millisecondsSinceEpoch,
      'lastPlayedMs': this.lastPlayed.millisecondsSinceEpoch,
      'lastFavoritedMs': this.lastFavorited.millisecondsSinceEpoch,
    };
  }

  factory TrackInfo.fromMap(Map<String, dynamic> data) {
    try {
      final int positionMs = (data['position'].toDouble() * 1000).round();
      final trackInfo = TrackInfo(
        id: data['id'],
        favorite: data['favorite'] == 0 ? false : true,
        totalPlayedCount: data['totalPlayedCount'],
        localPlayedCount: data['localPlayedCount'],
        position: Duration(milliseconds: positionMs),
        lastUpdated: DateTime.fromMillisecondsSinceEpoch(data['lastUpdatedMs']),
        lastPlayed: DateTime.fromMillisecondsSinceEpoch(data['lastPlayedMs']),
        lastFavorited: DateTime.fromMillisecondsSinceEpoch(data['lastFavoritedMs']),
      );
      // logger.t('[TrackInfo:fromMap] lastPlayedMs=${data['lastPlayedMs']} lastPlayed=${trackInfo.lastPlayed} data=${data} trackInfo=${trackInfo}');
      return trackInfo;
    } catch (err, stacktrace) {
      final String msg = 'Can not parse track info data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      logger.d('Raw data for the previous error is: : ${formatter.format(data)}');
      debugger();
      throw FormatException(msg);
    }
  }

  @override
  String toString() {
    return 'TrackInfo(id=$id favorite=${favorite} position=${position} totalPlayedCount=${totalPlayedCount} localPlayedCount=${localPlayedCount} lastUpdated=${lastUpdated} lastPlayed=${lastPlayed} lastFavorited=${lastFavorited})';
  }
}
