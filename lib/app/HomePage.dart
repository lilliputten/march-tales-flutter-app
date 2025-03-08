import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/PageWrapper.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/core/singletons/routeEvents.dart';
import 'package:march_tales_app/core/types/RouteUpdate.dart';
import 'package:march_tales_app/pages/TrackDetailsScreen.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

// import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

// import 'package:march_tales_app/app/AppDrawer.dart';

final logger = Logger();

final navigationKey = GlobalKey<NavigatorState>();

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RestorationScope(
      // key: Key('HomePage-{selectedIndex}'),
      restorationId: 'HomePage',
      child: PageWrapper(
        navigationKey: navigationKey,
        child: PopScope(
          // canPop: () async => !await navigationKey.currentState.maybePop(),
          child: Navigator(
            key: navigationKey,
            initialRoute: defaultAppRoute,
            onGenerateRoute: (routeSettings) {
              // logger.t('[HomePage:onGenerateRoute] routeSettings=${routeSettings}');
              return MaterialPageRoute(
                builder: (context) {
                  final appState = context.watch<AppState>();
                  final selectedIndex = appState.getNavigationTabIndex();
                  final name = routeSettings.name;
                  // Future.delayed(Duration.zero, () {
                  //   final route = name ?? defaultAppRoute;
                  //   // logger.t('[HomePage:onGenerateRoute:update] route=${route}');
                  //   final update = RouteUpdate(
                  //     type: RouteUpdateType.change,
                  //     name: route,
                  //   );
                  //   routeEvents.broadcast(update);
                  //   // appState.updateAppRoute(route);
                  // });
                  if (name == TrackDetailsScreen.routeName) {
                    final args = routeSettings.arguments as TrackDetailsScreenArguments;
                    return TrackDetailsScreen(track: args.track);
                  }
                  // Create specific root page widget
                  final homePages = getHomePages();
                  final widget = homePages[selectedIndex].widget;
                  final Widget page = widget();
                  final pageArea = AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: page,
                  );
                  return pageArea;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
