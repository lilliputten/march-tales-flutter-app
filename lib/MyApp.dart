// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/helpers/YamlFormatter.dart';
import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/pages/MyHomePage.dart';

import 'Init.dart';
import 'SplashScreen.dart';

final formatter = YamlFormatter();
final logger = Logger();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Future initFuture = Init.initialize();

    return ChangeNotifierProvider(
      create: (context) {
        var appState = MyAppState();
        initFuture.then((initData) {
          // Get project info from init data and set to the context
          final projectInfo = initData['projectInfo'];
          logger.d(
              '[ChangeNotifierProvider:create:initFuture.then]: $projectInfo, $initData');
          appState.setProjectInfo(projectInfo);
          appState.loadTracks(offset: 0, limit: 2); // TODO: Get these parameters from constants/config
        });
        // logger.d('[ChangeNotifierProvider:create]: $initFuture');
        return appState;
      },
      child: MaterialApp(
        title: 'March Tales',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        ),
        // home: MyHomePage(),
        home: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // logger.d('snapshot.data: ${formatter.format(snapshot.data)}');
              return MyHomePage();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
