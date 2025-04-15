import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemFavoriteControl.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemPlayControl.dart';

final logger = Logger();

class TrackItemControls extends StatelessWidget {
  const TrackItemControls({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.isPlaying,
    required this.progress,
    this.isFavorite = false,
    this.fullView = false,
    this.compact = false,
  });

  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final bool isPlaying;
  final double progress;
  final bool isFavorite;
  final bool fullView;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Show favorite button if it's a full view mode
        !compact
            ? TrackItemFavoriteControl(
                track: track,
                // isActiveTrack: isActiveTrack,
                isAlreadyPlayed: isAlreadyPlayed,
                // isPlaying: isPlaying,
                // progress: progress,
                isFavorite: isFavorite,
                fullView: fullView,
              )
            : null,
        TrackItemPlayControl(
          track: track,
          isActiveTrack: isActiveTrack,
          isAlreadyPlayed: isAlreadyPlayed,
          isPlaying: isPlaying,
          progress: progress,
          isFavorite: isFavorite,
          fullView: fullView,
        ),
      ].nonNulls.toList(),
    );
  }
}
