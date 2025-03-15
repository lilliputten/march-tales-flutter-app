import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<Track> loadTrackDetails(int id) async {
  final String url =
      '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/?full=${tracksFullDataParam}';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return Track.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tracks with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    showErrorToast(msg);
    throw Exception(msg);
  }
}
