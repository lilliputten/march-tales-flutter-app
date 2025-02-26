import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:logger/logger.dart';

import 'package:march_tales_app/components/LoginBrowser.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';

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

  @override
  void initState() {
    super.initState();
    /* // DEMO: Adding custom browser menu items
     * browser.addMenuItem(InAppBrowserMenuItem(
     *   id: 0,
     *   title: 'Reload',
     *   iconColor: Colors.black,
     *   order: 0,
     *   onClick: () {
     *     debugger();
     *     browser.webViewController?.reload();
     *   },
     * ));
     */

    /* // DEBUG
     * final debugItems = {
     *   'locale': this.locale,
     * };
     * logger.d('initState: ${formatter.format(debugItems)}');
     * debugger();
     */

    cookieManager.setCookie(url: webUrl, name: 'mobile_auth', value: 'true');
    cookieManager.setCookie(
        url: webUrl, name: 'django_language', value: serverSession.getLocale());
    cookieManager.setCookie(url: webUrl, name: 'csrftoken', value: serverSession.getCSRFToken());
    // sessionid?
  }

  @override
  Widget build(BuildContext context) {
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
