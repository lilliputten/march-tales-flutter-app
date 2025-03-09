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

const double _headerIconSize = 36;

class PageWrapper extends StatefulWidget {
  const PageWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<PageWrapper> createState() => PageWrapperState();
}

class PageWrapperState extends State<PageWrapper> {
  String _routeName = defaultAppRoute;
  bool _isRoot = true;

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
    // if (context.mounted) {
    final name = update.name;
    final type = update.type;
    if (this._routeName != name) {
      // logger.t('[PageWrapper:route] type=${type} name=${name} routeName=${this._routeName}');
      if (type == RouteUpdateType.rootVisible) {
        setState(() {
          this._isRoot = true;
          this._routeName = name;
        });
      } else if (type == RouteUpdateType.rootHidden) {
        setState(() {
          this._isRoot = false;
          this._routeName = name;
        });
      } else {
        setState(() {
          this._isRoot = name.isEmpty || name == defaultAppRoute;
          this._routeName = name;
        });
      }
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final selectedIndex = appState.getNavigationTabIndex();

    appState.playerBoxKey = playerBoxKey;

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!;

    final navigatorState = this.widget.navigatorKey.currentState;

    // XXX FUTURE: Detect the root status by history depth?
    final isRoot = this._isRoot;

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
                    ? null
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
                // Show logo if root page
                !isRoot
                    ? null
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                          image: AssetImage('assets/images/march-cat/march-cat-sq-48.jpg'),
                        ),
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
          selectedIndex: selectedIndex,
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
                // TopMenuBox(), // XXX FUTURE: Show top menu bar?
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
