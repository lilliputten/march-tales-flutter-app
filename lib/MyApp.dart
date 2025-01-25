// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:i18n_extension/i18n_extension.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/pages/MyHomePage.dart';

import 'sharedTranslations.i18n.dart';
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
        initFuture.then((initData) {
          // Get project info from init data and set to the context
          final projectInfo = initData['projectInfo'];
          logger.d(
              '[ChangeNotifierProvider:create:initFuture.then]: $projectInfo, $initData');
          appState.setProjectInfo(projectInfo);
          // TODO: Get these parameters from constants/config?
          appState.loadTracks(offset: 0, limit: 2);
        });
        // logger.d('[ChangeNotifierProvider:create]: $initFuture');
        return appState;
      },
      child: MaterialApp(
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
