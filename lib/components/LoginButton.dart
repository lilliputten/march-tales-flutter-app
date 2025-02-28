import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/components/LoginBrowser.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'LoginButton.i18n.dart';

final logger = Logger();
final formatter = YamlFormatter();

class LoginButton extends StatefulWidget {
  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  // @see https://inappwebview.dev/docs/in-app-browsers/in-app-browser
  final LoginBrowser browser = new LoginBrowser();

  BuildContext? _context;
  AppState? _appState;

  CookieManager cookieManager = CookieManager.instance();

  final webUrl = WebUri('${AppConfig.TALES_SERVER_HOST}/accounts/login/');

  final browserSettings = InAppBrowserClassSettings(
    browserSettings: InAppBrowserSettings(
      hideUrlBar: true,
    ),
    webViewSettings: InAppWebViewSettings(
      javaScriptEnabled: true,
      isInspectable: kDebugMode,
      userAgent: 'random',
      useOnLoadResource: true,
      cacheEnabled: true,
    ),
  );

  onFinished(String session) async {
    serverSession.updateSessionId(session);
    final List<Cookie> cookies = await cookieManager.getCookies(url: webUrl);
    final csrftoken = await cookieManager.getCookie(url: webUrl, name: 'csrftoken');
    final sessionId = await cookieManager.getCookie(url: webUrl, name: 'sessionid');
    if (csrftoken?.value.isNotEmpty) {
      serverSession.updateCSRFToken(csrftoken?.value);
    }
    if (sessionId?.value.isNotEmpty) {
      serverSession.updateSessionId(sessionId?.value);
    }
    // Get account data...
    try {
      await Init.loadServerStatus();
      if (this._context != null && this._context!.mounted) {
        ScaffoldMessenger.of(this._context!).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.green,
          content: Text("You've been succcessfully logged in".i18n),
        ));
      }
    } catch (err, stacktrace) {
      final String msg = 'Can not parse user data: ${err}';
      logger.e('[LoginButton:onFinished] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
    } finally {
      this._appState?.setUser(userId: Init.userId ?? 0, userName: Init.userName ?? '', userEmail: Init.userEmail ?? '');
      logger.t(
          '[onFinished] isSuccess cookies=${cookies} userId=${Init.userId} userEmail=${Init.userEmail} userName=${Init.userName}');
    }
  }

  @override
  void initState() {
    super.initState();

    this.browser.setOnFinishedHandler(this.onFinished);

    cookieManager.setCookie(url: webUrl, name: 'mobile_auth', value: 'true');
    cookieManager.setCookie(url: webUrl, name: 'django_language', value: serverSession.getLocale());
    cookieManager.setCookie(url: webUrl, name: 'csrftoken', value: serverSession.getCSRFToken());
    cookieManager.setCookie(url: webUrl, name: 'sessionid', value: serverSession.getSessionId());
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;
    final AppState appState = context.watch<AppState>();
    this._appState = appState;
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall!;
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(textStyle: style);

    return SizedBox(
      width: double.infinity,
      // height: double.infinity,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () {
          browser.openUrlRequest(
            urlRequest: URLRequest(url: this.webUrl),
            settings: this.browserSettings,
          );
        },
        child: Text('Log in'.i18n),
      ),
    );
  }
}
