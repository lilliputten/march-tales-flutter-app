import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

import 'shared-translations.i18n.dart';

final logger = Logger();

Future<Track> loadTrackDetails(int id) async {
  final String url =
      '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/?full=${tracksFullDataParam}';
  try {
    final uri = Uri.parse(url);
    logger.t('[loadTrackDetails] id=${id} url=${url}');
    final jsonData = await serverSession.get(uri);
    return Track.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error loading track details.';
    logger.e('${msg} id=${id} url=$url: $err', error: err, stackTrace: stacktrace);
    debugger();
    final String extraMsg = '${msg.i18n} (${"Track".i18n} #${id})';
    showErrorToast(extraMsg);
    throw Exception(extraMsg);
  }
}
