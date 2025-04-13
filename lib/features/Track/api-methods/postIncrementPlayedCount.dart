import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<Track> postIncrementPlayedCount({
  int id = 0,
  DateTime? timestamp,
}) async {
  final String url =
      '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/increment-played-count/?full=${tracksFullDataParam}';
  final postData = {
    'timestamp_s': timestamp != null ? (timestamp.millisecondsSinceEpoch / 1000).round() : null,
  };
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.post(uri, body: postData);
    return Track.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error incrementing track played count';
    logger.e('${msg} url: ${url}', error: err, stackTrace: stacktrace);
    debugger();
    // showErrorToast(msg);
    throw Exception(msg);
  }
}
