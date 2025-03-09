import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/PageWrapper.dart';
import 'package:march_tales_app/app/RootScreen.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/core/singletons/routeEvents.dart';
import 'package:march_tales_app/core/types/RouteUpdate.dart';
import 'package:march_tales_app/pages/TrackDetailsScreen.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

final navigatorKey = GlobalKey<NavigatorState>();

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> /* with RestorationMixin */ {
  /* // RestorationMixin: To store navigator state?
   *
   * @override
   * String get restorationId => 'HomePageRestoration';
   *
   * @override
   * void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
   *   // Register the `RestorableRouteFuture` with the state restoration framework.
   *   registerForRestoration(_counterRoute, 'route');
   *   registerForRestoration(_lastCount, 'count');
   * }
   */

  _notifyRouteChanged(String routeName) {
    // Safely update (in the future wrapper) the current route name
    Future.delayed(Duration.zero, () {
      final update = RouteUpdate(
        type: RouteUpdateType.change,
        name: routeName,
      );
      routeEvents.broadcast(update);
    });
  }

  _buildRoute(RouteSettings routeSettings) {
    try {
      final appState = context.watch<AppState>();
      final pageIndex = appState.getNavigationTabIndex();
      // logger.t('[HomePage:routeSettings] routeSettings=${routeSettings}');
      final name = routeSettings.name ?? defaultAppRoute;
      this._notifyRouteChanged(name);
      // Construct proper screen...
      if (name == TrackDetailsScreen.routeName) {
        return TrackDetailsScreen();
      }
      // Create specific root page widget
      return RootScreen(
        routeObserver: routeObserver,
        pageIndex: pageIndex,
      );
    } catch (err, stacktrace) {
      logger.e('[HomePage] _buildRoute: Error: ${err}', error: err, stackTrace: stacktrace);
      debugger();
      /* Future.delayed(Duration.zero, () {
       *   if (context.mounted) {
       *     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       *       showCloseIcon: true,
       *       backgroundColor: Colors.red,
       *       content: Text(convertErrorLikeToString(err)),
       *     ));
       *   }
       * });
       */
      return AppErrorScreen(error: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RestorationScope(
      restorationId: 'HomePage',
      child: PageWrapper(
        navigatorKey: navigatorKey,
        child: PopScope(
          child: Navigator(
            restorationScopeId: 'HomeNavigator',
            observers: [routeObserver],
            key: navigatorKey,
            initialRoute: defaultAppRoute,
            onGenerateRoute: (routeSettings) {
              // Pages generator...
              return MaterialPageRoute(
                builder: (context) {
                  return this._buildRoute(routeSettings);
                },
                settings: routeSettings,
              );
            },
          ),
        ),
      ),
    );
  }
}
