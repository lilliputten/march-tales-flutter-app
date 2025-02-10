import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

mixin PrefsState {
  void notifyListeners();
  bool loadThemeStateSavedPrefs({bool notify = true});
  bool loadLocaleStateSavedPrefs({bool notify = true});
  bool loadActivePlayerStateSavedPrefs({bool notify = true});

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
    loadThemeStateSavedPrefs(notify: true);
    loadLocaleStateSavedPrefs(notify: true);
    loadActivePlayerStateSavedPrefs(notify: true);
  }
}
