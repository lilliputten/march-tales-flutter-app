import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';

Future clearLocalTracks() async {
  await tracksInfoDb.clearAll();
}
