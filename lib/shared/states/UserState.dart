import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/core/singletons/userStateEvents.dart';
import 'package:march_tales_app/core/types/UserStateUpdate.dart';

final logger = Logger();

mixin UserState {
  void notifyListeners();
  SharedPreferences? getPrefs(); // From `PrefsState`

  // UserState

  int _userId = 0;
  String _userName = '';
  String _userEmail = '';

  bool loadLocaleStateSavedPrefs({bool notify = true}) {
    bool hasUpdates = false;
    final savedUserId = this.getPrefs()?.getInt('userId');
    if (savedUserId != null && savedUserId != this._userId) {
      this._updateUserId(savedUserId, notify: false);
      hasUpdates = true;
    }
    final savedUserName = this.getPrefs()?.getString('userName');
    if (savedUserName != null && savedUserName != this._userName) {
      this._updateUserName(savedUserName, notify: false);
      hasUpdates = true;
    }
    final savedUserEmail = this.getPrefs()?.getString('userEmail');
    if (savedUserEmail != null && savedUserEmail != this._userEmail) {
      this._updateUserEmail(savedUserEmail, notify: false);
      hasUpdates = true;
    }
    if (hasUpdates && notify) {
      this.notifyListeners();
    }
    return hasUpdates;
  }

  int getUserId() {
    return this._userId;
  }

  _updateUserId(int value, {bool notify = true}) {
    if (this._userId != value) {
      this._userId = value;
      this.getPrefs()?.setString('userId', value.toString());
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  String getUserName() {
    return this._userName;
  }

  _updateUserName(String value, {bool notify = true}) {
    if (this._userName != value) {
      this._userName = value;
      this.getPrefs()?.setString('userName', value);
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  String getUserEmail() {
    return this._userEmail;
  }

  _updateUserEmail(String value, {bool notify = true}) {
    if (this._userEmail != value) {
      this._userEmail = value;
      this.getPrefs()?.setString('userEmail', value);
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  setUser({int userId = 0, String userName = '', String userEmail = '', notify = true, omitEvents = false}) {
    bool hasUpdates = false;
    if (userId != this._userId) {
      final update = userId == 0
          ? UserStateUpdate(
              type: UserStateUpdateType.logout,
              userId: this._userId,
              userName: this._userName,
              userEmail: this._userEmail,
            )
          : UserStateUpdate(
              type: UserStateUpdateType.login,
              userId: userId,
              userName: userName,
              userEmail: userEmail,
            );
      this._updateUserId(userId, notify: false);
      hasUpdates = true;
      // Update other data
      if (userName != this._userName) {
        this._updateUserName(userName, notify: false);
      }
      if (userEmail != this._userEmail) {
        this._updateUserEmail(userEmail, notify: false);
      }
      // Notify about login/logout after data has been already changed
      if (!omitEvents) {
        userStateEvents.broadcast(update);
      }
    }
    if (hasUpdates && notify) {
      this.notifyListeners();
    }
  }

  bool isAuthorized() {
    return this._userId != 0 && this._userEmail.isNotEmpty;
  }
}
