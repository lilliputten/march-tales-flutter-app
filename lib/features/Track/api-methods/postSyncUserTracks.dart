import 'dart:developer';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/types/UserTrack.dart';

final logger = Logger();

postSyncUserTracks({
  required Iterable<UserTrack> userTracks,
}) async {
  final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/user/tracks/sync/';
  try {
    final uri = Uri.parse(url);
    final items = userTracks.map((userTrack) => userTrack.toJson()).toList();
    final postData = {'items': items};
    debugger();
    final jsonData = await serverSession.post(uri, body: postData);
    // NOTE: Returns the list of all actual favorite user tracks. Could be used to actualize local data.
    debugger();
    return jsonData;
  } catch (err, stacktrace) {
    final String msg = 'Error synchronizing user tracks list';
    logger.e('${msg} url: ${url}', error: err, stackTrace: stacktrace);
    debugger();
    // showErrorToast(msg);
    throw Exception(msg);
  }
}
