import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/screens/AuthorsListScreen.dart';

// import 'package:march_tales_app/screens/TagScreen.dart';
// import 'package:march_tales_app/screens/RubricScreen.dart';
// import 'package:march_tales_app/screens/AuthorScreen.dart';
// import 'package:march_tales_app/screens/RubricScreen.dart';
// import 'package:march_tales_app/screens/RubricsListScreen.dart';
// import 'package:march_tales_app/screens/TagsListScreen.dart';
// import 'package:march_tales_app/screens/TrackDetailsScreen.dart';

const _useDebugRoute = false;

// const _debugRoute = AuthorScreen.routeName;
const _debugRoute = AuthorsListScreen.routeName;
// const _debugRoute = RubricScreen.routeName;
// const _debugRoute = RubricsListScreen.routeName;
// const _debugRoute = TagScreen.routeName;
// const _debugRoute = TagsListScreen.routeName;
// const _debugRoute = TrackDetailsScreen.routeName;

const initialRoute = _useDebugRoute && AppConfig.DEBUG ? _debugRoute : defaultAppRoute;
