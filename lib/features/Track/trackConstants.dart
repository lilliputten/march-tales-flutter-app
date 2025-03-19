import 'package:march_tales_app/core/config/AppConfig.dart';

const int defaultTracksDownloadLimit = AppConfig.LOCAL ? 2 : 10;
const Duration playerSeekGap = Duration(seconds: 5);
