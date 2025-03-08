import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/BottomNavigation.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/components/PlayerBox.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/core/singletons/routeEvents.dart';
import 'package:march_tales_app/core/types/RouteUpdate.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

final playerBoxKey = GlobalKey<PlayerBoxState>();

final logger = Logger();

class PageWrapper extends StatefulWidget {
  const PageWrapper({
    super.key,
    required this.child,
    required this.navigationKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigationKey;

  @override
  State<PageWrapper> createState() => PageWrapperState();
}

class PageWrapperState extends State<PageWrapper> {
  String _routeName = defaultAppRoute;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    routeEvents.subscribe(this._processRouteUpdate);
  }

  _processRouteUpdate(RouteUpdate update) {
    if (this._routeName != update.name && context.mounted) {
      setState(() {
        this._routeName = update.name;
        // debugger();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedIndex = appState.getNavigationTabIndex();

    appState.playerBoxKey = playerBoxKey;

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;

    final homePages = getHomePages();

    final routeName = this._routeName;
    final navigator = Navigator.of(context);
    // final routeName = ModalRoute.of(context)?.settings.name;
    // final isRoot = [> routeName == null || <] routeName.isEmpty || routeName == defaultAppRoute;
    final navigationState = widget.navigationKey.currentState;
    final isRoot = routeName.isEmpty || routeName == defaultAppRoute;
    logger.t('[PageWrapper] isRoot=${isRoot} navigationState=${navigationState} routeName=${routeName} navigator=${navigator} Navigator=${Navigator}');
    debugger();

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
                // TODO: Add back button
                isRoot ? null : Text('X'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage('assets/images/march-cat/march-cat-sq-48.jpg'),
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
              ].nonNulls.toList(),
            ),
          ),
          // actions?
        ),
        bottomNavigationBar: BottomNavigation(
          homePages: homePages,
          selectedIndex: selectedIndex,
          handleIndex: (int value) {
            appState.updateNavigationTabIndex(value);
            final navigator = Navigator.of(context);
            final navigationState = widget.navigationKey.currentState;
            logger.t('[PageWrapper:handleIndex] navigator=${navigator} navigationState=${navigationState}');
            // TODO: Get and clear current (!) navigator (except root screen)...
            Navigator.popUntil(context, (Route<dynamic> route) {
              final name = route.settings.name;
              logger.t('[PageWrapper:handleIndex] removing route name=${name} route=${route} navigator=${navigator}');
              return route.isFirst;
            });
            // if (context.mounted) {
            // Navigator.pushNamedAndRemoveUntil(context, defaultAppRoute, (Route<dynamic> route) => false);
            // }
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
                // TopMenuBox(),
                Expanded(
                  child: ColoredBox(color: colorScheme.surfaceContainerHighest, child: widget.child),
                ),
                PlayerBox(
                  key: playerBoxKey,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
