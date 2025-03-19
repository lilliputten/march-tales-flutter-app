import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/addQueryParam.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<LoadTracksListResults> loadTracksByIds(
  Iterable<int> ids, {
  int offset = 0,
  int? limit,
  int full = tracksFullDataParam,
  String query = '',
}) async {
  query = addQueryParam(query, 'full', full, ifAbsent: true);
  if (limit != null) {
    query = addQueryParam(query, 'limit', limit, ifAbsent: true);
  }
  if (offset != 0) {
    query = addQueryParam(query, 'offset', offset, ifAbsent: true);
  }
  if (ids.isNotEmpty) {
    query = addQueryParam(query, 'ids', ids.join(','), ifAbsent: true);
  }
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/by-ids/${query}';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return LoadTracksListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tracks with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    // showErrorToast(msg);
    throw Exception(msg);
  }
}
