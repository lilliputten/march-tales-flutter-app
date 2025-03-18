import 'dart:async';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksList.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'TrackState.i18n.dart';

final formatter = YamlFormatter();
final logger = Logger();

mixin TrackState {
  void notifyListeners();
  // Future<Track?> ensureLoadedPlayingTrackDetails({bool notify = true});
  // Future<Track?> updatePlayingTrackDetails({bool notify = true});
  PlayerBoxState? getPlayerBoxState(); // From `ActivePlayerState`
  String getFilterQuery(); // From FilterState

  /// Tracks list

  // XXX FUTURE: Store track filters state (in the separated state mixin?)

  bool tracksIsLoading = false;
  bool tracksHasBeenLoaded = false;
  String? tracksLoadError;
  int availableTracksCount = 0;
  int tracksLimit = defaultTracksDownloadLimit;
  List<Track> tracks = [];
  // XXX: Store loading handler to be able cancelling it?

  List<Track> getTracks() {
    return tracks;
  }

  void setTracks(List<Track> value, {bool notify = true}) {
    this.tracks = value;
    if (notify) {
      this.notifyListeners();
    }
  }

  bool hasMoreTracks() {
    return availableTracksCount > tracks.length;
  }

  void resetTracks({bool notify = true}) {
    this.tracksHasBeenLoaded = false;
    this.availableTracksCount = 0;
    this.tracks = [];
    this.tracksLoadError = null;
    this.tracksIsLoading = false;
    if (notify) {
      this.notifyListeners();
    }
  }

  reloadAllTracks({bool notify = true}) async {
    final playerBoxState = this.getPlayerBoxState();

    this.tracks = [];
    // Reset (& reload?) tracks, offset & filters
    final List<Future> futures = [
      // this.updatePlayingTrackDetails(notify: notify),
      // playerBoxState?.updatePlayingTrackDetails(notify: notify),
    ];
    if (playerBoxState != null) {
      futures.add(playerBoxState.updatePlayingTrackDetails(notify: notify));
    }
    if (this.tracksHasBeenLoaded) {
      futures.add(this.reloadTracks(notify: notify));
    }
    await Future.wait(futures);
  }

  Future<LoadTracksListResults> reloadTracks({bool notify = true}) async {
    resetTracks(notify: false);
    final results = await loadNextTracks();
    if (notify) {
      notifyListeners();
    }
    return results;
  }

  updateSingleTrack(Track track, {bool notify = true}) {
    final idx = this.tracks.indexWhere((it) => it.id == track.id);
    if (idx != -1) {
      tracks[idx] = track;
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  Future<LoadTracksListResults> loadNextTracks() async {
    try {
      tracksIsLoading = true;
      notifyListeners();
      // DEBUG: Emulate delay
      if (AppConfig.LOCAL) {
        // await Future.delayed(Duration(seconds: 2));
      }
      final offset = tracks.length;
      final query = this.getFilterQuery();
      logger.t('[TrackState:loadNextTracks] Start offset=${offset} query=${query}');
      final LoadTracksListResults results = await loadTracksList(
        offset: offset,
        limit: tracksLimit,
        query: query,
      );
      tracks.addAll(results.results);
      availableTracksCount = results.count;
      logger.t('Loaded tracks (count: ${availableTracksCount}):\n${formatter.format(tracks)}');
      tracksHasBeenLoaded = true;
      tracksLoadError = null;
      return results;
    } catch (err, stacktrace) {
      final String msg = 'Error loading tracks list.';
      logger.e('${msg} $err', error: err, stackTrace: stacktrace);
      // debugger();
      tracksLoadError = msg;
      final translatedMsg = msg.i18n;
      throw ConnectionException(translatedMsg);
    } finally {
      tracksIsLoading = false;
      notifyListeners();
    }
  }
}
