import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<LoadTracksListResults> loadTracksList({
  int offset = 0,
  int limit = defaultTracksDownloadLimit,
  int full = tracksFullDataParam,
  String query = '',
  // TODO: Add filter/sort parameters
}) async {
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${query}';
  try {
    final uri = Uri.parse(url);
    final queryParameters = {...uri.queryParameters};
    if (!queryParameters.containsKey('full')) {
      queryParameters['full'] = full.toString();
    }
    if (limit != 0) {
      queryParameters['limit'] = limit.toString();
    }
    if (offset != 0) {
      queryParameters['offset'] = offset.toString();
    }
    final jsonData = await serverSession.get(uri.replace(queryParameters: queryParameters));
    return LoadTracksListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tracks with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    showErrorToast(msg);
    throw Exception(msg);
  }
}
