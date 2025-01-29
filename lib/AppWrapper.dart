import 'package:i18n_extension/i18n_extension.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'app/AppColors.dart';
import 'core/config/AppConfig.dart';
import 'core/helpers/YamlFormatter.dart';
import 'shared/states/MyAppState.dart';

import 'sharedTranslationsData.i18n.dart';

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
    final appState = context.watch<MyAppState>();
    return MaterialApp(
      restorationScopeId: 'app',
      // title: 'The March Cat Tales',
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
    );
  }
}
