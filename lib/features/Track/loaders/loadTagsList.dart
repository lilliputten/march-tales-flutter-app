import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/addQueryParam.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTagsListResults.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<LoadTagsListResults> loadTagsList({
  int offset = 0,
  int limit = 0,
  String query = '',
}) async {
  // query = addQueryParam(query, 'full', full, ifAbsent: true);
  if (limit != 0) {
    query = addQueryParam(query, 'limit', limit, ifAbsent: true);
  }
  if (offset != 0) {
    query = addQueryParam(query, 'offset', offset, ifAbsent: true);
  }
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tags/${query}';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return LoadTagsListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tags with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    showErrorToast(msg);
    throw Exception(msg);
  }
}
