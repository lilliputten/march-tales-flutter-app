import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<Author> loadAuthorDetails(int id) async {
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/authors/${id}/';
  try {
    // throw new Exception('Test error');
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    return Author.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching authors with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    throw Exception(msg);
  }
}
