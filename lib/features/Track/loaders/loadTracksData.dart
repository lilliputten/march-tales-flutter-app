import 'dart:developer';
import 'package:logger/logger.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';

import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

import 'package:march_tales_app/features/Track/trackConstants.dart';

final formatter = YamlFormatter();
final logger = Logger();

class LoadTracksDataResults {
  final int count;
  final List<Track> results;
  const LoadTracksDataResults({
    required this.count,
    required this.results,
  });
  factory LoadTracksDataResults.fromJson(Map<String, dynamic> json) {
    try {
      return LoadTracksDataResults(
        count: json['count'] as int,
        results: List<dynamic>.from(json['results'])
            .map<Track>((data) => Track.fromJson(data))
            .toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse LoadTracksDataResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}

Future<LoadTracksDataResults> loadTracksData({
  int offset = 0,
  int limit = defaultTracksDownloadLimit,
  // TODO: Add filter/sort parameters
}) async {
  final String url =
      '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks';
  try {
    var uri = Uri.parse(url);
    if (offset != 0) {
      uri = uri.replace(queryParameters: {
        'offset': offset.toString(),
        // ...queryParams,
      });
    }
    if (limit != 0) {
      uri = uri.replace(queryParameters: {
        'limit': limit.toString(),
      });
    }
    logger.t('Starting loading tracks: ${uri}');
    final jsonData = await serverSession.get(uri);
    return LoadTracksDataResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tracks with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    showErrorToast(msg);
    throw Exception(msg);
  }
}
