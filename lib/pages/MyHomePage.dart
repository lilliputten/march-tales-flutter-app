// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'TracksPage.dart';
import 'FavoritesPage.dart';
import 'GeneratorPage.dart';
import 'QuotePage.dart';
import 'SettingsPage.dart';
import 'components/PlayerBox.dart';
import 'components/TopMenuBox.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
    label: 'Tracks',
    icon: Icon(Icons.audiotrack_outlined),
  ),
  Page(
    widget: () => FavoritesPage(),
    label: 'Favorites',
    icon: Icon(Icons.favorite_border),
  ),
  Page(
    widget: () => GeneratorPage(),
    label: 'Generator',
    icon: Icon(Icons.generating_tokens_outlined),
  ),
  Page(
    widget: () => SettingsPage(),
    label: 'Settings',
    icon: Icon(Icons.settings),
  ),
];

class _MyHomePageState extends State<MyHomePage> {
  // TODO: Put page index to store?
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    final widget = pages[selectedIndex].widget;
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

    // TODO: Generate navigation items from list
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
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      );
    }

    return Scaffold(
      // appBar: Text('appBar'),
      bottomNavigationBar: bottomNavigation(),
      // bottomSheet: Text('bottomSheet'),
      drawer: Text('drawer'),
      // currentIndex: selectedIndex,
      // onTap: (int i){setState((){index = i;});},
      // fixedColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              TopMenuBox(),
              Expanded(child: pageArea),
              PlayerBox(),
              // SafeArea(
              //   bottom: true,
              //   child: bottomNavigation(),
              // ),
            ],
          );
        },
      ),
    );
  }
}
