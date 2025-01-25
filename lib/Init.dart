// dart format width=123

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

import 'package:logger/logger.dart';
// import 'package:yaml/yaml.dart' as yaml;
// import 'dart:html';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
// import 'package:march_tales_app/core/helpers/parseJsonResponse.dart';
import 'package:march_tales_app/core/server/ServerSession.dart';

final formatter = YamlFormatter();
final logger = Logger();

class Init {
  static String? projectInfo;
  static String? appVersion;
  static String? appId;
  static String? appTimestamp;
  static Map<String, dynamic>? authConfig;
  static Future initialize() async {
    List<Future> futures = [
      // _registerServices(),
      _loadConfig(),
      _loadTick(),
      // _loadSession(),
    ];
    final List<dynamic> waitResults = await Future.wait(futures);
    // logger.t('[Init:initialize]: waitResults: $waitResults');
    final results = {
      'waitResults': waitResults,
      'authConfig': authConfig,
      'projectInfo': projectInfo,
      'appId': appId,
      'appVersion': appVersion,
      'appTimestamp': appTimestamp,
    };
    // logger.d('results: ${formatter.format(results)}');
    return results;
  }

  static _loadTick() async {
    // final String url = 'http://10.0.2.2:8000/_allauth/app/v1/config';
    final String url =
        '${AppConfig.TALES_SERVER_HOST}${AppConfig.TALES_API_PREFIX}/tick';
    logger.t('[Init:_loadTick] Starting loading tick data: ${url}');
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
    logger.t('[Init:_loadTick] done: jsonData: ${jsonData}');
    projectInfo = jsonData!['PROJECT_INFO'];
    try {
      final reg = RegExp(r'^(\S+) v\.(\S+) / (.*)$');
      logger.t('[Init:_loadTick] done: projectInfo: ${projectInfo}');
      if (projectInfo != null) {
        final Iterable<RegExpMatch> found = reg.allMatches(projectInfo!);
        final matches = found.elementAt(0);
        appId = matches.group(1);
        appVersion = matches.group(2);
        appTimestamp = matches.group(3);
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
    logger.t('[Init:_loadConfig] Starting loading settings: $url');
    try {
      final jsonData = await serverSession.get(Uri.parse(url));
      logger.t('[Init:_loadConfig] done: jsonData: $jsonData');
      // configStatus = jsonData!['status'];
      authConfig = jsonData!['data'];
      logger.t('[Init:_loadConfig] done: authConfig: $authConfig');
      logger.t('[Init:_loadConfig] finished loading settings');
      return '_loadConfig: ok';
    } catch (err, stacktrace) {
      final String msg = 'Can not fetch url $url: $err';
      logger.e('[Init:_loadConfig] error $msg',
          error: err, stackTrace: stacktrace);
      // debugger();
      showErrorToast(msg);
      throw Exception(msg);
    }
  }

  // static _registerServices() async {
  //   // TODO: register services?
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
