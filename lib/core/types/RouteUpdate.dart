import 'package:event/event.dart';

enum RouteUpdateType {
  change,
  rootVisible,
  rootHidden,
}

class RouteUpdate extends EventArgs {
  RouteUpdateType type;
  String name;

  RouteUpdate({
    required this.type,
    required this.name,
  });

  @override
  String toString() {
    return 'RouteUpdate(type=${type}; name=${name})';
  }
}
