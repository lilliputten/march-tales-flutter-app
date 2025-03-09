import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';

import 'package:shared_preferences/shared_preferences.dart'; // DEBUG: To remove later

final logger = Logger();

const _defaultTabIndex = AppConfig.LOCAL ? 0 : 0;

mixin NavigationState {
  void notifyListeners(); // From `ChangeNotifier`
  SharedPreferences? getPrefs(); // From `AppState`

  // Navigation state...

  final ScrollController scrollController = ScrollController();

  int _selectedTabIndex = _defaultTabIndex;

  bool loadNavigationStateSavedPrefs({bool notify = true}) {
    bool hasChanges = false;
    // final savedAppRoute = this.getPrefs()?.getString('appRoute') ?? defaultAppRoute;
    // if (savedAppRoute != this._appRoute) {
    //   this._appRoute = savedAppRoute;
    //   hasChanges = true;
    // }
    final savedTabIndex = this.getPrefs()?.getInt('selectedTabIndex') ?? _defaultTabIndex;
    if (savedTabIndex != this._selectedTabIndex) {
      this._selectedTabIndex = savedTabIndex;
      hasChanges = true;
    }
    if (notify && hasChanges) {
      this.notifyListeners();
    }
    return hasChanges;
  }

  getNavigationTabIndex() {
    return this._selectedTabIndex;
  }

  updateNavigationTabIndex(int value) {
    if (this._selectedTabIndex != value) {
      this._selectedTabIndex = value;
      this.getPrefs()?.setInt('selectedTabIndex', value);
      this.notifyListeners();
    }
  }
}
