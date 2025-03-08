import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'ActivePlayerState.dart';
import 'FavoritesState.dart';
import 'LocaleState.dart';
import 'NavigationState.dart';
import 'ThemeState.dart';
import 'TrackState.dart';
import 'UserState.dart';

class AppState extends ChangeNotifier
    with UserState, ActivePlayerState, FavoritesState, LocaleState, NavigationState, ThemeState, TrackState {
  SharedPreferences prefs;

  bool versionsMismatched = false;
  Object? error;

  AppState({
    required this.prefs,
  });

  @override
  SharedPreferences getPrefs() {
    return this.prefs;
  }

  setGlobalError(Object? error) {
    this.error = error;
    notifyListeners();
  }

  setVersionsMismatched({bool notify = true}) {
    this.versionsMismatched = true;
    if (notify) {
      notifyListeners();
    }
  }

  _loadSavedPrefs() {
    loadNavigationStateSavedPrefs(notify: true);
    loadThemeStateSavedPrefs(notify: true);
    loadLocaleStateSavedPrefs(notify: true);
    loadLocaleStateSavedPrefs(notify: true);
  }

  // NOTE: All the states are separated into dedicated mixin modules
  initialize() {
    this.initActivePlayerState();
    this.initFavoritesState();
    this._loadSavedPrefs();
  }
}
