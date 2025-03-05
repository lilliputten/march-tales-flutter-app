import 'dart:developer';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/showErrorToast.dart';

final logger = Logger();

final loginSuccessReg = RegExp(r'^/login-success/([A-z0-9_-]+)/');

class LoginBrowser extends InAppBrowser {
  LoginBrowser({
    this.onFinished,
  });

  Function? onFinished;

  CookieManager cookieManager = CookieManager.instance();

  setOnFinishedHandler(Function onFinished) {
    this.onFinished = onFinished;
  }

  @override
  Future onLoadStart(url) async {
    // logger.t('[onLoadStart] ${url}');
    if (url == null) {
      return;
    }
    final rawValue = url.rawValue;
    final doClose = rawValue == 'app://close';
    if (doClose) {
      this.close();
    }
    final path = url.path;
    if (path.isEmpty) {
      return;
    }
    final found = loginSuccessReg.firstMatch(path);
    final session = found?.group(1) ?? '';
    final isSuccess = session.isNotEmpty;
    // logger.t('[onLoadStart] Started ${url} session: ${session} path: ${path}');
    if (isSuccess) {
      if (this.onFinished != null) {
        this.onFinished!(session);
      }
      this.close();
    }
  }

  @override
  void onLoadError(url, code, message) {
    final rawValue = '${url}';
    final doClose = rawValue == 'app://close';
    if (!doClose) {
      final msg = 'Can not load ${url}. Error (${code}): ${message}';
      logger.e('[Init:_loadTick] error ${msg}');
      debugger();
      showErrorToast(msg);
    }
  }

  /* Unused overriden methods
   * @override
   * Future onBrowserCreated() async {
   *   logger.t('Browser Created!');
   * }
   * @override
   * Future onLoadStop(url) async {
   *   logger.t('Stopped ${url}');
   * }
   * @override
   * void onProgressChanged(progress) {
   *   logger.t('Progress: ${progress}');
   * }
   * @override
   * void onExit() {
   *   logger.t('Browser closed!');
   * }
   */
}
