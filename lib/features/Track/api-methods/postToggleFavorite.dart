import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';

final logger = Logger();

postToggleFavorite({
  required int id,
  required bool favorite,
  DateTime? timestamp,
}) async {
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/toggle-favorite/';
  try {
    final uri = Uri.parse(url);
    final postData = {
      'value': favorite,
      'timestamp_s': timestamp != null ? (timestamp.millisecondsSinceEpoch / 1000).round() : null,
    };
    final jsonData = await serverSession.post(uri, body: postData);
    // NOTE: Returns the list of all actual favorite tracks. Could be used to actualize local data.
    return jsonData;
  } catch (err, stacktrace) {
    final String msg = 'Error incrementing track played count with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    // showErrorToast(msg);
    throw Exception(msg);
  }
}
