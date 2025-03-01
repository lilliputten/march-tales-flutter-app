import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/core/singletons/userStateEvents.dart';
import 'package:march_tales_app/core/types/UserStateUpdate.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksByIds.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

mixin FavoritesState {
  void notifyListeners(); // From `ChangeNotifier`
  bool isAuthorized(); // From `UserState`

  // Favorites data...
  bool isFavoritesLoading = false;
  bool favoritesHasBeenLoaded = false;
  String? favoritesLoadError;

  /// Favorite track ids list
  List<int> _favoriteIds = [];

  /// Rsolved favorite tracks data
  Map<int, Track> _favoriteTracksData = {};

  initFavoritesState() {
    userStateEvents.subscribe(this._handleUpdateUserState);
  }

  _handleUpdateUserState(UserStateUpdate update) {
    final type = update.type;
    final isAuthorized = this.isAuthorized();
    logger.t('[FavoritesState:_handleUpdateUserState] type=${type} isAuthorized=${isAuthorized} update=${update}');
    debugger();
    this.loadFavorites();
  }

  getSortedFavorites() {
    final List<Track> tracks = []; // this._favoriteTracksData.values.toList();
    for (final id in this._favoriteIds) {
      final track = this._favoriteTracksData[id];
      if (track != null) {
        tracks.add(track);
      }
    }
    tracks.sort((a, b) => a.title.compareTo(b.title));
    return tracks;
  }

  _loadServerFavoriteIds() async {
    final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/favorites/ids/';
    logger.t('[FavoritesState:_loadServerFavoriteIds] url=${url}');
    final jsonData = await serverSession.get(Uri.parse(url));
    final List<int> ids =
        jsonData['ids'] != null ? List<dynamic>.from(jsonData['ids']).map((id) => id as int).toList() : [];
    logger.t('[FavoritesState:_loadServerFavoriteIds] done ids=${ids}');
    return ids;
  }

  _loadLocalFavoriteIds() async {
    final trackInfos = await tracksInfoDb.getFavorites();
    logger.t('[FavoritesState:_loadLocalFavoriteIds] trackInfos=${trackInfos}');
    final ids = trackInfos.map((trackInfo) => trackInfo.id);
    logger.t('[FavoritesState:_loadLocalFavoriteIds] done ids=${ids}');
    return ids.toList();
  }

  _loadFavoriteIds() async {
    if (this.isAuthorized()) {
      final ids = await this._loadServerFavoriteIds();
      return ids;
    } else {
      final ids = await this._loadLocalFavoriteIds();
      return ids;
    }
  }

  loadFavorites() async {
    this.isFavoritesLoading = true;
    this.notifyListeners();
    try {
      this._favoriteIds = await this._loadFavoriteIds();
      await this._loadMissedFavoritesData();
      this.favoritesHasBeenLoaded = true;
    } catch (err, stacktrace) {
      final String msg = 'Error loading favorite tracks list: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      this.favoritesLoadError = msg;
      showErrorToast(msg);
      throw Exception(msg);
    } finally {
      this.isFavoritesLoading = false;
      this.notifyListeners();
    }
  }

  isFavoriteTrackId(int id) {
    return this._favoriteIds.contains(id);
  }

  sendToggleFavoriteRequest({
    required int id,
    required bool favorite,
  }) async {
    final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/toggle-favorite/';
    try {
      final uri = Uri.parse(url);
      final jsonData = await serverSession.post(uri, body: {'value': favorite});
      // NOTE: Returns the list of all actual favorite tracks. Could be used to actualize local data.
      return jsonData;
    } catch (err, stacktrace) {
      final String msg = 'Error incrementing track played count with an url $url: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }

  setFavorite(int id, bool favorite) async {
    final prevFavorite = this._favoriteIds.contains(id);
    if (prevFavorite != favorite) {
      try {
        final List<Future<dynamic>> futures = [
          tracksInfoDb.setFavorite(id, favorite),
        ];
        if (this.isAuthorized()) {
          // Send data to the server
          futures.add(this.sendToggleFavoriteRequest(id: id, favorite: favorite));
        }
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
