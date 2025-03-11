import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemDetailsInlineInfo.dart';

final logger = Logger();

class TrackTitle extends StatelessWidget {
  const TrackTitle({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.textColor,
    this.fullView = false,
    this.compact = false,
  });
  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final Color textColor;
  final bool fullView;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final basicColor = textColor;
    final baseStyle = compact ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge;
    final style = baseStyle!.copyWith(color: basicColor, fontWeight: FontWeight.bold);
    String text = track.title;
    if (AppConfig.LOCAL) {
      text += ' (${track.id})';
    }
    return Text(text, style: style);
  }
}

class TrackItemDetails extends StatelessWidget {
  const TrackItemDetails({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.isPlaying,
    required this.isFavorite,
    this.asFavorite = false,
    this.fullView = false,
    this.compact = false,
  });

  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final bool isPlaying;
  final bool isFavorite;
  final bool asFavorite;
  final bool fullView;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final colorScheme = theme.colorScheme;
    final textColor = isActiveTrack ? appColors.brandColor : colorScheme.onSurface;

    return Column(
      spacing: compact ? 5 : 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrackTitle(
          track: track,
          isActiveTrack: isActiveTrack,
          isAlreadyPlayed: isAlreadyPlayed,
          textColor: textColor,
          fullView: fullView,
          compact: compact,
        ),
        TrackItemDetailsInlineInfo(
          track: track,
          isActiveTrack: isActiveTrack,
          isAlreadyPlayed: isAlreadyPlayed,
          isPlaying: isPlaying,
          isFavorite: isFavorite,
          asFavorite: asFavorite,
          fullView: fullView,
          compact: compact,
          textColor: textColor,
        ),
      ].nonNulls.toList(),
    );
  }
}
