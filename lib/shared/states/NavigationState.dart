import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';

import 'package:shared_preferences/shared_preferences.dart'; // DEBUG: To remove later

final logger = Logger();

const _defaultTabIndex = AppConfig.LOCAL ? 0 : 0;

final ScrollController defaultScrollController = ScrollController();

mixin NavigationState {
  void notifyListeners(); // From `ChangeNotifier`
  SharedPreferences? getPrefs(); // From `AppState`

  // Navigation state...

  RouteObserver<PageRoute> _routeObserver = RouteObserver<PageRoute>();

  RouteObserver<PageRoute> getRouteObserver() {
    return this._routeObserver;
  }

  final List<ScrollController> scrollControllers = [defaultScrollController];

  void addScrollController(ScrollController value) {
    this.scrollControllers.add(value);
    this.notifyListeners();
  }

  void removeScrollController(ScrollController value) {
    this.scrollControllers.remove(value);
    this.notifyListeners();
  }

  ScrollController getDefaultScrollController() {
    return defaultScrollController;
  }

  ScrollController getLastScrollController() {
    try {
      return this.scrollControllers.last; // ?? defaultScrollController;
    } catch (err) {
      return defaultScrollController;
    }
  }

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
