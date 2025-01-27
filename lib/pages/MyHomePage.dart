import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';

import 'TracksPage.dart';
import 'FavoritesPage.dart';
import 'GeneratorPage.dart';
// import 'QuotePage.dart';
import 'SettingsPage.dart';
import 'components/PlayerBox.dart';
// import 'components/TopMenuBox.dart';

import 'MyHomePage.i18n.dart';

const defaultPageIndex = AppConfig.LOCAL ? 3 : 0;

final logger = Logger();

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

final pages = [
  // Page(widget: () => QuotePage(), label: 'Quote', icon: Icon(Icons.generating_tokens_outlined)),
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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with RestorationMixin<MyHomePage> {
  // @see https://api.flutter.dev/flutter/widgets/RestorableInt-class.html
  final RestorableInt _selectedIndex = RestorableInt(defaultPageIndex);

  @override
  String get restorationId => 'MyHomePage';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedIndex, 'selectedIndex');
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  // int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // final widget = pages[_selectedIndex].widget;
    final widget = pages[_selectedIndex.value].widget;
    final Widget page = widget();
    // The container for the current page, with its background color
    // and subtle switching animation.
    final pageArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    bottomNavigation() {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed

        backgroundColor: Colors.black,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey,

        // showUnselectedLabels: true,
        // showSelectedLabels: false,

        items: pages
            .map((page) =>
                BottomNavigationBarItem(icon: page.icon, label: page.label))
            .toList(),
        // currentIndex: _selectedIndex,
        currentIndex: _selectedIndex.value,
        onTap: (value) {
          setState(() {
            // _selectedIndex = value;
            _selectedIndex.value = value;
          });
        },
      );
    }

    return RestorationScope(
      restorationId: 'MyHomePage_Widget',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          title: Text(appTitle.i18n),
          // actions
        ),
        bottomNavigationBar: bottomNavigation(),
        // bottomSheet: Text('bottomSheet'),
        drawer: Text('Drawer'), // Side navigation panel
        // onTap: (int i){setState((){index = i;});},
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // TopMenuBox(),
                Expanded(child: pageArea),
                PlayerBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
