import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/app/AppColors.dart';
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
    // final List<Cookie> cookies = await cookieManager.getCookies(url: webUrl);
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
      Future.delayed(Duration.zero, () {
        if (context.mounted) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.green,
            content: Text("You've been succcessfully logged in".i18n),
          ));
        }
      });
    } catch (err, stacktrace) {
      final String msg = 'Can not parse user data: ${err}';
      logger.e('[LoginButton:onFinished] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
    } finally {
      this._appState?.setUser(userId: Init.userId ?? 0, userName: Init.userName ?? '', userEmail: Init.userEmail ?? '');
      // logger.t('[onFinished] isSuccess cookies=${cookies} userId=${Init.userId} userEmail=${Init.userEmail} userName=${Init.userName}');
    }
  }

  @override
  void initState() {
    super.initState();

    this.browser.setOnFinishedHandler(this.onFinished);

    this._appState = context.read<AppState>();

    final locale = serverSession.getLocale();
    final csrfToken = serverSession.getCSRFToken();
    final sessionId = serverSession.getSessionId();

    try {
      cookieManager.setCookie(url: webUrl, name: 'mobile_auth', value: 'true');
      if (locale.isNotEmpty) {
        cookieManager.setCookie(url: webUrl, name: 'django_language', value: locale);
      }
      if (csrfToken.isNotEmpty) {
        cookieManager.setCookie(url: webUrl, name: 'csrftoken', value: csrfToken);
      }
      if (sessionId.isNotEmpty) {
        cookieManager.setCookie(url: webUrl, name: 'sessionid', value: sessionId);
      }
    } catch (err, stacktrace) {
      final String msg = 'Can not initialize in-app browser ${err}';
      logger.e('[LoginButton:initState] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!.copyWith(color: appColors.onBrandColor);
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      textStyle: style,
      backgroundColor: appColors.brandColor,
    );

    return SizedBox(
      width: double.infinity,
      // height: double.infinity,
      child: FilledButton.icon(
        style: buttonStyle,
        onPressed: () {
          browser.openUrlRequest(
            urlRequest: URLRequest(url: this.webUrl),
            settings: this.browserSettings,
          );
        },
        icon: Icon(Icons.login, color: appColors.onBrandColor),
        label: Text('Log in'.i18n, style: style),
      ),
    );
  }
}
