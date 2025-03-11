import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppErrorScreen.dart';
import 'package:march_tales_app/components/LoadingSplash.dart';
import 'package:march_tales_app/features/Track/loaders/LoadTracksListResults.dart';
import 'package:march_tales_app/features/Track/loaders/loadTracksByIds.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';

final logger = Logger();

class TracksListByIds extends StatefulWidget {
  const TracksListByIds({
    super.key,
    required this.ids,
    this.useScrollController = false,
    this.asFavorite = false,
  });

  final List<int> ids;
  final bool asFavorite;
  final bool useScrollController;

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
    return await this.dataFuture;
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
          return Column(
            children: data.results.map((track) {
              return TrackItem(track: track);
            }).toList(),
          );
        } else {
          return LoadingSplash();
        }
      },
    );
  }
}
