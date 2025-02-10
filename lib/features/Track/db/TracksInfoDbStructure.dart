const String tracksInfoDbName = 'tracksInfo';

const String tracksInfoDbFileName = 'tracks-info.sqlite3';

const int tracksInfoDbVersion = 5;

/// See data type in `lib/features/Track/db/TrackInfo.dart`
String getTracksInfoDbStructure() {
  return [
    'id INTEGER PRIMARY KEY', // track.id
    'favorite INTEGER DEFAULT(0)', // boolean, relation with user
    'position DOUBLE DEFAULT(0)', // position?.inMilliseconds / 1000 ?? 0.0
    'playedCount INTEGER DEFAULT(0)', // track.played_count (but only for current user!)
    'lastUpdatedMs INTEGER DEFAULT(0)', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
    'lastPlayedMs INTEGER DEFAULT(0)', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  ].join(', ');
}

String getTracksInfoDbCreateCommand([String tableName = tracksInfoDbName]) {
  return 'CREATE TABLE ${tableName}(${getTracksInfoDbStructure()})';
}
