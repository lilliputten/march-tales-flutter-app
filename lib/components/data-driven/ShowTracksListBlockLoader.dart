import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/components/data-driven/views/TracksListBlockWithTitle.dart';
import 'package:march_tales_app/core/constants/defaultTracksFetchingLimit.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksList.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'ShowTracksListBlockLoader.dart.i18n.dart';

final logger = Logger();

class ShowTracksListBlockLoader extends StatefulWidget {
  final String title;
  final String query;

  const ShowTracksListBlockLoader({
    super.key,
    this.title = '',
    this.query = '',
  });

  @override
  State<ShowTracksListBlockLoader> createState() => ShowTracksListBlockLoaderState();
}

class ShowTracksListBlockLoaderState extends State<ShowTracksListBlockLoader> {
  late Future dataFuture;

  /// Loaded tracks data...
  List<Track> _tracks = [];

  /// Total count
  int _count = 0;

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
      final data = await loadTracksList(
          limit: defaultTracksFetchingLimit, offset: this._tracks.length, query: this.widget.query);
      setState(() {
        this._tracks = [...this._tracks, ...data.results];
        this._count = data.count;
      });
      return data;
    } catch (err, stacktrace) {
      final String msg = 'Error loading tracks list.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      setState(() {
        this._tracks = [];
        this._count = 0;
      });
      final translatedMsg = msg.i18n;
      showErrorToast(translatedMsg);
      throw ConnectionException(translatedMsg);
    }
  }

  _reloadData() {
    setState(() {
      this._tracks = [];
      this._count = 0;
    });
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
        // logger.t('[ShowTracksListBlockLoader] isReady=${isReady} error=${snapshot.error}');
        if (isError) {
          return ErrorBlock(
            error: snapshot.error,
            onRetry: this._reloadData,
          );
        }
        return TracksListBlockWithTitle(
          title: this.widget.title,
          tracks: hasData ? this._tracks : [],
          count: hasData ? this._count : 0,
          isLoading: !isReady,
          onLoadNext: this._loadData,
        );
      },
    );
  }
}
