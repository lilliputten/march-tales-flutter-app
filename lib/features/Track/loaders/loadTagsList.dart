import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTagsListResults.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<LoadTagsListResults> loadTagsList({
  int offset = 0,
  int limit = 0,
  // TODO: Add filter/sort parameters
}) async {
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tags/';
  try {
    final uri = Uri.parse(url);
    final params = {...uri.queryParameters};
    if (limit != 0) {
      params['limit'] = limit.toString();
    }
    if (offset != 0) {
      params['offset'] = offset.toString();
    }
    final jsonData = await serverSession.get(uri.replace(queryParameters: params));
    return LoadTagsListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tags with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    showErrorToast(msg);
    throw Exception(msg);
  }
}
