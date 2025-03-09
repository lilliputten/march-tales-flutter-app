// import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';

// import 'package:provider/provider.dart';

// import 'package:march_tales_app/features/Track/types/Track.dart';
// import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

const _routeName = '/TrackDetailsScreen';

class TrackDetailsScreen extends StatefulWidget {
  const TrackDetailsScreen({
    super.key,
    // required this.id,
  });
  // final int id;

  static const routeName = _routeName;

  @override
  State<TrackDetailsScreen> createState() => TrackDetailsScreenState();
}

@pragma('vm:entry-point')
class TrackDetailsScreenState extends State<TrackDetailsScreen> {
  late Future dataFuture;

  /*
   * @override
   * void initState() {
   *   super.initState();
   * }
   */

  @override
  void didChangeDependencies() {
    final int id = ModalRoute.of(context)?.settings.arguments as int;
    super.didChangeDependencies();
    this.dataFuture = Future.delayed(Duration(seconds: 1), () {
      return 'Track ${id}';
    });
  }

  /*
   * @override
   * void dispose() {
   *   super.dispose();
   * }
   */

  @override
  Widget build(BuildContext context) {
    // final int id = ModalRoute.of(context)?.settings.arguments as int;
    // final appState = context.watch<AppState>();
    // final appTheme = appState.isDarkTheme;

    // final track = this.widget.track;

    return ScreenWrapper(
      title: 'Track title',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          // final appState = context.watch<AppState>();
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data);
          } else {
            return LoadingSplash();
          }
        },
      ),
    );
  }
}
