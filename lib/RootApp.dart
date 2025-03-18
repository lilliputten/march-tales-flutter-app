import 'package:flutter/material.dart';

import 'package:i18n_extension/i18n_extension.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/AppWrapper.dart';
import 'package:march_tales_app/Init.dart';
import 'package:march_tales_app/SplashScreen.dart';
import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/HomePage.dart';
import 'package:march_tales_app/core/exceptions/VersionException.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'RootApp.i18n.dart';

final formatter = YamlFormatter();
final logger = Logger();

class RootApp extends StatefulWidget {
  const RootApp({
    super.key,
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  State<RootApp> createState() => RootAppState();
}

class RootAppState extends State<RootApp> {
  late Future _initFuture;
  late AppState _appState;
  bool _initializing = true;
  dynamic _error;

  @override
  void initState() {
    super.initState();
    this._createAppState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._initFuture = this._initializeInit();
  }

  _createAppState() {
    try {
      this._appState = AppState(prefs: this.widget.prefs);
      // Initialize locale
      final locale = I18n.locale.languageCode;
      serverSession.updateLocale(locale);
      this._appState.updateLocale(locale);
    } catch (err, stacktrace) {
      logger.e('Can not create app state: $err', error: err, stackTrace: stacktrace);
      // debugger();
      this._error = err;
    }
  }

  _initializeInit() async {
    try {
      return Init.initialize(this.widget.prefs);
    } catch (err, stacktrace) {
      logger.e('App initialization error: $err', error: err, stackTrace: stacktrace);
      // debugger();
      setState(() {
        this._error = err;
      });
    }
  }

  _finalizeInitialization(dynamic initData) async {
    try {
      // Check for the valid app version?
      final versionsMismatched = Init.serverAPKMajorMinorVersion != Init.appMajorMinorVersion;
      if (versionsMismatched) {
        this._appState.setVersionsMismatched();
        logger.e('The app version (${Init.appVersion}) is outdated. Actual version is ${Init.serverAPKVersion}.');
        final errMsg = 'Your version of the app is outdated.'.i18n;
        throw VersionException(errMsg);
      }
      // logger.t('[_finalizeInitialization] Versions: versionsMismatched=${versionsMismatched} serverVersion=${Init.serverVersion} appVersion=${Init.appVersion}');
      this._appState.setUser(
          userId: Init.userId ?? 0, userName: Init.userName ?? '', userEmail: Init.userEmail ?? '', omitEvents: true);
      // Retrieve data
      final List<Future> futures = [
        this._appState.loadFavorites(),
        this._appState.reloadTracks(),
      ];
      await Future.wait<dynamic>(futures);
      setState(() {
        this._initializing = false;
      });
    } catch (err, stacktrace) {
      logger.e('Can not finalize initialization: $err', error: err, stackTrace: stacktrace);
      // debugger();
      setState(() {
        this._error = err;
      });
    }
  }

  _initAppState() {
    try {
      this._appState.initialize();
      // Wait for the config & tick initialization and request for the first track record
      this._initFuture.then(this._finalizeInitialization);
    } catch (err, stacktrace) {
      logger.e('Can not create app state: $err', error: err, stackTrace: stacktrace);
      // debugger();
      setState(() {
        this._error = err;
      });
    }
  }

  _reInit() {
    setState(() {
      this._initializing = true;
      this._error = null;
      this._initFuture = this._initializeInit();
    });
    this._initAppState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        this._initAppState();
        return this._appState;
      },
      child: AppWrapper(
        builder: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.error != null || this._error != null) {
              return AppErrorScreen(
                error: this._error ?? snapshot.error,
                onRetry: this._reInit,
              );
            }
            if (!this._initializing && snapshot.connectionState == ConnectionState.done) {
              return HomePage();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
