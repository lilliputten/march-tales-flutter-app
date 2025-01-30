import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:english_words/english_words.dart'; // DEBUG: To remove later
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';

import 'package:march_tales_app/features/Quote/helpers/fetchQuote.dart';
import 'package:march_tales_app/features/Quote/types/Quote.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksList.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/supportedLocales.dart';

const int defaultTracksDownloadLimit = 2;

final formatter = YamlFormatter();
final logger = Logger();

class MyAppState extends ChangeNotifier {
  /// Persistent storage
  SharedPreferences? prefs;

  loadSavedPrefs() {
    final savedIsDarkTheme = prefs?.getBool('isDarkTheme');
    if (savedIsDarkTheme != null) {
      isDarkTheme = savedIsDarkTheme;
    }
    final savedCurrentLocale = prefs?.getString('currentLocale');
    if (savedCurrentLocale != null) {
      currentLocale = savedCurrentLocale;
    }
    notifyListeners();
  }

  setPrefs(SharedPreferences? value) {
    if (value != null) {
      prefs = value;
      loadSavedPrefs();
    }
  }

  // /// Global application error (UNUSED?)
  // dynamic globalError;
  //
  // void setGlobalError(dynamic error) {
  //   globalError = error;
  //   notifyListeners();
  // }

  // DEBUG: App info
  String? serverProjectInfo;

  void setServerProjectInfo(String? info) {
    serverProjectInfo = info;
    notifyListeners();
  }

  String? appProjectInfo;

  void setAppProjectInfo(String? info) {
    appProjectInfo = info;
    notifyListeners();
  }

  /// Theme

  bool isDarkTheme = false;

  void toggleDarkTheme(bool value) {
    isDarkTheme = value;
    prefs?.setBool('isDarkTheme', value);
    notifyListeners();
  }

  /// Language

  String currentLocale = defaultLocale;

  updateLocale(String value) async {
    currentLocale = value;
    tracks = [];
    prefs?.setString('currentLocale', value);
    // Reset (& reload?) tracks, offset & filters
    if (tracksHasBeenLoaded) {
      // NOTE: Not waiting for finish
      reloadTracks();
    }
    if (playingTrack != null) {
      // Update `playingTrack` if language has been changed
      playingTrack = await loadTrackDetails(id: playingTrack!.id);
    }
    notifyListeners();
  }

  /// Active player

  Track? playingTrack;

  /// Tracks list

  // TODO: Store track filters state

  bool tracksIsLoading = false;
  bool tracksHasBeenLoaded = false;
  String? tracksLoadError;
  int availableTracksCount = 0;
  int tracksLimit = defaultTracksDownloadLimit;
  List<Track> tracks = [];
  // XXX: Store loading handler to be able cancelling it?

  bool hasMoreTracks() {
    return availableTracksCount > tracks.length;
  }

  void resetTracks({bool doNotify = true}) {
    tracksHasBeenLoaded = false;
    availableTracksCount = 0;
    tracks = [];
    tracksLoadError = null;
    tracksIsLoading = false;
    if (doNotify) {
      notifyListeners();
    }
  }

  void playTrack(Track track) {
    logger.t('playTrack ${track}');
    playingTrack = track;
    // hasActivePlayer = true;
    notifyListeners();
  }

  Future<LoadTracksListResults> reloadTracks() async {
    resetTracks(doNotify: false);
    return await loadNextTracks();
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
      logger.t('Starting loading tracks (offset: ${offset})');
      final LoadTracksListResults results =
          await loadTracksList(offset: offset, limit: tracksLimit);
      tracks.addAll(results.results);
      availableTracksCount = results.count;
      logger.t(
          'Loaded tracks (count: ${availableTracksCount}):\n${formatter.format(tracks)}');
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

  /// Word pair & history (a demo)
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  /// Favorites list (a demo)
  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  /// Quote
  Future<Quote>? futureQuote;

  loadQuote() {
    futureQuote = fetchQuote();
    return futureQuote;
  }

  ensureQuote() {
    futureQuote ??= loadQuote();
    return futureQuote;
  }

  reloadQuote() {
    loadQuote();
    notifyListeners();
  }
}
