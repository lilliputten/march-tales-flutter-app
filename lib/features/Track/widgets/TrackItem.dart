import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/features/Track/widgets/TrackDetailsInfo.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemDefaultControl.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemActiveControl.dart';

final logger = Logger();

// NOTE: See theme info at: https://api.flutter.dev/flutter/material/ThemeData-class.html

class TrackItem extends StatelessWidget {
  const TrackItem({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    // final theme = Theme.of(context);
    // final colorScheme = Theme.of(context).colorScheme;
    // final AppColors appColors = theme.extension<AppColors>()!;

    final playingTrack = appState.playingTrack;

    final isActive = playingTrack?.id == track.id;

    return Center(
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TrackImageThumbnail(track: track, size: 80),
          Expanded(
            flex: 1,
            child: TrackDetails(track: track, isActive: isActive),
          ),
          isActive
              ? TrackItemActiveControl(track: track)
              : TrackItemDefaultControl(track: track, isActive: isActive),
        ],
      ),
    );
  }
}

class TrackTitle extends StatelessWidget {
  const TrackTitle({
    super.key,
    required this.track,
    this.textColor,
  });
  final Track track;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyLarge!.copyWith(color: textColor);
    return Text(track.title, style: style);
  }
}

class TrackDetails extends StatelessWidget {
  const TrackDetails({
    super.key,
    required this.track,
    this.isActive = false,
  });
  final Track track;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = isActive ? colorScheme.primary : colorScheme.onSurface;
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrackTitle(track: track, textColor: textColor),
        TrackDetailsInfo(
            track: track, isActive: isActive, textColor: textColor),
      ],
    );
  }
}
