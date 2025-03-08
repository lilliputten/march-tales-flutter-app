import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/core/singletons/routeEvents.dart';
import 'package:march_tales_app/core/types/RouteUpdate.dart';

final logger = Logger();

final navigatorKey = GlobalKey<NavigatorState>();

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
    required this.pageIndex,
    required this.routeObserver,
  });

  final int pageIndex;
  final RouteObserver<PageRoute> routeObserver;

  @override
  State<RootScreen> createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> with RouteAware {
  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(this.context) as PageRoute;
    widget.routeObserver.subscribe(this, route);
    // NOTE: Use `didPush`, `didPopNext` and other route handlers
  }

  _notifyRootDisplayed() {
    // Notify about root screen visiblility
    Future.delayed(Duration.zero, () {
      final update = RouteUpdate(
        type: RouteUpdateType.rootDisplayed,
        name: defaultAppRoute,
      );
      routeEvents.broadcast(update);
    });
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
    this._notifyRootDisplayed();
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    this._notifyRootDisplayed();
  }

  @override
  Widget build(BuildContext context) {
    // Display current widget according to bottom bavigation status
    final homePages = getHomePages();
    final pageIndex = this.widget.pageIndex;
    final widget = homePages[pageIndex].widget;
    final Widget page = widget();
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: page,
    );
  }
}
