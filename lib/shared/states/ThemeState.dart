import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

final logger = Logger();

mixin ThemeState {
  void notifyListeners();
  SharedPreferences? getPrefs();

  /// Theme

  bool isDarkTheme = false;

  bool loadThemeStateSavedPrefs({bool notify = true}) {
    final savedIsDarkTheme = getPrefs()?.getBool('isDarkTheme');
    if (savedIsDarkTheme != null) {
      isDarkTheme = savedIsDarkTheme;
      if (notify) {
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  void toggleDarkTheme(bool value) {
    isDarkTheme = value;
    getPrefs()?.setBool('isDarkTheme', value);
    notifyListeners();
  }
}
