import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/components/LoginBrowser.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

// import 'LoginButton.i18n.dart';

final logger = Logger();
final formatter = YamlFormatter();

class LoginButton extends StatefulWidget {
  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  // @see https://inappwebview.dev/docs/in-app-browsers/in-app-browser
  final LoginBrowser browser = new LoginBrowser();

  AppState? appState;

  CookieManager cookieManager = CookieManager.instance();

  final webUrl = WebUri('${AppConfig.TALES_SERVER_HOST}/accounts/login/');

  final settings = InAppBrowserClassSettings(
    browserSettings: InAppBrowserSettings(
      hideUrlBar: true,
    ),
    webViewSettings: InAppWebViewSettings(
      javaScriptEnabled: false,
      isInspectable: kDebugMode,
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
      final String tickUrl = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tick';
      final tickData = await serverSession.get(Uri.parse(tickUrl));
      final userId = tickData['user_id'] != null ? tickData['user_id'] as int : 0;
      final userName = tickData['user_name'] != null ? tickData['user_name'].toString() : '';
      final userEmail = tickData['user_email'] != null ? tickData['user_email'].toString() : '';
      this.appState?.updateUserId(userId);
      this.appState?.updateUserName(userName);
      this.appState?.updateUserEmail(userEmail);
      logger.t(
          '[onFinished] isSuccess ${tickData} cookies=${cookies} userId=${userId} userEmail=${userEmail} userName=${userName}');
      debugger();
    } catch (err, stacktrace) {
      final String msg = 'Can not parse user data: ${err}';
      logger.e('[LoginButton:onFinished] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
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
    final AppState appState = context.watch<AppState>();
    this.appState = appState;
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
            settings: this.settings,
          );
        },
        child: const Text('Log in'),
      ),
    );
  }
}
