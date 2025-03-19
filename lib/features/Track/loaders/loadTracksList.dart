import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/addQueryParam.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';

final logger = Logger();

Future<LoadTracksListResults> loadTracksList({
  int offset = 0,
  int limit = defaultTracksDownloadLimit,
  int full = tracksFullDataParam,
  String query = '',
}) async {
  // DEBUG
  if (AppConfig.LOCAL) {
    await Future.delayed(Duration(seconds: 1));
  }
  // throw new ConnectionException('Test error');
  // NOTE: It's possible url to contain a few params with the same name (filters, eg) so wi can't use `uri.replace(queryParameters: params)`
  // final newUri = uri.replace(queryParameters: params);
  query = addQueryParam(query, 'full', full, ifAbsent: true);
  if (limit != 0) {
    query = addQueryParam(query, 'limit', limit, ifAbsent: true);
  }
  if (offset != 0) {
    query = addQueryParam(query, 'offset', offset, ifAbsent: true);
  }
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${query}';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return LoadTracksListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tracks with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    throw ConnectionException(msg);
  }
}
