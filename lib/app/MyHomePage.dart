import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/app/AppColors.dart';

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
    final AppColors appColors = Theme.of(context).extension<AppColors>()!;

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
          backgroundColor: appColors.brandColor,
          foregroundColor: appColors.onBrandColor,
          title: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              spacing: 15,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage(
                        'assets/images/march-cat/march-cat-sq-48.jpg'),
                  ),
                ),
                Text(
                  appTitle.i18n,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          ),
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
        endDrawer: AppDrawer(), // Side navigation panel
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
