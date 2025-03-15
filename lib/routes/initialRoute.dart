import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/defaultAppRoute.dart';
import 'package:march_tales_app/screens/TagScreen.dart';

// import 'package:march_tales_app/screens/RubricScreen.dart';
// import 'package:march_tales_app/screens/AuthorScreen.dart';
// import 'package:march_tales_app/screens/TrackDetailsScreen.dart';
// import 'package:march_tales_app/screens/AuthorScreen.dart';
// import 'package:march_tales_app/screens/TagsListScreen.dart';
// import 'package:march_tales_app/screens/RubricsListScreen.dart';

const _useDebugRoute = false;

// const _debugRoute = TrackDetailsScreen.routeName;
// const _debugRoute = AuthorScreen.routeName;
// const _debugRoute = RubricScreen.routeName;
const _debugRoute = TagScreen.routeName;
// const _debugRoute = AuthorScreen.routeName;
// const _debugRoute = AuthorsListScreen.routeName;
// const _debugRoute = RubricsListScreen.routeName;
// const _debugRoute = TagsListScreen.routeName;
// const _debugRoute = TagsListScreen.routeName;

const initialRoute = _useDebugRoute && AppConfig.LOCAL ? _debugRoute : defaultAppRoute;
