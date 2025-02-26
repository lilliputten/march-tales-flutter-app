import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_extension.dart';

import 'RootApp.dart';
import 'core/config/AppConfig.dart';
import 'supportedLocales.dart';

// Make it depending on a LOCAL flag, put to the constants/config
const connectionTimeoutDelay = 5;

/// Try to allow fetching urls with expired certificate (https://api.quotable.io/random)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    // Try to allow fetching urls with expired certificate (eg, for `https://api.quotable.io/random`)
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    // Set request timeout
    client.connectionTimeout = const Duration(seconds: connectionTimeoutDelay);
    return client;
  }
}

/// Check enviroment variables
void checkEnvironmentVariables() {
  print("GOOGLE_API_KEY: ${AppConfig.GOOGLE_API_KEY}");
  print("GOOGLE_CSE_ID: ${AppConfig.GOOGLE_CSE_ID}");
  print("LOCAL: ${AppConfig.LOCAL}");
  print("DEBUG: ${AppConfig.DEBUG}");
  if (AppConfig.GOOGLE_API_KEY.isEmpty) {
    throw Exception('Required environment variables is undefined: GOOGLE_API_KEY');
  }
  if (AppConfig.GOOGLE_CSE_ID.isEmpty) {
    throw Exception('Required environment variables is undefined: GOOGLE_CSE_ID');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check enviroment variables
  checkEnvironmentVariables();

  // Setup http request options
  HttpOverrides.global = MyHttpOverrides();

  // Start app
  runApp(
    RootRestorationScope(
      restorationId: 'root',
      child: I18n(
        initialLocale: await I18n.loadLocale(),
        // initialLocale: 'ru'.asLocale, // DEBUG
        autoSaveLocale: true,
        supportedLocales: supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: RootApp(),
      ),
    ),
  );
}
