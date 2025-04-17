import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/addQueryParam.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';

final logger = Logger();

Future<RecentResults> loadRecents({
  int full = tracksFullDataParam,
  String query = '',
}) async {
  // DEBUG
  if (AppConfig.LOCAL) {
    await Future.delayed(Duration(seconds: 3));
  }
  query = addQueryParam(query, 'full', full, ifAbsent: true);
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/recents/${query}';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    final results = RecentResults.fromJson(jsonData);
    return results;
  } catch (err, stacktrace) {
    final String msg = 'Error fetching recents data with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    throw ConnectionException(msg);
  }
}
