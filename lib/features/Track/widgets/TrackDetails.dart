import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackDetailsInfo.dart';

final logger = Logger();

class TrackTitle extends StatelessWidget {
  const TrackTitle({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.textColor,
  });
  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final double basicAlpha = isAlreadyPlayed ? 0.3 : 1;
    final basicColor = textColor; // .withValues(alpha: basicAlpha);
    final style = theme.textTheme.bodyLarge!.copyWith(color: basicColor);
    return Text(track.title, style: style);
  }
}

class TrackDetails extends StatelessWidget {
  const TrackDetails({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.isPlaying,
    required this.isFavorite,
  });

  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final bool isPlaying;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final colorScheme = theme.colorScheme;
    final textColor =
        isActiveTrack ? appColors.brandColor : colorScheme.onSurface;

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrackTitle(
          track: track,
          isActiveTrack: isActiveTrack,
          isAlreadyPlayed: isAlreadyPlayed,
          textColor: textColor,
        ),
        TrackDetailsInfo(
          track: track,
          isActiveTrack: isActiveTrack,
          isAlreadyPlayed: isAlreadyPlayed,
          isPlaying: isPlaying,
          isFavorite: isFavorite,
          textColor: textColor,
        ),
      ],
    );
  }
}
