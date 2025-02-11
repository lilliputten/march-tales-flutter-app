import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

mixin PrefsState {
  void notifyListeners(); // From `ChangeNotifier`
  bool loadThemeStateSavedPrefs({bool notify = true});
  bool loadLocaleStateSavedPrefs({bool notify = true});
  bool loadActivePlayerStateSavedPrefs({bool notify = true});
  bool loadNavigationStateSavedPrefs(
      {bool notify = true}); // From `NavigationState`

  /// Persistent storage
  SharedPreferences? _prefs;

  SharedPreferences? getPrefs() {
    return this._prefs;
  }

  setPrefs(SharedPreferences? value) {
    if (value != null) {
      this._prefs = value;
      this._loadSavedPrefs();
    }
  }

  _loadSavedPrefs() {
    loadNavigationStateSavedPrefs(notify: true);
    loadThemeStateSavedPrefs(notify: true);
    loadLocaleStateSavedPrefs(notify: true);
    loadActivePlayerStateSavedPrefs(notify: true);
    loadLocaleStateSavedPrefs(notify: true);
  }
}
