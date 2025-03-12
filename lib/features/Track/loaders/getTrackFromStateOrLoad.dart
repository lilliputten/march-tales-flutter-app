import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<Track> getTrackFromStateOrLoad(int id, {required AppState appState}) async {
  final tracks = appState.tracks;
  try {
    return tracks.firstWhere((it) => it.id == id);
  } catch (err) {
    // Ok, going to load it from the server, see below...
  }
  return loadTrackDetails(id);
}
