import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

const _routeName = '/TrackDetailsScreen';

class TrackDetailsScreenArguments {
  final Track? track;

  TrackDetailsScreenArguments(this.track);
}

class TrackDetailsScreen extends StatelessWidget {
  const TrackDetailsScreen({
    super.key,
    this.track,
  });
  final Track? track;

  static const routeName = _routeName;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    // final appTheme = appState.isDarkTheme;

    return ScreenWrapper(
      title: track?.title ?? 'Title',
      child: Column(
        children: [
          Text(track?.title ?? 'Title'),
          Text(track?.description ?? 'Description'),
        ],
      ),
    );
  }
}
