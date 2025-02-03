/// See data type in `lib/features/Track/db/TrackInfo.dart`
const String tracksInfoDbName = 'tracksInfo';

const String tracksInfoDbFileName = 'tracks-info.sqlite3';

const int tracksInfoDbVersion = 3;

String getTracksInfoDbStructure() {
  return [
    'id INTEGER PRIMARY KEY', // track.id
    'playedCount INTEGER', // track.played_count (but only for current user!)
    'positionMs INTEGER', // position?.inMilliseconds ?? 0
    'durationMs INTEGER', // duration?.inMilliseconds ?? 0
    'lastUpdatedMs INTEGER', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
    'lastPlayedMs INTEGER', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  ].join(', ');
}

String getTracksInfoDbCreateCommand() {
  return 'CREATE TABLE ${tracksInfoDbName}(${getTracksInfoDbStructure()})';
}
