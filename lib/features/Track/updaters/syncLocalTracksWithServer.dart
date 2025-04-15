import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/api-methods/postSyncUserTracks.dart';
import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/types/UserTrack.dart';

final logger = Logger();

UserTrack getUserTrackFromTrackInfo(TrackInfo trackInfo, int userId) {
  final UserTrack userTrack = UserTrack(
    id: trackInfo.id,
    user_id: userId,
    track_id: trackInfo.id,
    is_favorite: trackInfo.favorite,
    played_count: trackInfo.localPlayedCount,
    position: trackInfo.position,
    favorited_at: trackInfo.lastFavorited,
    played_at: trackInfo.lastPlayed,
    updated_at: trackInfo.lastUpdated,
  );
  return userTrack;
}

Future syncLocalTracksWithServer(int userId) async {
  Iterable<TrackInfo> trackInfos = await tracksInfoDb.getAll();
  Iterable<UserTrack> userTracks = trackInfos.map((trackInfo) => getUserTrackFromTrackInfo(trackInfo, userId)).toList();
  return await postSyncUserTracks(userTracks: userTracks);
}
