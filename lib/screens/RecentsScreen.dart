import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadRecents.dart';
import 'package:march_tales_app/screens/views/RecentsScreenView.dart';
import 'RecentsScreen.dart.i18n.dart';

final logger = Logger();

class RecentsScreen extends StatefulWidget {
  final ScrollController? scrollController;

  const RecentsScreen({
    super.key,
    this.scrollController,
  });

  @override
  State<RecentsScreen> createState() => RecentsScreenState();
}

class RecentsScreenState extends State<RecentsScreen> {
  late Future dataFuture;

  late RecentResults? recentResults;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._loadData();
  }

  _loadDataFuture() async {
    try {
      /* // DEBUG
       * if (AppConfig.LOCAL) {
       *   await Future.delayed(Duration(seconds: 2));
       * }
       * throw new Exception('Test error');
       */
      final data = await loadRecents();
      logger.t(
          '[_loadDataFuture] recentTracks=${data.recentTracks} popularTracks=${data.popularTracks} mostRecentTrack=${data.mostRecentTrack} randomTrack=${data.randomTrack}');
      setState(() {
        this.recentResults = data;
      });
      return data;
    } catch (err, stacktrace) {
      final String msg = 'Error loading recent data.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      setState(() {
        this.recentResults = null;
      });
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  _reloadData() {
    // XXX: Clear state?
    this._loadData();
  }

  _loadData() {
    setState(() {
      this.dataFuture = this._loadDataFuture();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.dataFuture,
      builder: (context, snapshot) {
        final isReady = snapshot.connectionState == ConnectionState.done;
        final isError = isReady && snapshot.error != null;
        final hasData = !isError && snapshot.data != null;
        logger.t('[RecentsScreen] data=${snapshot.data} isReady=${isReady} error=${snapshot.error}');
        if (isError) {
          return ErrorBlock(
            error: snapshot.error,
            onRetry: this._reloadData,
          );
        } else if (isReady && hasData) {
          return RecentsScreenView(
            recentResults: snapshot.data,
            scrollController: this.widget.scrollController,
            // isLoading: !isReady,
            // onLoadNext: this._loadData,
          );
        } else {
          return LoadingSplash();
        }
      },
    );
  }
}
