import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/UserTrack.dart';

final logger = Logger();

Future<UserTrack> postUpdatePosition({
  required int id,
  required Duration position,
  DateTime? timestamp,
}) async {
  final double positionS = position.inMilliseconds / 1000;
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/update-position/';
  try {
    final uri = Uri.parse(url);
    final postData = {
      'position': double.parse(positionS.toStringAsFixed(3)),
      'timestamp_s': timestamp != null ? (timestamp.millisecondsSinceEpoch / 1000).round() : null,
    };
    final jsonData = await serverSession.post(uri, body: postData);
    return UserTrack.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error updating playback position';
    logger.e('${msg} position: ${position} id: ${id} url: ${url}', error: err, stackTrace: stacktrace);
    debugger();
    // showErrorToast(msg);
    throw Exception(msg);
  }
}
