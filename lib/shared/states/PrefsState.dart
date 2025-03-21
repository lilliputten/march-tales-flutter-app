import 'package:logger/logger.dart';

final logger = Logger();

mixin PrefsState {
  void notifyListeners(); // From `ChangeNotifier`
  bool loadThemeStateSavedPrefs({bool notify = true});
  bool loadLocaleStateSavedPrefs({bool notify = true});
  bool loadNavigationStateSavedPrefs({bool notify = true}); // From `NavigationState`
  // SharedPreferences? prefs; // From `AppState`

  // /// Persistent storage
  // SharedPreferences? _prefs;

  // setPrefs(SharedPreferences? value) {
  //   if (value != null) {
  //     this.prefs = value;
  //     this.loadSavedPrefs();
  //   }
  // }
  //
  // loadSavedPrefs() {
  //   logger.t('[loadSavedPrefs] prefs=${this.prefs}');
  //   loadNavigationStateSavedPrefs(notify: true);
  //   loadThemeStateSavedPrefs(notify: true);
  //   loadLocaleStateSavedPrefs(notify: true);
  //   loadLocaleStateSavedPrefs(notify: true);
  // }
}
