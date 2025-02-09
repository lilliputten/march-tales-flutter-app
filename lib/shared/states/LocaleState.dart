import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/supportedLocales.dart';

final logger = Logger();

mixin LocaleState {
  void notifyListeners();
  SharedPreferences? getPrefs();
  reloadAllTracks({bool notify = true}); // From `TrackState`

  /// Language

  String currentLocale = defaultLocale;

  bool loadLocaleStateSavedPrefs({bool notify = true}) {
    final savedCurrentLocale = getPrefs()?.getString('currentLocale');
    if (savedCurrentLocale != null) {
      currentLocale = savedCurrentLocale;
      if (notify) {
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  updateLocale(String value) async {
    if (currentLocale != value) {
      currentLocale = value;
      getPrefs()?.setString('currentLocale', value);
      await reloadAllTracks();
    }
  }
}
