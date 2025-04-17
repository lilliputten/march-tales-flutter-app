import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/types/UserTrack.dart';

final logger = Logger();

/* // See related methods (the methods what loads data from the server)
 * fetchNextTrackDetails
 * getTrackFromStateOrLoad
 * loadTrackDetails
 * loadTracksByIds
 * loadTracksList
 * LoadTracksListResults
 *
 * fetchNextTrackDetails, getTrackFromStateOrLoad, loadTrackDetails, loadTracksByIds, loadTracksList, LoadTracksListResults
 * \<\(fetchNextTrackDetails\|getTrackFromStateOrLoad\|loadTrackDetails\|loadTracksByIds\|loadTracksList\|LoadTracksListResults\)\>
 * \b(fetchNextTrackDetails|getTrackFromStateOrLoad|loadTrackDetails|loadTracksByIds|loadTracksList|LoadTracksListResults)\b
 *
 */

Future<bool> updateLocalTrack(Track track) async {
  final UserTrack? userTrack = track.user_track;
  if (userTrack == null) {
    return false;
  }
  final trackInfo = await tracksInfoDb.getById(track.id);
  if (trackInfo == null) {
    return false;
  }
  bool updated = false;
  // Check played count and positions
  if (userTrack.played_at != null &&
      userTrack.played_at!.millisecondsSinceEpoch > trackInfo.lastPlayed.millisecondsSinceEpoch) {
    updated = true;
    logger.t(
        '[updateLocalTrack] played_count: track=${track.id} ${userTrack.played_count} <= ${trackInfo.localPlayedCount}, ${userTrack.played_at!} <= ${trackInfo.lastPlayed}');
    tracksInfoDb.updatePlayedCount(track.id,
        localPlayedCount: userTrack.played_count, totalPlayedCount: track.played_count, timestamp: userTrack.played_at);
    if (userTrack.position != null && userTrack.position != trackInfo.position) {
      logger.t(
          '[updateLocalTrack] position: track=${track.id} ${userTrack.position} <= ${trackInfo.position}, ${userTrack.played_at!} <= ${trackInfo.lastPlayed}');
      tracksInfoDb.updatePosition(track.id, userTrack.position, timestamp: userTrack.played_at);
    }
  }
  if (userTrack.favorited_at != null &&
      userTrack.favorited_at!.millisecondsSinceEpoch > trackInfo.lastFavorited.millisecondsSinceEpoch) {
    if (userTrack.is_favorite != null && userTrack.is_favorite != trackInfo.favorite) {
      updated = true;
      logger.t(
          '[updateLocalTrack] favorite: track=${track.id} ${userTrack.is_favorite} <= ${trackInfo.favorite}, ${userTrack.favorited_at!} <= ${trackInfo.lastFavorited}');
      tracksInfoDb.setFavorite(track.id, userTrack.is_favorite!, timestamp: userTrack.favorited_at);
    }
  }
  return updated;
}

Future<bool> updateLocalTracks(List<Track> tracks) async {
  if (tracks.isEmpty) {
    return false;
  }
  Iterable<Future<bool>> futures = tracks.map((track) => updateLocalTrack(track));
  final List<bool> results = await Future.wait(futures);
  return results.reduce((result, it) => result && it);
}
