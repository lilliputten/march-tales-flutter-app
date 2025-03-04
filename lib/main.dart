import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'package:march_tales_app/features/Track/trackConstants.dart';
import 'RootApp.dart';
import 'core/config/AppConfig.dart';
import 'supportedLocales.dart';

// import 'package:awesome_notifications/awesome_notifications.dart';

// import 'package:flutter/foundation.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  // print('GOOGLE_CLIENT_ID: ${AppConfig.GOOGLE_CLIENT_ID}');
  // print('GOOGLE_CLIENT_SECRET: ${AppConfig.GOOGLE_CLIENT_SECRET}');
  print('LOCAL: ${AppConfig.LOCAL}');
  print('DEBUG: ${AppConfig.DEBUG}');
  if (AppConfig.GOOGLE_CLIENT_ID.isEmpty) {
    throw Exception('Required environment variables is undefined: GOOGLE_CLIENT_ID');
  }
  if (AppConfig.GOOGLE_CLIENT_ID.isEmpty) {
    throw Exception('Required environment variables is undefined: GOOGLE_CLIENT_SECRET');
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

const String name = 'Awesome Notifications - Example App';
const Color mainColor = Colors.deepPurple;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check enviroment variables
  checkEnvironmentVariables();

  // Setup http request options
  HttpOverrides.global = MyHttpOverrides();

  /* // UNUSED: awesome_notifications test
   * AwesomeNotifications().initialize(
   *   // set the icon to null if you want to use the default app icon
   *   'resource://drawable/ic_notification',
   *   [
   *     NotificationChannel(
   *         channelGroupKey: 'basic_channel_group',
   *         channelKey: 'basic_channel',
   *         channelName: 'Basic notifications',
   *         channelDescription: 'Notification channel for basic tests',
   *         defaultColor: Color(0xFF9D50DD),
   *         ledColor: Colors.white)
   *   ],
   *   // Channel groups are only visual and are not required
   *   channelGroups: [
   *     NotificationChannelGroup(
   *         channelGroupKey: 'basic_channel_group',
   *         channelGroupName: 'Basic group')
   *   ],
   *   debug: true
   * );
   * AwesomeNotifications().setListeners(
   *   onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
   *   onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
   *   onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
   *   onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
   * );
   */

  /* UNUSED: flutter_local_notifications test
   * final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
   * final android = AndroidInitializationSettings('@mipmap/ic_launcher');
   * // final ios = IOSInitializationSettings();
   * final settings = InitializationSettings(
   *   android: android,
   *   // iOS: ios,
   *   );
   * await flutterLocalNotificationsPlugin.initialize(
   *   settings,
   *   // onSelectNotification: (payload) async {},
   * );
   */

  await JustAudioBackground.init(
    androidNotificationChannelId: 'team.march.march-tales-app.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: true,
    // B/W Icon
    // androidNotificationIcon: 'drawable/ic_notification',
    androidNotificationIcon: 'drawable/ic_stat_headset',
    // androidNotificationIcon: 'mipmap/ic_launcher',
    // androidNotificationIcon: 'mipmap/ic_launcher_round',
    // androidNotificationIcon: 'mipmap/ic_launcher_round_png',
    fastForwardInterval: playerSeekGap,
    rewindInterval: playerSeekGap,
  );
  // Start app
  runApp(
    RootRestorationScope(
      restorationId: 'root',
      child: I18n(
        initialLocale: await I18n.loadLocale(),
        autoSaveLocale: true,
        supportedLocales: supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: RootApp(
            // flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
            ),
      ),
    ),
  );
}
