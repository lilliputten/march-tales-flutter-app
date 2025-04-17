// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/ErrorBlock.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/components/data-driven/views/TracksListBlockWithTitle.dart';
import 'package:march_tales_app/core/exceptions/ConnectionException.dart';
import 'package:march_tales_app/core/helpers/showErrorToast.dart';
import 'package:march_tales_app/features/Track/loaders/loadRecents.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'RecentsLoader.dart.i18n.dart';

final logger = Logger();

class RecentsLoader extends StatefulWidget {
  final String title;
  final String query;

  const RecentsLoader({
    super.key,
    this.title = '',
    this.query = '',
  });

  @override
  State<RecentsLoader> createState() => RecentsLoaderState();
}

class RecentsLoaderState extends State<RecentsLoader> {
  late Future dataFuture;

  // Loaded tracks data...
  late List<Track> recentTracks;
  late List<Track> popularTracks;
  late Track? mostRecentTrack;
  late Track? randomTrack;

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
        this.recentTracks = data.recentTracks;
        this.popularTracks = data.popularTracks;
        this.mostRecentTrack = data.mostRecentTrack;
        this.randomTrack = data.randomTrack;
      });
      return data;
    } catch (err, stacktrace) {
      final String msg = 'Error loading recent data.';
      logger.e('${msg}: $err', error: err, stackTrace: stacktrace);
      setState(() {
        this.recentTracks = [];
        this.recentTracks = [];
        this.popularTracks = [];
        this.mostRecentTrack = null;
        this.randomTrack = null;
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
        // logger.t('[RecentsLoader] isReady=${isReady} error=${snapshot.error}');
        if (isError) {
          return ErrorBlock(
            error: snapshot.error,
            onRetry: this._reloadData,
          );
        } else if (isReady && hasData) {
          return Text('RecentsBlock');
          /*
           * return RecentsBlock(
           *   recentTracks: this.recentTracks,
           *   popularTracks: this.popularTracks,
           *   mostRecentTrack: this.mostRecentTrack,
           *   randomTrack: this.randomTrack,
           *   isLoading: !isReady,
           *   onLoadNext: this._loadData,
           * );
           */
        } else {
          return LoadingSplash();
        }
      },
    );
  }
}
