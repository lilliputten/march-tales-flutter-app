import 'dart:io';
import 'package:flutter/material.dart';

import 'core/config/AppConfig.dart';
import 'MyApp.dart';

/// Try to allow fetching urls with expired certificate (https://api.quotable.io/random)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
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

  // Try to allow fetching urls with expired certificate (https://api.quotable.io/random)
  HttpOverrides.global = MyHttpOverrides();

  // Start app
  runApp(MyApp());
}
