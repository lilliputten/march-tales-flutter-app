// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'FavoritesPage.dart';
import 'GeneratorPage.dart';
import 'QuotePage.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// @see https://docs.flutter.dev/cookbook/networking/fetch-data

class _MyHomePageState extends State<MyHomePage> {
  // TODO: Put page index to store?
  var selectedIndex = 0;

  // // Networking
  // // late Future<Album> futureAlbum;
  // @override
  // void initState() {
  //   super.initState();
  //   // futureAlbum = fetchAlbum();
  // }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = QuotePage();
      case 1:
        page = GeneratorPage();
      case 2:
        page = FavoritesPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

    // TODO: Generate navigation items from list
    bottomNavigation() {
      return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.webhook),
            label: 'Network',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.generating_tokens_outlined),
            label: 'Generator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      );
    }

    sideNavigation(constraints) {
      return NavigationRail(
        extended: constraints.maxWidth >= 600,
        destinations: [
          NavigationRailDestination(
            icon: Icon(Icons.webhook),
            label: Text('Network'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.generating_tokens_outlined),
            label: Text('Generator'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.favorite_border),
            label: Text('Favorites'),
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      );
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(child: bottomNavigation())
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(child: sideNavigation(constraints)),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
