import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/addQueryParam.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/LoadAuthorsListResults.dart';

final logger = Logger();

Future<LoadAuthorsListResults> loadAuthorsList({
  int offset = 0,
  int? limit,
  String query = '',
}) async {
  // NOTE: It's possible url to contain a few params with the same name (filters, eg) so wi can't use `uri.replace(queryParameters: params)`
  // query = addQueryParam(query, 'full', full, ifAbsent: true);
  if (limit != null) {
    query = addQueryParam(query, 'limit', limit, ifAbsent: true);
  }
  if (offset != 0) {
    query = addQueryParam(query, 'offset', offset, ifAbsent: true);
  }
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/authors/${query}';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return LoadAuthorsListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching authors with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    throw Exception(msg);
  }
}
