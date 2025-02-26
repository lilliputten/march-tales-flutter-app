import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/showErrorToast.dart';

final logger = Logger();

class LoginBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    logger.t('Browser Created!');
    // debugger();
  }

  @override
  Future onLoadStart(url) async {
    logger.t('Started ${url}');
    // debugger();
  }

  @override
  Future onLoadStop(url) async {
    logger.t('Stopped ${url}');
    // debugger();
  }

  @override
  void onLoadError(url, code, message) {
    final msg = 'Can not load ${url}. Error (${code}): ${message}';
    logger.e('[Init:_loadTick] error ${msg}');
    showErrorToast(msg);
    // debugger();
  }

  @override
  void onProgressChanged(progress) {
    logger.t('Progress: ${progress}');
    // debugger();
  }

  @override
  void onExit() {
    logger.t('Browser closed!');
    // debugger();
  }
}
