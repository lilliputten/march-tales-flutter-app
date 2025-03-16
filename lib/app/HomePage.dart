import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/PageWrapper.dart';
import 'package:march_tales_app/components/mixins/IsRootStateMixin.dart';
import 'package:march_tales_app/core/constants/stateKeys.dart';
import 'package:march_tales_app/routes/buildRouteWidget.dart';
import 'package:march_tales_app/routes/initialRoute.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with IsRootStateMixin /* with RestorationMixin */ {
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
    final pageIndex = appState.getNavigationTabIndex();
    final isMainTab = pageIndex == 0;
    final isRoot = this.isRoot();
    return RestorationScope(
      restorationId: 'HomePage',
      child: PageWrapper(
        isRoot: isRoot,
        pageIndex: pageIndex,
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            final navigator = routeObserver.navigator;
            final canPop = navigator?.canPop() ?? false;
            logger.t(
                '[HomePage:onPopInvokedWithResult] isRoot=${isRoot} didPop=${didPop} result=${result} canPop=${canPop}');
            debugger();
            if (!didPop) {
              // Navigate with the nested navigator if history is not empty
              if (canPop && !isRoot) {
                navigator?.pop(result);
              } else if (!isMainTab) {
                // Go to the main tab
                appState.updateNavigationTabIndex(0);
              } else {
                // Exit from the application
                SystemNavigator.pop();
              }
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
