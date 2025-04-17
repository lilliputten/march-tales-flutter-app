import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/types/HomePageData.dart';
import 'package:march_tales_app/pages/FavoriteTracksPage.dart';
import 'package:march_tales_app/pages/RecentsPage.dart';
import 'package:march_tales_app/pages/SettingsPage.dart';
import 'package:march_tales_app/pages/TracksPage.dart';
import 'homePages.i18n.dart';

final logger = Logger();

enum HomePages {
  recents,
  root,
  favorites,
  settings,
}

List<HomePageData> getHomePages() {
  final homePages = [
    HomePageData(
      widget: () => RecentsPage(),
      label: 'Home'.i18n,
      icon: Icon(Icons.home),
    ),
    HomePageData(
      widget: () => TracksPage(),
      label: 'Tracks'.i18n,
      icon: Icon(Icons.headphones),
    ),
    HomePageData(
      widget: () => FavoriteTracksPage(),
      label: 'Favorites'.i18n,
      icon: Icon(Icons.favorite_border),
    ),
    HomePageData(
      widget: () => SettingsPage(),
      label: 'Settings'.i18n,
      icon: Icon(Icons.settings),
    ),
  ];
  return homePages;
}
