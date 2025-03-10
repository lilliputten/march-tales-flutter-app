import 'package:flutter/material.dart';

import 'ActivePlayerState.dart';
import 'FavoritesState.dart';
import 'LocaleState.dart';
import 'NavigationState.dart';
import 'PrefsState.dart';
import 'ThemeState.dart';
import 'TrackState.dart';
import 'UserState.dart';

class AppState extends ChangeNotifier
    with
        UserState,
        ActivePlayerState,
        FavoritesState,
        LocaleState,
        NavigationState,
        PrefsState,
        ThemeState,
        TrackState {
  // NOTE: All the states are separated into dedicated mixin modules
  initialize() {
    this.initActivePlayerState();
    this.initFavoritesState();
  }
}
