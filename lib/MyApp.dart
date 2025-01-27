import 'package:i18n_extension/i18n_extension.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/pages/MyHomePage.dart';

import 'pages/MyHomePage.i18n.dart';
import 'Init.dart';
import 'SplashScreen.dart';

final formatter = YamlFormatter();
final logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future initFuture = Init.initialize();

    return ChangeNotifierProvider(
      create: (context) {
        var appState = MyAppState();
        // Initialize locale
        final locale = I18n.locale.languageCode;
        serverSession.updateLocale(locale);
        appState.updateLocale(locale);
        // Wait for the config & tick initialization and request for the first track record
        initFuture.then((initData) {
          // Get project info from init data and set to the context
          final projectInfo = initData['projectInfo'];
          // logger.d('[ChangeNotifierProvider:create:initFuture.then]: $projectInfo, $initData');
          appState.setProjectInfo(projectInfo);
          // Retrieve tracks
          appState.reloadTracks();
        });
        // logger.d('[ChangeNotifierProvider:create]: $initFuture');
        return appState;
      },
      child: MaterialApp(
        restorationScopeId: 'app',
        title: 'The March Cat Tales',
        debugShowCheckedModeBanner: false,
        locale: I18n.locale,
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,

        // onGenerateTitle: (context) => I18n.of(context)!.appTitle,
        onGenerateTitle: (context) => appTitle.i18n,
        // home: MyHomePage(),
        home: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // logger.d('snapshot.data: ${formatter.format(snapshot.data)}');
              return MyHomePage();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
