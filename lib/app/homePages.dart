import 'package:flutter/material.dart';

import 'package:march_tales_app/core/types/HomePageData.dart';
import 'package:march_tales_app/pages/FavoriteTracksPage.dart';
import 'package:march_tales_app/pages/SettingsPage.dart';
import 'package:march_tales_app/pages/TracksPage.dart';
import 'homePages.i18n.dart';

// import 'package:march_tales_app/pages/GeneratorPage.dart';

List<HomePageData> getHomePages() {
  final homePages = [
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
    // HomePageData(
    //   widget: () => GeneratorPage(),
    //   label: 'Generator'.i18n,
    //   icon: Icon(Icons.generating_tokens_outlined),
    // ),
    HomePageData(
      widget: () => SettingsPage(),
      label: 'Settings'.i18n,
      icon: Icon(Icons.settings),
    ),
  ];
  return homePages;
}
