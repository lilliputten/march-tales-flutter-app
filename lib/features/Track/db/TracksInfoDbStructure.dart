const String tracksInfoDbName = 'tracksInfo';

const String tracksInfoDbFileName = 'tracks-info.sqlite3';

const int tracksInfoDbVersion = 7;

/// See data type in `lib/features/Track/db/TrackInfo.dart`
String getTracksInfoDbStructure() {
  return [
    'id INTEGER PRIMARY KEY', // track.id
    'favorite INTEGER DEFAULT(0)', // boolean, relation with user
    'position DOUBLE DEFAULT(0)', // position?.inMilliseconds / 1000 ?? 0.0
    'totalPlayedCount INTEGER DEFAULT(0)', // track.played_count
    'localPlayedCount INTEGER DEFAULT(0)', // userTrack.played_count (for current user!)
    'lastUpdatedMs INTEGER DEFAULT(0)', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
    'lastPlayedMs INTEGER DEFAULT(0)', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
    'lastFavoritedMs INTEGER DEFAULT(0)', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  ].join(', ');
}

String getTracksInfoDbCreateCommand([String tableName = tracksInfoDbName]) {
  return 'CREATE TABLE ${tableName}(${getTracksInfoDbStructure()})';
}

/*
# 2025.04.12: Migrate 5 -> 6 (add `lastFavoritedMs` field)
CREATE TABLE tracksInfo_temp (id INTEGER PRIMARY KEY, favorite INTEGER DEFAULT(0), position DOUBLE DEFAULT(0), playedCount INTEGER DEFAULT(0), lastUpdatedMs INTEGER DEFAULT(0), lastPlayedMs INTEGER DEFAULT(0), lastFavoritedMs INTEGER DEFAULT(0))
INSERT INTO tracksInfo_temp (id, favorite, playedCount, position, lastUpdatedMs, lastPlayedMs) SELECT id, favorite, playedCount, position, lastUpdatedMs, lastPlayedMs FROM tracksInfo
DROP TABLE tracksInfo
ALTER TABLE tracksInfo_temp RENAME TO tracksInfo
*/
