import 'dart:developer';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';

import 'package:march_tales_app/features/Quote/helpers/fetchQuote.dart';
import 'package:march_tales_app/features/Quote/types/Quote.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksData.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/supportedLocales.dart';

const int defaultTracksDownloadLimit = 2;

final formatter = YamlFormatter();
final logger = Logger();

class MyAppState extends ChangeNotifier {
  /// App info (DEBUG)
  dynamic globalError;

  void setGlobalError(dynamic error) {
    globalError = error;
    notifyListeners();
  }

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

  ThemeMode themeMode = ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
  }

  /// Language

  String currentLocale = defaultLocale;

  updateLocale(String locale) {
    currentLocale = locale;
    tracks = [];
    notifyListeners();
    // Reset (& reload?) tracks, offset & filters
    if (tracksHasBeenLoaded) {
      reloadTracks();
    }
  }

  /// Active player

  Track? playingTrack;
  // bool hasActivePlayer = false;

  /// Tracks list

  // TODO: Store track filters state

  bool tracksIsLoading = false;
  bool tracksHasBeenLoaded = false;
  String? tracksLoadError;
  int availableTracksCount = 0;
  int tracksLimit = defaultTracksDownloadLimit;
  List<Track> tracks = [];
  // XXX: Store loading handler to be able cancelling it?

  void resetTracks({bool doNotify = true}) {
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

  Future<LoadTracksDataResults> loadNextTracks() async {
    try {
      tracksIsLoading = true;
      notifyListeners();
      final offset = tracks.length;
      logger.t('Starting loading tracks (offset: ${offset})');
      final LoadTracksDataResults results =
          await loadTracksData(offset: offset, limit: tracksLimit);
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

  Future<LoadTracksDataResults> reloadTracks() async {
    resetTracks(doNotify: false);
    return await loadNextTracks();
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
