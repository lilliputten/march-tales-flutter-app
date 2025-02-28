import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

mixin UserState {
  void notifyListeners();
  SharedPreferences? getPrefs(); // From `PrefsState`

  /// Language

  int userId = 0;
  String userName = '';
  String userEmail = '';
  // String userSessionId = '';
  // String userCSRFToken = '';

  bool loadLocaleStateSavedPrefs({bool notify = true}) {
    bool hasUpdates = false;
    final savedUserId = this.getPrefs()?.getInt('userId');
    if (savedUserId != null && savedUserId != this.userId) {
      this.updateUserId(savedUserId, notify: false);
      hasUpdates = true;
    }
    final savedUserName = this.getPrefs()?.getString('userName');
    if (savedUserName != null && savedUserName != this.userName) {
      this.updateUserName(savedUserName, notify: false);
      hasUpdates = true;
    }
    final savedUserEmail = this.getPrefs()?.getString('userEmail');
    if (savedUserEmail != null && savedUserEmail != this.userEmail) {
      this.updateUserEmail(savedUserEmail, notify: false);
      hasUpdates = true;
    }
    if (hasUpdates && notify) {
      this.notifyListeners();
    }
    return hasUpdates;
  }

  getUserId() {
    return this.userId;
  }

  updateUserId(int value, {bool notify = true}) {
    if (this.userId != value) {
      this.userId = value;
      this.getPrefs()?.setString('userId', value.toString());
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  getUserName() {
    return this.userName;
  }

  updateUserName(String value, {bool notify = true}) {
    if (this.userName != value) {
      this.userName = value;
      this.getPrefs()?.setString('userName', value);
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  getUserEmail() {
    return this.userEmail;
  }

  updateUserEmail(String value, {bool notify = true}) {
    if (this.userEmail != value) {
      this.userEmail = value;
      this.getPrefs()?.setString('userEmail', value);
      if (notify) {
        this.notifyListeners();
      }
    }
  }

  updateUserData({int userId = 0, String userName = '', String userEmail = '', notify = true}) {
    bool hasUpdates = false;
    if (userId != this.userId) {
      this.updateUserId(userId, notify: false);
      hasUpdates = true;
    }
    final userName = this.getPrefs()?.getString('userName');
    if (userName != this.userName) {
      this.updateUserName(userName ?? '', notify: false);
      hasUpdates = true;
    }
    final userEmail = this.getPrefs()?.getString('userEmail');
    if (userEmail != this.userEmail) {
      this.updateUserEmail(userEmail ?? '', notify: false);
      hasUpdates = true;
    }
    if (hasUpdates && notify) {
      this.notifyListeners();
    }
  }

  isAuthorized() {
    return this.userId != 0 && this.userEmail.isNotEmpty;
  }
}
