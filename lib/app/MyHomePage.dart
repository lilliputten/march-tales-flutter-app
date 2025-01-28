import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';

import 'homePages.dart';
import 'BottomNavigation.dart';
import 'AppDrawer.dart';

const defaultPageIndex = AppConfig.LOCAL ? 0 : 0;

final logger = Logger();

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final homePages = getHomePages();

    // final widget = pages[_selectedIndex].widget;
    final widget = homePages[_selectedIndex.value].widget;
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

    return RestorationScope(
      restorationId: 'MyHomePage_Widget',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          title: Text(appTitle.i18n),
          // actions?
        ),
        bottomNavigationBar: BottomNavigation(
          homePages: homePages,
          selectedIndex: _selectedIndex.value,
          handleIndex: (int value) {
            setState(() {
              _selectedIndex.value = value;
            });
          },
        ),
        // bottomSheet: Text('bottomSheet'),
        drawer: AppDrawer(), // Side navigation panel
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
