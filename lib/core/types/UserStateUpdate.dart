import 'package:event/event.dart';

enum UserStateUpdateType { login, logout }

class UserStateUpdate extends EventArgs {
  int userId;
  String userName;
  String userEmail;
  UserStateUpdateType type;
  UserStateUpdate({
    this.userId = 0,
    this.userName = '',
    this.userEmail = '',
    required this.type,
  });
}
