import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/screens/RubricsListScreen.dart';

const _useDebugRoute = true;

// const _debugRoute = TrackDetailsScreen.routeName;
// const _debugRoute = AuthorScreen.routeName;
// const _debugRoute = RubricScreen.routeName;
// const _debugRoute = AuthorsListScreen.routeName;
const _debugRoute = RubricsListScreen.routeName;

const initialRoute = _useDebugRoute && AppConfig.LOCAL ? _debugRoute : defaultAppRoute;
