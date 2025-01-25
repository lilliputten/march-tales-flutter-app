import 'dart:io';
import 'package:flutter/material.dart';

import 'core/config/AppConfig.dart';
import 'MyApp.dart';

/// Try to allow fetching urls with expired certificate (https://api.quotable.io/random)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    // Try to allow fetching urls with expired certificate (eg, for `https://api.quotable.io/random`)
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    // Set request timeout
    client.connectionTimeout = const Duration(seconds: 10);
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
    throw Exception(
        'Required environment variables is undefined: GOOGLE_API_KEY');
  }
  if (AppConfig.GOOGLE_CSE_ID.isEmpty) {
    throw Exception(
        'Required environment variables is undefined: GOOGLE_CSE_ID');
  }
}

void main() {
  // Check enviroment variables
  checkEnvironmentVariables();

  // Setup http request options
  HttpOverrides.global = MyHttpOverrides();

  // Start app
  runApp(MyApp());
}
