import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RestorationScope(
      restorationId: 'HomePage',
      child: PageWrapper(
        navigatorKey: navigatorKey,
        child: PopScope(
          child: Navigator(
            observers: [routeObserver],
            key: navigatorKey,
            initialRoute: defaultAppRoute,
            onGenerateRoute: (routeSettings) {
              // Pages generator...
              return MaterialPageRoute(
                builder: (context) {
                  final appState = context.watch<AppState>();
                  final selectedIndex = appState.getNavigationTabIndex();
                  final name = routeSettings.name ?? defaultAppRoute;
                  // Safely update (in the future wrapper) the current route name
                  Future.delayed(Duration.zero, () {
                    final update = RouteUpdate(
                      type: RouteUpdateType.change,
                      name: name,
                    );
                    routeEvents.broadcast(update);
                  });
                  // Construct proper screen...
                  if (name == TrackDetailsScreen.routeName) {
                    final args = routeSettings.arguments as TrackDetailsScreenArguments;
                    return TrackDetailsScreen(track: args.track);
                  }
                  // Create specific root page widget
                  return RootScreen(
                    routeObserver: routeObserver,
                    pageIndex: selectedIndex,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
