import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/screens/views/RecentsScreenView.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class RecentsScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const RecentsScreen({
    super.key,
    this.scrollController,
  });

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  /*
   * late Future recentsFuture;
   * late RecentResults? recentResults;
   * @override
   * void didChangeDependencies() {
   *   super.didChangeDependencies();
   *   this._loadData();
   * }
   * _loadDataFuture() async {
   *   try {
   *     final data = await loadRecents();
   *     logger.t(
   *         '[_loadDataFuture] recentTracks=${data.recentTracks} popularTracks=${data.popularTracks} mostRecentTrack=${data.mostRecentTrack} randomTrack=${data.randomTrack}');
   *     setState(() {
   *       this.recentResults = data;
   *     });
   *     return data;
   *   } catch (err, stacktrace) {
   *     final String msg = 'Error loading recent data.';
   *     logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
   *     setState(() {
   *       this.recentResults = null;
   *     });
   *     final translatedMsg = msg.i18n;
   *     showErrorToast(translatedMsg);
   *     throw ConnectionException(translatedMsg);
   *   }
   * }
   * _reloadData() {
   *   // XXX: Clear state?
   *   this._loadData();
   * }
   * _loadData() {
   *   setState(() {
   *     this.recentsFuture = this._loadDataFuture();
   *   });
   * }
   */

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return FutureBuilder(
      future: appState.recentsFuture,
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;
        final isError = isReady && snapshot.error != null;
        final hasData = !isError && snapshot.data != null;
        logger.t('[RecentsScreen] data=${snapshot.data} isReady=${isReady} error=${snapshot.error}');
        if (isError) {
          return ErrorBlock(
            error: snapshot.error,
            onRetry: () {
              appState.reloadRecentsData();
            },
          );
        } else if (isReady && hasData) {
          return RecentsScreenView(
            recentResults: snapshot.data!,
            scrollController: this.widget.scrollController,
          );
        } else {
          return LoadingSplash();
        }
      },
    );
  }
}
