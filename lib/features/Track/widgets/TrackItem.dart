import 'package:flutter/material.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

class TrackItem extends StatelessWidget {
  const TrackItem({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(track.title),
            ),
          ),
        ],
      ),
    );
  }
}
