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
    // final savedUserSessionId = this.getPrefs()?.getString('userSessionId');
    // if (savedUserSessionId != null && savedUserSessionId != this.userSessionId) {
    //   this.updateUserSessionId(savedUserSessionId, notify: false);
    //   hasUpdates = true;
    // }
    // final savedUserCSRFToken = this.getPrefs()?.getString('userCSRFToken');
    // if (savedUserCSRFToken != null && savedUserCSRFToken != this.userCSRFToken) {
    //   this.updateUserCSRFToken(savedUserCSRFToken, notify: false);
    //   hasUpdates = true;
    // }
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

  // getUserSessionId() {
  //   return this.userSessionId;
  // }
  // updateUserSessionId(String value, {bool notify = true}) {
  //   if (this.userSessionId != value) {
  //     this.userSessionId = value;
  //     this.getPrefs()?.setString('userSessionId', value);
  //     if (notify) {
  //       this.notifyListeners();
  //     }
  //   }
  // }
  //
  // getUserCSRFToken() {
  //   return this.userCSRFToken;
  // }
  // updateUserCSRFToken(String value, {bool notify = true}) {
  //   if (this.userCSRFToken != value) {
  //     this.userCSRFToken = value;
  //     this.getPrefs()?.setString('userCSRFToken', value);
  //     if (notify) {
  //       this.notifyListeners();
  //     }
  //   }
  // }
}
