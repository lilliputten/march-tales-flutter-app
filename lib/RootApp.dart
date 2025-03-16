import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/AppWrapper.dart';
import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/SplashScreen.dart';
import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/HomePage.dart';
import 'package:march_tales_app/core/exceptions/VersionException.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'RootApp.i18n.dart';

final formatter = YamlFormatter();
final logger = Logger();

class RootApp extends StatelessWidget {
  const RootApp({
    super.key,
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final Future initFuture = Init.initialize(prefs);

    return ChangeNotifierProvider(
      create: (context) {
        final appState = AppState(prefs: prefs);
        appState.initialize();
        // Initialize locale
        final locale = I18n.locale.languageCode;
        serverSession.updateLocale(locale);
        appState.updateLocale(locale);
        // Wait for the config & tick initialization and request for the first track record
        initFuture.then((initData) async {
          // Check for the valid app version?
          final versionsMismatched = Init.serverAPKMajorMinorVersion != Init.appMajorMinorVersion;
          if (versionsMismatched) {
            appState.setVersionsMismatched();
            logger.e('The app version (${Init.appVersion}) is outdated. Actual version is ${Init.serverAPKVersion}.');
            final errMsg = 'Your version of the app is outdated.'.i18n;
            throw VersionException(errMsg);
          }
          // logger.t('[ChangeNotifierProvider] Versions: versionsMismatched=${versionsMismatched} serverVersion=${Init.serverVersion} appVersion=${Init.appVersion}');
          appState.setUser(
              userId: Init.userId ?? 0,
              userName: Init.userName ?? '',
              userEmail: Init.userEmail ?? '',
              omitEvents: true);
          // Retrieve data
          final List<Future> futures = [
            appState.loadFavorites(),
            appState.reloadTracks(),
          ];
          await Future.wait<dynamic>(futures);
        }).catchError((err) {
          logger.e('Error: ${err}');
          appState.setGlobalError(err);
          // showErrorToast(err);
        });
        // logger.d('[ChangeNotifierProvider:create]: $initFuture');
        return appState;
      },
      child: AppWrapper(
        builder: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            final appState = context.watch<AppState>();
            if (snapshot.error != null || appState.error != null) {
              return AppErrorScreen(error: snapshot.error ?? appState.error);
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return HomePage();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
