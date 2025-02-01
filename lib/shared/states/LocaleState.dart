import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/supportedLocales.dart';

final logger = Logger();

mixin LocaleState {
  void notifyListeners();
  SharedPreferences? getPrefs();
  List<Track> getTracks();
  void setTracks(List<Track> value, {bool notify = true});
  reloadAllTracks({bool notify = true});

  /// Language

  String currentLocale = defaultLocale;

  loadLocaleStateSavedPrefs() {
    final savedCurrentLocale = getPrefs()?.getString('currentLocale');
    if (savedCurrentLocale != null) {
      currentLocale = savedCurrentLocale;
    }
    notifyListeners();
  }

  updateLocale(String value) async {
    currentLocale = value;
    reloadAllTracks(notify: false);
    notifyListeners();
  }
}
