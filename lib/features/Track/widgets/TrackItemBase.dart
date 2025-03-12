import 'package:flutter/material.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';

/// Generic template class for track view widgets
abstract class TrackItemBase extends StatelessWidget {
  const TrackItemBase({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.isPlaying,
    required this.progress,
    required this.isFavorite,
    this.asFavorite = false,
    this.fullView = false,
    this.compact = false,
    this.onClick,
  });

  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final bool isPlaying;
  final double progress;
  final bool isFavorite;
  final bool asFavorite;
  final bool fullView;
  final bool compact;
  final ValueSetter<Track>? onClick;
}
