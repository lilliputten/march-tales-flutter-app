import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart' show rootBundle;

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<dynamic> readJson(String filename) async {
  final String response = await rootBundle.loadString(filename);
  final data = await json.decode(response);
  return data;
}

final parseProjectInfoReg = RegExp(r'^(\S+) v\.((\d+\.\d+)\.\d+) / (.*)$');

class Init {
  static SharedPreferences? prefs;
  static String? serverProjectInfo;
  static String? serverVersion;
  static String? serverMajorMinorVersion;
  static String? serverAPKVersion;
  static String? serverAPKMajorMinorVersion;
  static String? serverId;
  static String? serverTimestamp;
  static String? appProjectInfo;
  static String? appVersion;
  static String? appMajorMinorVersion;
  static String? appId;
  static String? appTimestamp;
  static int? userId;
  static String? userName;
  static String? userEmail;
  static Map<String, dynamic>? authConfig;

  static Future initialize(SharedPreferences externalPrefs) async {
    prefs = externalPrefs;
    await serverSession.initialize();
    List<Future> futures = [
      _loadLocalData(),
      loadServerStatus(),
      _initTracksInfoDb(),
    ];
    final List<dynamic> waitResults = await Future.wait(futures);
    final results = {
      'prefs': prefs,
      'waitResults': waitResults,
      'authConfig': authConfig,
      'serverProjectInfo': serverProjectInfo,
      'serverId': serverId,
      'serverAPKVersion': serverAPKVersion,
      'serverAPKMajorMinorVersion': serverAPKMajorMinorVersion,
      'serverVersion': serverVersion,
      'serverMajorMinorVersion': serverMajorMinorVersion,
      'serverTimestamp': serverTimestamp,
      'appProjectInfo': appProjectInfo,
      'appId': appId,
      'appVersion': appVersion,
      'appMajorMinorVersion': appMajorMinorVersion,
      'appTimestamp': appTimestamp,
    };
    return results;
  }

  static loadServerStatus() async {
    // final String url = 'http://10.0.2.2:8000/_allauth/app/v1/config';
    final String url = '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tick/';
    // Reset user data first...
    userId = 0;
    userName = '';
    userEmail = '';
    // Raw data storage
    dynamic tickData;
    try {
      // logger.t('[Init:loadServerStatus] Started loading tick data: ${url}');
      tickData = await serverSession.get(Uri.parse(url));
    } catch (err, stacktrace) {
      final String msg = 'Can not fetch url ${url}: ${err}';
      logger.e('[Init:loadServerStatus] error ${msg}', error: err, stackTrace: stacktrace);
      showErrorToast(msg);
      // debugger();
      throw Exception(msg);
    }
    logger.t('[Init:loadServerStatus] done: tickData: ${tickData}');
    serverAPKVersion = tickData!['androidAppVersion'];
    try {
      // logger.t('[Init:loadServerStatus] done: serverProjectInfo: ${serverProjectInfo}');
      if (serverAPKVersion != null) {
        final RegExpMatch? match = RegExp(r'^(\d+\.\d+)').firstMatch(serverAPKVersion!);
        if (match == null) {
          throw Exception('Can not parse server apk version');
        }
        serverAPKMajorMinorVersion = match.group(1);
      }
    } catch (err, stacktrace) {
      final String msg = 'Can not parse received tick data: ${err}';
      logger.e('[Init:loadServerStatus] error ${msg}', error: err, stackTrace: stacktrace);
      // debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
    serverProjectInfo = tickData!['projectInfo'];
    try {
      // logger.t('[Init:loadServerStatus] done: serverProjectInfo: ${serverProjectInfo}');
      if (serverProjectInfo != null) {
        final RegExpMatch? match = parseProjectInfoReg.firstMatch(serverProjectInfo!);
        if (match == null) {
          throw Exception('Can not parse server project info');
        }
        serverId = match.group(1);
        serverVersion = match.group(2);
        serverMajorMinorVersion = match.group(3);
        serverTimestamp = match.group(4);
      }
    } catch (err, stacktrace) {
      final String msg = 'Can not parse received tick data: ${err}';
      logger.e('[Init:loadServerStatus] error ${msg}', error: err, stackTrace: stacktrace);
      // debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
    try {
      userId = tickData['user_id'] != null ? tickData['user_id'] as int : 0;
      userName = tickData['user_name'] != null ? tickData['user_name'].toString() : '';
      userEmail = tickData['user_email'] != null ? tickData['user_email'].toString() : '';
    } catch (err, stacktrace) {
      final String msg = 'Can not parse received tick data: ${err}';
      logger.e('[Init:loadServerStatus] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
    return tickData;
  }

  static _loadLocalData() async {
    try {
      final String dataString = await rootBundle.loadString('assets/project-info.json');
      final jsonData = await json.decode(dataString);
      appProjectInfo = jsonData!['projectInfo'];
      if (appProjectInfo != null) {
        final RegExpMatch? match = parseProjectInfoReg.firstMatch(appProjectInfo!);
        if (match == null) {
          throw Exception('Can not parse app project info');
        }
        appId = match.group(1);
        appVersion = match.group(2);
        appMajorMinorVersion = match.group(3);
        appTimestamp = match.group(4);
      }
      return '_loadLocalData: ok';
    } catch (err, stacktrace) {
      final String msg = 'Can not parse local data: ${err}';
      logger.e('[Init:_loadLocalData] error ${msg}', error: err, stackTrace: stacktrace);
      // debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }

  static _initTracksInfoDb() async {
    try {
      await tracksInfoDb.initializeDB();
      // logger.t('[Init:_initTracksInfoDb] Done ${tracksInfoDb.db}');
      return '_initTracksInfoDb: ok';
    } catch (err, stacktrace) {
      final String msg = 'Can not initialize a local database: ${err}';
      logger.e('[Init:_initTracksInfoDb] error ${msg}', error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }
}
