import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/loaders/getTrackFromStateOrLoad.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/screens/views/TrackDetailsScreenView.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

const _routeName = '/TrackDetailsScreen';

const _debugTrackId = 1;

@pragma('vm:entry-point')
class TrackDetailsScreen extends StatefulWidget {
  const TrackDetailsScreen({
    super.key,
  });

  static const routeName = _routeName;

  @override
  State<TrackDetailsScreen> createState() => TrackDetailsScreenState();
}

class TrackDetailsScreenState extends State<TrackDetailsScreen> with ScrollControllerProviderMixin {
  late Future<Track> dataFuture;

  @override
  void didChangeDependencies() {
    final int id = this._getTrackId();
    super.didChangeDependencies();
    final appState = context.read<AppState>();
    this.dataFuture = getTrackFromStateOrLoad(id, appState: appState);
    /* // DEBUG
     * this.dataFuture = Future.delayed(Duration(seconds: 1), () {
     *   return 'Track ${id}';
     * });
     */
  }

  int _getTrackId() {
    try {
      final int? id = ModalRoute.of(context)?.settings.arguments as int?;
      if (id == null) {
        throw Exception('No track id has been passed for TrackDetailsScreen');
      }
      return id;
    } catch (err) {
      if (AppConfig.LOCAL) {
        // Return demo id for debug purposes
        return _debugTrackId;
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Show track',
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return AppErrorScreen(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final track = snapshot.data!;
            return TrackDetailsScreenView(
              track: track,
              scrollController: this.getScrollController(),
            );
          } else {
            return LoadingSplash();
          }
        },
      ),
    );
  }
}
