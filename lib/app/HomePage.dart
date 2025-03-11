import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/PageWrapper.dart';
import 'package:march_tales_app/routes/buildRouteWidget.dart';
import 'package:march_tales_app/routes/constants.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

final navigatorKey = GlobalKey<NavigatorState>();

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

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
   *   registerForRestoration(navigatorStateValue, 'navigatorStateValue'); // Retrieve and store navigatorStateValue
   * }
   */

  _buildRoute(RouteSettings routeSettings) {
    try {
      return buildRouteWidget(this.context, routeSettings); // , this.widget.routeObserver);
    } catch (err, stacktrace) {
      logger.e('[HomePage] _buildRoute: Error: ${err}', error: err, stackTrace: stacktrace);
      debugger();
      return AppErrorScreen(error: err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final routeObserver = appState.getRouteObserver();
    return RestorationScope(
      restorationId: 'HomePage',
      child: PageWrapper(
        navigatorKey: navigatorKey,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              final navigator = routeObserver.navigator;
              // Navigate with nested navigator...
              navigator?.pop(result);
            }
          },
          child: Navigator(
            restorationScopeId: 'HomeNavigator',
            observers: [routeObserver],
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
