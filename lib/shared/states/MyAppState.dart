import 'dart:developer';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';

import 'package:march_tales_app/features/Quote/helpers/fetchQuote.dart';
import 'package:march_tales_app/features/Quote/types/Quote.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';

const int defaultTracksDownloadLimit = 5;

final formatter = YamlFormatter();
final logger = Logger();

class MyAppState extends ChangeNotifier {
  /// App info
  String? projectInfo;

  void setProjectInfo(String? info) {
    projectInfo = info;
    notifyListeners();
  }

  /// Tracks list

  List<Track> tracks = [];

  void loadTracks(
      {int offset = 0, int limit = defaultTracksDownloadLimit}) async {
    final String url =
        '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks';
    try {
      var uri = Uri.parse(url);
      if (offset != 0) {
        uri = uri.replace(queryParameters: {
          'offset': offset.toString(),
          // ...queryParams,
        });
      }
      if (limit != 0) {
        uri = uri.replace(queryParameters: {
          'limit': limit.toString(),
        });
      }
      logger.t('Starting loading tracks: ${uri}');
      final jsonData = await serverSession.get(uri);
      // logger.t('Loaded tracks data: ${formatter.format(jsonData)}');
      final loadedTracks = List<dynamic>.from(jsonData['results'])
          .map((data) => Track.fromJson(data))
          .toList();
      logger.t('Loaded tracks:\n${formatter.format(loadedTracks)}');
      tracks = loadedTracks;
      // debugger();
      notifyListeners();
    } catch (err, stacktrace) {
      final String msg = 'Error fetching tracks with an url $url: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
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
