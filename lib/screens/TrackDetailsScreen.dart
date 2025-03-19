import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/app/ScreenWrapper.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/getTrackFromStateOrLoad.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/screens/views/TrackDetailsScreenView.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'TrackDetailsScreen.i18n.dart';

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
    super.didChangeDependencies();
    this.dataFuture = this._loadDataFuture();
  }

  Future<Track> _loadDataFuture() async {
    /* // DEBUG
     * this.dataFuture = Future.delayed(Duration(seconds: 1), () {
     *   return 'Track ${id}';
     * });
     */
    final int id = this._getTrackId();
    try {
      /* // DEBUG
       * if (AppConfig.LOCAL) {
       *   await Future.delayed(Duration(seconds: 2));
       * }
       * throw new Exception('Test error');
       */
      final appState = context.read<AppState>();
      return getTrackFromStateOrLoad(id, appState: appState);
    } catch (err, stacktrace) {
      final String msg = 'Error loading track data.';
      logger.e('${msg} id=${id}: $err', error: err, stackTrace: stacktrace);
      // debugger();
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
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

  _retryDataLoad() {
    setState(() {
      this.dataFuture = this._loadDataFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      title: 'Track'.i18n,
      child: FutureBuilder(
        future: this.dataFuture,
        builder: (context, snapshot) {
          final isReady = snapshot.connectionState == ConnectionState.done;
          final isError = isReady && snapshot.error != null;
          final hasData = !isError && snapshot.data != null;
          if (isError) {
            return ErrorBlock(
              error: snapshot.error,
              onRetry: this._retryDataLoad,
              large: true,
            );
          } else if (hasData) {
            final Track track = snapshot.data!;
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
