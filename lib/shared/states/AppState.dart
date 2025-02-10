import 'package:flutter/material.dart';

import 'ActivePlayerState.dart';
import 'LocaleState.dart';
import 'PrefsState.dart';
import 'TestState.dart';
import 'ThemeState.dart';
import 'TrackState.dart';

class AppState extends ChangeNotifier
    with
        ActivePlayerState,
        LocaleState,
        PrefsState,
        TestState,
        ThemeState,
        TrackState {
  // NOTE: All the states are separated into dedicated mixin modules
}
