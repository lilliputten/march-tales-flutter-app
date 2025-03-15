import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/data-driven/views/TracksListBlockWithTitle.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
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
  late Future<LoadTracksListResults> dataFuture;

  /// Loaded tracks data...
  List<Track> tracks = [];

  /// Total count
  int count = 0;

  /// Loading flag
  bool isLoading = true;

  /// Error
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.loadData();
  }

  loadData() async {
    setState(() {
      this.isLoading = true;
    });
    try {
      final data = await loadTracksList(offset: tracks.length, query: this.widget.query);
      setState(() {
        this.tracks.addAll(data.results);
        this.count = data.count;
        this.isLoading = false;
      });
    } catch (err, stacktrace) {
      logger.e('[ShowTracksListBlockLoader] Error: ${err}', error: err, stackTrace: stacktrace);
      debugger();
      setState(() {
        this.error = error.toString();
        this.isLoading = false;
      });
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content: Text("Error loading tracks data".i18n),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TracksListBlockWithTitle(
      title: this.widget.title,
      tracks: tracks,
      count: count,
      isLoading: isLoading,
      onLoadNext: this.loadData,
    );
  }
}
