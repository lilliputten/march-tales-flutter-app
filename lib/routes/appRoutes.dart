import 'package:flutter/material.dart';

import 'package:march_tales_app/app/RootScreen.dart';
import 'package:march_tales_app/screens/AuthorScreen.dart';
import 'package:march_tales_app/screens/RubricScreen.dart';
import 'package:march_tales_app/screens/TrackDetailsScreen.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  TrackDetailsScreen.routeName: (context) => const TrackDetailsScreen(),
  AuthorScreen.routeName: (context) => const AuthorScreen(),
  RubricScreen.routeName: (context) => const RubricScreen(),
  '': (context) => const RootScreen(), // defaultAppRoute
};
