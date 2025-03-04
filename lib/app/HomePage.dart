import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/BottomNavigation.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

// import 'package:march_tales_app/app/AppDrawer.dart';

final logger = Logger();

final playerBoxKey = GlobalKey<PlayerBoxState>();

const double logoSize = 48;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedIndex = appState.getNavigationTabIndex();

    appState.playerBoxKey = playerBoxKey;

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;
    final colorScheme = theme.colorScheme;

    final homePages = getHomePages();

    final widget = homePages[selectedIndex].widget;
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
          titleSpacing: 15,
          backgroundColor: appColors.brandColor,
          foregroundColor: appColors.onBrandColor,
          title: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              spacing: 8,
              children: [
                SvgPicture.asset(
                  'assets/images/march-cat/cat-icon.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: logoSize,
                  height: logoSize,
                ),
                /* // Use raster logo
                 * ClipRRect(
                 *   borderRadius: BorderRadius.circular(100),
                 *   child: Image(
                 *     image: AssetImage('assets/images/march-cat/march-cat-sq-48.jpg'),
                 *   ),
                 * ),
                 */
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
          selectedIndex: selectedIndex,
          handleIndex: (int value) {
            appState.updateNavigationTabIndex(value);
            // setState(() {
            //   _selectedIndex.value = value;
            // });
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
                PlayerBox(
                  key: playerBoxKey,
                  // track: playingTrack,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
