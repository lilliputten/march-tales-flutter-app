import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final formatter = YamlFormatter();
final logger = Logger();

class LoadTracksListResults {
  final int count;
  final List<Track> results;
  const LoadTracksListResults({
    required this.count,
    required this.results,
  });
  factory LoadTracksListResults.fromJson(Map<String, dynamic> json) {
    try {
      return LoadTracksListResults(
        count: json['count'] as int,
        results: List<dynamic>.from(json['results'])
            .map<Track>((data) => Track.fromJson(data))
            .toList(),
      );
    } catch (err, stacktrace) {
      final String msg = 'Can not parse LoadTracksListResults data: $err';
      logger.e(msg, error: err, stackTrace: stacktrace);
      debugger();
      throw FormatException(msg);
    }
  }
}

Future<LoadTracksListResults> loadTracksList({
  int offset = 0,
  int limit = defaultTracksDownloadLimit,
  // TODO: Add filter/sort parameters
}) async {
  final String url =
      '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks';
  try {
    final uri = Uri.parse(url);
    final params = {...uri.queryParameters};
    if (limit != 0) {
      params['limit'] = limit.toString();
    }
    if (offset != 0) {
      params['offset'] = offset.toString();
    }
    final jsonData =
        await serverSession.get(uri.replace(queryParameters: params));
    return LoadTracksListResults.fromJson(jsonData);
  } catch (err, stacktrace) {
    final String msg = 'Error fetching tracks with an url $url: $err';
    logger.e(msg, error: err, stackTrace: stacktrace);
    debugger();
    showErrorToast(msg);
    throw Exception(msg);
  }
}
