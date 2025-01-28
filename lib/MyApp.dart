import 'package:i18n_extension/i18n_extension.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/MyHomePage.dart';

import 'core/config/AppConfig.dart';
import 'core/server/ServerSession.dart';
import 'core/helpers/YamlFormatter.dart';
import 'shared/states/MyAppState.dart';

import 'Init.dart';
import 'SplashScreen.dart';

import 'sharedTranslationsData.i18n.dart';

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
          final serverProjectInfo = initData['serverProjectInfo'];
          logger.d(
              '[ChangeNotifierProvider:create:initFuture.then]: $serverProjectInfo, $initData');
          appState.setServerProjectInfo(serverProjectInfo);
          final appProjectInfo = initData['appProjectInfo'];
          logger.d(
              '[ChangeNotifierProvider:create:initFuture.then]: $appProjectInfo, $initData');
          appState.setAppProjectInfo(appProjectInfo);
          // Retrieve tracks
          appState.reloadTracks();
        }).catchError((err) {
          logger.e('Error: ${err}');
          appState.setGlobalError(err);
          // debugger();
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
            return MyHomePage();
          } else {
            return SplashScreen();
          }
        },
      )),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    super.key,
    required this.builder,
  });

  final FutureBuilder builder;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    return MaterialApp(
      restorationScopeId: 'app',
      title: 'The March Cat Tales',
      onGenerateTitle: (context) => appTitle.i18n,
      debugShowCheckedModeBanner: false,
      locale: I18n.locale,
      localizationsDelegates: I18n.localizationsDelegates,
      supportedLocales: I18n.supportedLocales,
      themeMode: appState.themeMode, // ThemeMode.light,
      // darkTheme: ThemeData.dark(),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppConfig.PRIMARY_COLOR),
          brightness: Brightness.dark,
          // contrastLevel: 1.0,
        ),
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppConfig.PRIMARY_COLOR),
          brightness: Brightness.light, // selectedBrightness,
          // contrastLevel: 1.0,
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 115)),
      ),
      home: builder,
    );
  }
}
