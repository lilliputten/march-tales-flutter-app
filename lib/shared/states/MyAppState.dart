import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:english_words/english_words.dart'; // DEBUG: To remove later
import 'package:shared_preferences/shared_preferences.dart';

import 'package:just_audio/just_audio.dart';

import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
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

  /// Player & active track

  Track? playingTrack;
  bool isPlaying = false;
  bool isPaused = false;
  AudioPlayer? activePlayer = AudioPlayer();
  Timer? activeTimer;
  Duration? activePosition;

  AudioPlayer getPlayer() {
    activePlayer ??= AudioPlayer();
    return activePlayer!;
  }

  void _playerStop({bool notify = true}) {
    activePosition = null;
    _playerTimerStop();
    if (activePlayer != null) {
      activePlayer!.stop();
      activePlayer = null;
    }
    isPlaying = false;
    isPaused = false;
    if (notify) {
      notifyListeners();
    }
  }

  void _playerTimerTick(Timer timer) {
    activePosition = activePlayer?.position;
    final position = activePosition?.inMilliseconds;
    final duration = activePlayer?.duration?.inMilliseconds;
    logger.t(
        '_playerTimerTick: Tick: ${timer.tick} position=${position} duration=${duration}');
    if (position! >= duration!) {
      _playerStop(notify: false);
    }
    notifyListeners();
  }

  void _playerTimerStop() {
    if (activeTimer != null) {
      activeTimer!.cancel();
      activeTimer = null;
    }
  }

  void _playerTimerStart() {
    activeTimer = Timer.periodic(Duration(seconds: 1), _playerTimerTick);
  }

  void _playerStart(Track track) async {
    playingTrack = track;
    final String url = '${AppConfig.TALES_SERVER_HOST}${track.audio_file}';
    final player = getPlayer();
    // @see https://github.com/ryanheise/just_audio/tree/minor/just_audio
    logger.t('_playerStart: Start playing track ${track}: ${url}');
    final duration = await player.setUrl(url);
    player.setVolume(1);
    final playing = player.play(); // Returns the Future
    // TODO: Increment played count (via API)
    isPlaying = true;
    isPaused = false;
    // Finished hadler
    playing.whenComplete(() {
      if (playingTrack?.id == track.id && isPlaying) {
        // If the same track is playing
        logger.t(
            '_playerStart: Finished: track: ${track}, playingTrack: ${playingTrack}, isPaused: ${isPaused}');
        if (!isPaused) {
          _playerStop(notify: true);
        }
      }
    });
    logger.t('_playerStart: Started playing track ${track}: ${duration}');
    // Start timer...
    _playerTimerStart();
    // Update all...
    notifyListeners();
  }

  /// Track's play button handler
  void playTrack(Track track) async {
    logger.t('playTrack ${track}');
    if (playingTrack != null) {
      if (isPlaying && playingTrack!.id == track.id) {
        // Just pause/resume and exit if it was actively playing current track
        logger.t(
            'playTrack: Pausing/resuming active track: ${playingTrack} isPaused: ${isPaused}');
        if (!isPaused) {
          activePlayer?.pause();
          isPaused = true;
          _playerTimerStop();
        } else {
          activePlayer?.play();
          isPaused = false;
          _playerTimerStart();
        }
        notifyListeners();
        return;
      }
      // Else stop playback and continue
      _playerStop(notify: false);
    }
    // Start playing the track
    _playerStart(track);
  }

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

  void resetTracks({bool notify = true}) {
    tracksHasBeenLoaded = false;
    availableTracksCount = 0;
    tracks = [];
    tracksLoadError = null;
    tracksIsLoading = false;
    if (notify) {
      notifyListeners();
    }
  }

  Future<LoadTracksListResults> reloadTracks() async {
    resetTracks(notify: false);
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
      // logger.t('Starting loading tracks (offset: ${offset})');
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
