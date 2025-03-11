import 'package:flutter/material.dart';

import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/routes/appRoutes.dart';

Widget buildRouteWidget(BuildContext context, RouteSettings routeSettings) {
  final name = routeSettings.name ?? defaultAppRoute;
  final nameId = name == defaultAppRoute ? '' : name;
  final func = appRoutes[nameId];
  if (func == null) {
    throw Exception('Undefined a creator for the route "${name}"');
  }
  return func(context);
}
