import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksByIds.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';

final logger = Logger();

// XXX FUTURE: Fetch the available tracks from the state and only load remain from the server

class TracksListByIds extends StatefulWidget {
  final List<int> ids;
  final bool asFavorite;
  final bool compact;
  final bool useScrollController;

  const TracksListByIds({
    super.key,
    required this.ids,
    this.useScrollController = false,
    this.asFavorite = false,
    this.compact = false,
  });

  @override
  State<TracksListByIds> createState() => TracksListByIdsState();
}

class TracksListByIdsState extends State<TracksListByIds> {
  late Future<LoadTracksListResults> dataFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._loadData();
  }

  _loadData() async {
    this.dataFuture = loadTracksByIds(this.widget.ids);
    // logger.t('[TracksListByIds:_loadData]');
    return await this.dataFuture;
  }

  /// Sort by published date (in a descending order) by default
  List<Track> _sortedTracks(List<Track> tracks) {
    final sorted = [...tracks];
    sorted.sort((a, b) => -a.published_at.compareTo(b.published_at));
    return sorted;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.dataFuture,
      builder: (context, snapshot) {
        if (snapshot.error != null) {
          return AppErrorScreen(error: snapshot.error);
        }
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          final LoadTracksListResults data = snapshot.data!;
          final tracks = this._sortedTracks(data.results);
          return Column(
            spacing: 5,
            children: tracks.map((track) {
              return TrackItem(track: track, compact: this.widget.compact);
            }).toList(),
          );
        } else {
          return LoadingSplash();
        }
      },
    );
  }
}
