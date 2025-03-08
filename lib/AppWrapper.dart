import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'package:march_tales_app/sharedTranslationsData.i18n.dart';

final formatter = YamlFormatter();
final logger = Logger();

final themeExtensions = <ThemeExtension<dynamic>>[
  appColors,
];

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    super.key,
    required this.builder,
  });

  final FutureBuilder builder;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return MaterialApp(
      restorationScopeId: 'app',
      // title: 'The March Cat Tales'.i18n,
      onGenerateTitle: (context) => appTitle.i18n,
      debugShowCheckedModeBanner: false,
      locale: I18n.locale,
      localizationsDelegates: I18n.localizationsDelegates,
      supportedLocales: I18n.supportedLocales,
      themeMode: appState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColors.brandColor,
          brightness: Brightness.dark,
        ),
        extensions: themeExtensions,
      ),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppConfig.PRIMARY_COLOR),
          brightness: Brightness.light,
        ),
        extensions: themeExtensions,
      ),
      home: builder,
      // routes: {
      //   TrackDetailsScreen.routeName: (context) => const TrackDetailsScreen(),
      // },
    );
  }
}
