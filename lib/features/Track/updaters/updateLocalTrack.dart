import 'dart:developer';

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
  if (userTrack.position != null &&
      userTrack.played_at != null &&
      userTrack.played_at!.millisecondsSinceEpoch > trackInfo.lastPlayed.millisecondsSinceEpoch) {
    logger.t(
        '[updateLocalTrack] position: track=${track.id} ${userTrack.position} <= local=${trackInfo.position}, ${userTrack.played_at!} <= ${trackInfo.lastPlayed}');
    debugger();
    tracksInfoDb.updatePosition(track.id, userTrack.position, now: userTrack.played_at);
    // XXX FUTURE: Update user's played count from `userTrack.played_count`?
    updated = true;
  }
  if (userTrack.is_favorite != null &&
      userTrack.favorited_at != null &&
      userTrack.favorited_at!.millisecondsSinceEpoch > trackInfo.lastFavorited.millisecondsSinceEpoch) {
    logger.t(
        '[updateLocalTrack] favorite: track=${track.id} ${userTrack.is_favorite} <= ${trackInfo.favorite}, ${userTrack.favorited_at!} <= ${trackInfo.lastFavorited}');
    debugger();
    tracksInfoDb.setFavorite(track.id, userTrack.is_favorite!, now: userTrack.favorited_at);
    updated = true;
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
