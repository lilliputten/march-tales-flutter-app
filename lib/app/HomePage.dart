import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/BottomNavigation.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

// import 'package:march_tales_app/app/AppDrawer.dart';

const defaultPageIndex = AppConfig.LOCAL ? 0 : 0;

final logger = Logger();

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RestorationMixin<HomePage> {
  // @see https://api.flutter.dev/flutter/widgets/RestorableInt-class.html
  final RestorableInt _selectedIndex = RestorableInt(defaultPageIndex);

  @override
  String get restorationId => 'HomePage';

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
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;
    final colorScheme = theme.colorScheme;

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
      restorationId: 'HomePage_Widget',
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
                  style: style.copyWith(
                    fontFamily: 'Lobster',
                    fontSize: 28,
                    color: appColors.onBrandColor,
                  ),
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
        // endDrawer: AppDrawer(), // TODO: Side navigation panel
        // onTap: (int i){setState((){index = i;});},
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // TopMenuBox(),
                Expanded(child: pageArea),
                // PlayerSlider(),
                PlayerBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
