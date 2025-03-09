import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/PageWrapper.dart';
import 'package:march_tales_app/app/RootScreen.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/core/singletons/routeEvents.dart';
import 'package:march_tales_app/core/types/RouteUpdate.dart';
import 'package:march_tales_app/pages/TrackDetailsScreen.dart';

final logger = Logger();

final navigatorKey = GlobalKey<NavigatorState>();

// Enable debugging fake internal routes, see `_debugTrackId` in `TrackDetailsScreen.dart`
const _useDebugRoute = false;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.routeObserver,
  });

  final RouteObserver<PageRoute> routeObserver;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> /* with RestorationMixin */ {
  /* // RestorationMixin: To store navigator state?
   * @override
   * String get restorationId => 'HomePageRestoration';
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
      // logger.t('[HomePage:routeSettings] routeSettings=${routeSettings}');
      final name = routeSettings.name ?? defaultAppRoute;
      this._notifyRouteChanged(name);
      // Construct proper screen...
      switch (name) {
        case TrackDetailsScreen.routeName:
          return TrackDetailsScreen();
        default:
          return RootScreen(
            routeObserver: this.widget.routeObserver,
          );
      }
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
    final initialRoute = _useDebugRoute && AppConfig.LOCAL ? TrackDetailsScreen.routeName : defaultAppRoute;
    return RestorationScope(
      restorationId: 'HomePage',
      child: PageWrapper(
        navigatorKey: navigatorKey,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              // Navigate with nested navigator...
              final navigator = this.widget.routeObserver.navigator;
              navigator?.pop(result);
            }
          },
          child: Navigator(
            restorationScopeId: 'HomeNavigator',
            observers: [this.widget.routeObserver],
            key: navigatorKey,
            initialRoute: initialRoute,
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
