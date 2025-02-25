import 'dart:async';
import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksList.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final formatter = YamlFormatter();
final logger = Logger();

mixin TrackState {
  void notifyListeners();
  Future<Track?> ensureLoadedPlayingTrackDetails({bool notify = true});
  Future<Track?> updatePlayingTrackDetails({bool notify = true});

  /// Tracks list

  // TODO: Store track filters state (in the separated state mixin?)

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
    this.tracks = [];
    // Reset (& reload?) tracks, offset & filters
    final List<Future> futures = [
      this.updatePlayingTrackDetails(notify: notify),
    ];
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
        await Future.delayed(Duration(seconds: 2));
      }
      final offset = tracks.length;
      // logger.t('Starting loading tracks (offset: ${offset})');
      final LoadTracksListResults results = await loadTracksList(offset: offset, limit: tracksLimit);
      tracks.addAll(results.results);
      availableTracksCount = results.count;
      logger.t('Loaded tracks (count: ${availableTracksCount}):\n${formatter.format(tracks)}');
      tracksHasBeenLoaded = true;
      tracksLoadError = null;
      return results;
    } catch (err, stacktrace) {
      final String msg = 'Error loading tracks data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      tracksLoadError = msg;
      showErrorToast(msg);
      throw Exception(msg);
    } finally {
      tracksIsLoading = false;
      notifyListeners();
    }
  }
}
