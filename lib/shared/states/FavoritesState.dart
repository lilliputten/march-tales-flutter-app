import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksByIds.dart';

import 'package:march_tales_app/features/Track/types/Track.dart'; // DEBUG: To remove later

final logger = Logger();

mixin FavoritesState {
  void notifyListeners(); // From `ChangeNotifier`

  bool isFavoritesLoading = false;
  bool favoritesHasBeenLoaded = false;

  /// Favorite track ids list
  List<int> _favoriteIds = [];

  /// Rsolved favorite tracks data
  Map<int, Track> _favoriteTracksData = {};

  getSortedFavorites() {
    final tracks = this._favoriteTracksData.values.toList();
    tracks.sort((a, b) => a.title.compareTo(b.title));
    return tracks;
  }

  loadFavorites() async {
    this.isFavoritesLoading = true;
    this.notifyListeners();
    try {
      final trackInfos = await tracksInfoDb.getFavorites();
      final ids = trackInfos.map((trackInfo) => trackInfo.id);
      this._favoriteIds = ids.toList();
      await this._loadMissedFavoritesData();
    } finally {
      this.isFavoritesLoading = false;
      this.favoritesHasBeenLoaded = true;
      this.notifyListeners();
    }
  }

  setFavorite(int id, bool favorite) async {
    final prevFavorite = this._favoriteIds.contains(id);
    if (prevFavorite != favorite) {
      try {
        final List<Future<dynamic>> futures = [
          tracksInfoDb.setFavorite(id, favorite),
        ];
        if (favorite) {
          this._favoriteIds.add(id);
          // Load missed data...
          futures.add(this._loadMissedFavoritesData());
        } else {
          this._favoriteIds.remove(id);
          // Remove unused data...
          this._removeUnusedFavoritesData();
        }
        final results = await Future.wait(futures);
        return results;
      } catch (err, stacktrace) {
        logger.e('[setFavorite] ${err}', error: err, stackTrace: stacktrace);
        debugger();
        // TODO: Show error toast?
        rethrow;
      } finally {
        this.notifyListeners();
      }
    }
  }

  _removeUnusedFavoritesData() {
    this._favoriteTracksData.removeWhere((id, _) => !this._favoriteIds.contains(id));
    // final unusedKeys = this._favoriteTracksData.keys.where((id) => !this._favoriteIds.contains(id));
  }

  _loadMissedFavoritesData() async {
    final missedIds = this._favoriteIds.where((id) => !this._favoriteTracksData.containsKey(id));
    if (missedIds.isNotEmpty) {
      final results = await loadTracksByIds(missedIds);
      // this._favoriteTracksData = {}..addAll(this._favoriteTracksData);
      for (Track track in results.results) {
        this._favoriteTracksData[track.id] = track;
      }
    }
  }

  reloadFavoritesData() async {
    this.isFavoritesLoading = true;
    this.notifyListeners();
    try {
      this._favoriteTracksData.clear();
      await this._loadMissedFavoritesData();
    } finally {
      this.isFavoritesLoading = false;
      this.favoritesHasBeenLoaded = true;
      this.notifyListeners();
    }
  }
}
