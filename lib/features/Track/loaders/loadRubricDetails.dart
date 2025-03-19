import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Rubric.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<Rubric> loadRubricDetails(int id) async {
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/rubrics/${id}/';
  try {
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return Rubric.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching rubrics with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    // showErrorToast(msg);
    throw Exception(msg);
  }
}
