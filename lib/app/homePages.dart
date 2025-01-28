import 'package:flutter/material.dart';
import 'package:march_tales_app/pages/FavoritesPage.dart';
import 'package:march_tales_app/pages/GeneratorPage.dart';
import 'package:march_tales_app/pages/SettingsPage.dart';
import 'package:march_tales_app/pages/TracksPage.dart';

import 'homePages.i18n.dart';

class Page {
  final Widget Function() widget;
  final String label;
  final Icon icon;
  const Page({
    required this.widget,
    required this.label,
    required this.icon,
  });
}

final homePages = [
  Page(
    widget: () => TracksPage(),
    label: 'Tracks'.i18n,
    icon: Icon(Icons.audiotrack_outlined),
  ),
  Page(
    widget: () => FavoritesPage(),
    label: 'Favorites'.i18n,
    icon: Icon(Icons.favorite_border),
  ),
  Page(
    widget: () => GeneratorPage(),
    label: 'Generator'.i18n,
    icon: Icon(Icons.generating_tokens_outlined),
  ),
  Page(
    widget: () => SettingsPage(),
    label: 'Settings'.i18n,
    icon: Icon(Icons.settings),
  ),
];
