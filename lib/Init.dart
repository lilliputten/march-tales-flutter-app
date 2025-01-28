import 'dart:developer';

import 'package:logger/logger.dart';
import 'dart:convert';
// import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';

final formatter = YamlFormatter();
final logger = Logger();

Future<dynamic> readJson(String filename) async {
  final String response = await rootBundle.loadString(filename);
  final data = await json.decode(response);
  return data;
}

final parseProjectInfoReg = RegExp(r'^(\S+) v\.(\S+) / (.*)$');

class Init {
  static String? serverProjectInfo;
  static String? serverVersion;
  static String? serverId;
  static String? serverTimestamp;
  static String? appProjectInfo;
  static String? appVersion;
  static String? appId;
  static String? appTimestamp;
  static Map<String, dynamic>? authConfig;
  static Future initialize() async {
    List<Future> futures = [
      // _registerServices(),
      _loadLocalData(),
      _loadConfig(),
      _loadTick(),
    ];
    final List<dynamic> waitResults = await Future.wait(futures);
    // logger.t('[Init:initialize]: waitResults: $waitResults');
    final results = {
      'waitResults': waitResults,
      'authConfig': authConfig,
      'serverProjectInfo': serverProjectInfo,
      'serverId': serverId,
      'serverVersion': serverVersion,
      'serverTimestamp': serverTimestamp,
      'appProjectInfo': appProjectInfo,
      'appId': appId,
      'appVersion': appVersion,
      'appTimestamp': appTimestamp,
    };
    logger.d('results: ${formatter.format(results)}');
    return results;
  }

  static _loadTick() async {
    // final String url = 'http://10.0.2.2:8000/_allauth/app/v1/config';
    final String url =
        '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tick';
    // logger.t('[Init:_loadTick] Starting loading tick data: ${url}');
    dynamic jsonData;
    try {
      jsonData = await serverSession.get(Uri.parse(url));
    } catch (err, stacktrace) {
      final String msg = 'Can not fetch url $url: $err';
      logger.e('[Init:_loadTick] error $msg',
          error: err, stackTrace: stacktrace);
      showErrorToast(msg);
      // debugger();
      throw Exception(msg);
    }
    // logger.t('[Init:_loadTick] done: jsonData: ${jsonData}');
    serverProjectInfo = jsonData!['PROJECT_INFO'];
    try {
      // logger.t('[Init:_loadTick] done: serverProjectInfo: ${serverProjectInfo}');
      if (serverProjectInfo != null) {
        final Iterable<RegExpMatch> found =
            parseProjectInfoReg.allMatches(serverProjectInfo!);
        final matches = found.elementAt(0);
        serverId = matches.group(1);
        serverVersion = matches.group(2);
        serverTimestamp = matches.group(3);
      }
      return '_loadTick: ok';
    } catch (err, stacktrace) {
      final String msg = 'Can not parse received tick data: ${err}';
      logger.e('[Init:_loadTick] error ${msg}',
          error: err, stackTrace: stacktrace);
      // debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }

  static _loadConfig() async {
    // final String url = 'http://10.0.2.2:8000/_allauth/app/v1/config';
    final String url =
        '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_AUTH_PREFIX}/config';
    // logger.t('[Init:_loadConfig] Starting loading settings: $url');
    try {
      final jsonData = await serverSession.get(Uri.parse(url));
      // logger.t('[Init:_loadConfig] done: jsonData: $jsonData');
      authConfig = jsonData!['data'];
      // logger.t('[Init:_loadConfig] done: authConfig: $authConfig');
      // logger.t('[Init:_loadConfig] finished loading settings');
      return '_loadConfig: ok';
    } catch (err, stacktrace) {
      final String msg = 'Can not fetch url $url: $err';
      logger.e('[Init:_loadConfig] error $msg',
          error: err, stackTrace: stacktrace);
      debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }

  static _loadLocalData() async {
    try {
      final String dataString =
          await rootBundle.loadString('assets/project-info.json');
      final jsonData = await json.decode(dataString);
      appProjectInfo = jsonData!['projectInfo'];
      if (appProjectInfo != null) {
        final Iterable<RegExpMatch> found =
            parseProjectInfoReg.allMatches(appProjectInfo!);
        final matches = found.elementAt(0);
        appId = matches.group(1);
        appVersion = matches.group(2);
        appTimestamp = matches.group(3);
      }
      return '_loadLocalData: ok';
    } catch (err, stacktrace) {
      final String msg = 'Can not parse local data: ${err}';
      logger.e('[Init:_loadTick] error ${msg}',
          error: err, stackTrace: stacktrace);
      // debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }

  // static _registerServices() async {
  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'content-type': 'application/json; charset=utf-8',
  //     },
  //     // body: json.encode(data),
  //   );
  //   logger.t("starting registering services");
  //   await Future.delayed(Duration(seconds: 1));
  //   logger.t("finished registering services");
  //   return '_registerServices: ok';
  // }
}
