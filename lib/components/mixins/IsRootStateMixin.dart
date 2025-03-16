import 'package:flutter/material.dart';

import 'package:march_tales_app/core/singletons/routeEvents.dart';
import 'package:march_tales_app/core/types/RouteUpdate.dart';

abstract class IsRootState {
  const IsRootState();

  bool isRoot();
}

@optionalTypeArgs
mixin IsRootStateMixin<T extends StatefulWidget> on State<T> implements IsRootState {
  bool _isRoot = true;

  @override
  bool isRoot() {
    return this._isRoot;
  }

  @override
  void initState() {
    super.initState();
    routeEvents.subscribe(this._processRouteUpdate);
  }

  @override
  void dispose() {
    routeEvents.unsubscribe(this._processRouteUpdate);
    super.dispose();
  }

  _processRouteUpdate(RouteUpdate update) {
    final type = update.type;
    if (type == RouteUpdateType.rootVisible) {
      setState(() {
        this._isRoot = true;
      });
    } else if (type == RouteUpdateType.rootHidden) {
      setState(() {
        this._isRoot = false;
      });
    }
  }
}
