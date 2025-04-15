import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/routes.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/updaters/updateLocalTrack.dart';

final logger = Logger();

Future<Track> loadTrackDetails(int id) async {
  final String url =
      '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tracks/${id}/?full=${tracksFullDataParam}';
  try {
    // throw new ConnectionException('Test error');
    final uri = Uri.parse(url);
    final jsonData = await serverSession.get(uri);
    final track = Track.fromJson(jsonData);
    await updateLocalTrack(track);
    return track;
  } catch (err, stacktrace) {
    final String msg = 'Error fetching track details with an url $url: $err';
    logger.e('${msg} url $url: $err', error: err, stackTrace: stacktrace);
    // debugger();
    throw ConnectionException(msg);
  }
}
