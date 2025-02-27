import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/AppWrapper.dart';
import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/SplashScreen.dart';
import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/HomePage.dart';
import 'core/helpers/YamlFormatter.dart';
import 'core/server/ServerSession.dart';
import 'shared/states/AppState.dart';

final formatter = YamlFormatter();
final logger = Logger();

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future initFuture = Init.initialize();

    return ChangeNotifierProvider(
      create: (context) {
        final appState = AppState();
        // Initialize locale
        final locale = I18n.locale.languageCode;
        serverSession.updateLocale(locale);
        appState.updateLocale(locale);
        // Wait for the config & tick initialization and request for the first track record
        initFuture.then((initData) async {
          // TODO: Check for valid app version?
          appState.setPrefs(Init.prefs);
          appState.updateUserId(Init.userId ?? 0);
          appState.updateUserName(Init.userName ?? '');
          appState.updateUserEmail(Init.userEmail ?? '');
          // Retrieve tracks
          await Future.wait<dynamic>([
            appState.loadFavorites(),
            appState.reloadTracks(),
          ]);
        }).catchError((err) {
          logger.e('Error: ${err}');
          // appState.setGlobalError(err);
          debugger();
        });
        // logger.d('[ChangeNotifierProvider:create]: $initFuture');
        return appState;
      },
      child: AppWrapper(
          builder: FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return HomePage();
          } else {
            return SplashScreen();
          }
        },
      )),
    );
  }
}
