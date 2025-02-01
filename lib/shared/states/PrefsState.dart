import 'package:logger/logger.dart';

import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

mixin PrefsState {
  void notifyListeners();
  void loadThemeStateSavedPrefs();
  void loadLocaleStateSavedPrefs();

  /// Persistent storage
  SharedPreferences? prefs;

  SharedPreferences? getPrefs() {
    return prefs;
  }

  setPrefs(SharedPreferences? value) {
    if (value != null) {
      prefs = value;
      loadSavedPrefs();
    }
  }

  loadSavedPrefs() {
    loadThemeStateSavedPrefs();
    loadLocaleStateSavedPrefs();
  }
}
