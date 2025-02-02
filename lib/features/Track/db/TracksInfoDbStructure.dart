/// See data type in `lib/features/Track/db/TrackInfo.dart`
const String tracksInfoDbName = 'tracksInfo';

const int tracksInfoDbVersion = 3;

String getTracksInfoDbStructure() {
  return [
    'id INTEGER PRIMARY KEY', // track.id
    'positionMs INTEGER', // position?.inMilliseconds ?? 0
    'durationMs INTEGER', // duration?.inMilliseconds ?? 0
    'playedCount INTEGER', // track.played_count (but only for current user!)
    'lastUpdatedMs INTEGER', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
    'lastPlayedMs INTEGER', // DateTime.now().millisecondsSinceEpoch <-> DateTime.fromMillisecondsSinceEpoch(ms)
  ].join(', ');
}

String getTracksInfoDbCreateCommand() {
  return 'CREATE TABLE ${tracksInfoDbName}(${getTracksInfoDbStructure()})';
}
