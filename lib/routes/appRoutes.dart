import 'package:flutter/material.dart';

import 'package:march_tales_app/app/RootScreen.dart';
import 'package:march_tales_app/screens/AuthorScreen.dart';
import 'package:march_tales_app/screens/AuthorsListScreen.dart';
import 'package:march_tales_app/screens/RubricScreen.dart';
import 'package:march_tales_app/screens/RubricsListScreen.dart';
import 'package:march_tales_app/screens/TagScreen.dart';
import 'package:march_tales_app/screens/TagsListScreen.dart';
import 'package:march_tales_app/screens/TrackDetailsScreen.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  '': (context) => const RootScreen(), // defaultAppRoute
  TrackDetailsScreen.routeName: (context) => const TrackDetailsScreen(),
  AuthorScreen.routeName: (context) => const AuthorScreen(),
  AuthorsListScreen.routeName: (context) => const AuthorsListScreen(),
  RubricScreen.routeName: (context) => const RubricScreen(),
  RubricsListScreen.routeName: (context) => const RubricsListScreen(),
  TagScreen.routeName: (context) => const TagScreen(),
  TagsListScreen.routeName: (context) => const TagsListScreen(),
};
