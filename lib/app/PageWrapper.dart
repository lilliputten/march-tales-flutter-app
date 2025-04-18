import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/BottomNavigation.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/components/TopFilterBox.dart';
import 'package:march_tales_app/core/constants/stateKeys.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

final logger = Logger();

const double _headerIconSize = 36;

class PageWrapper extends StatelessWidget {
  const PageWrapper({
    super.key,
    required this.child,
    required this.isRoot,
    required this.pageIndex,
  });

  final Widget child;
  final bool isRoot;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final isSettingsPage = pageIndex == HomePages.settings.index;
    final isHomePage = pageIndex == 0;
    final hidableNavigation = !isSettingsPage && !isHomePage; // appState.isHidableNavigation();
    final showPlayer = !isSettingsPage;

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;

    final navigatorState = navigatorKey.currentState;

    // final query = appState.getFilterQuery();

    return RestorationScope(
      restorationId: 'PageWrapper',
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 15,
          backgroundColor: appColors.brandColor,
          foregroundColor: appColors.onBrandColor,
          title: FittedBox(
            fit: BoxFit.contain,
            child: Row(
              spacing: 10,
              children: [
                // Show back button if not on the root page
                isRoot
                    ? InkWell(
                        onTap: () {
                          // Activate the 1st tab
                          appState.updateNavigationTabIndex(0);
                          // Clear all the current (!) navigator routes in order to see the top tabs' content...
                          navigatorState?.popUntil((Route<dynamic> route) {
                            return route.isFirst;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: AssetImage('assets/images/march-cat/march-cat-sq-48.jpg'),
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          size: _headerIconSize,
                          color: appColors.onBrandColor,
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          navigatorState?.pop();
                        },
                      ),
                // Show app title
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
              ].nonNulls.toList(),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          homePages: getHomePages(),
          selectedIndex: pageIndex,
          hidableNavigation: hidableNavigation,
          handleIndex: (int value) {
            appState.updateNavigationTabIndex(value);
            // Clear all the current (!) navigator routes in order to see the top tabs' content...
            navigatorState?.popUntil((Route<dynamic> route) {
              // logger.t('[PageWrapper:handleIndex] removing route name=${route.settings.name} route=${route}');
              return route.isFirst;
            });
          },
        ),
        // bottomSheet: Text('bottomSheet'),
        // endDrawer: AppDrawer(), // XXX FUTURE: Side navigation panel, see `AppDrawer`
        body: LayoutBuilder(
          builder: (context, constraints) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            return Column(
              children: [
                TopFilterBox(),
                Expanded(
                  child: ColoredBox(color: colorScheme.surfaceContainerHighest, child: this.child),
                ),
                PlayerBox(
                  key: playerBoxKey,
                  show: showPlayer,
                  isAuthorized: appState.isAuthorized(),
                  navigatorState: navigatorState,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
