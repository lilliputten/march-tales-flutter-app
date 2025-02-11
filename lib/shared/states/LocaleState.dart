import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/supportedLocales.dart';

final logger = Logger();

mixin LocaleState {
  void notifyListeners();
  SharedPreferences? getPrefs(); // From `PrefsState`
  reloadAllTracks({bool notify = true}); // From `TrackState`
  reloadFavoritesData(); // From `FavoritesState`

  /// Language

  String currentLocale = defaultLocale;

  bool loadLocaleStateSavedPrefs({bool notify = true}) {
    final savedCurrentLocale = this.getPrefs()?.getString('currentLocale');
    if (savedCurrentLocale != null) {
      this.currentLocale = savedCurrentLocale;
      if (notify) {
        this.notifyListeners();
      }
      return true;
    }
    return false;
  }

  updateLocale(String value) async {
    if (this.currentLocale != value) {
      this.currentLocale = value;
      this.getPrefs()?.setString('currentLocale', value);
      await Future.wait<dynamic>([
        this.reloadAllTracks(),
        this.reloadFavoritesData(),
      ]);
    }
  }
}
