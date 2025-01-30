import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/app/AppColors.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/MyAppState.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

final logger = Logger();

const double trackItemControlIconSize = 24;
const double trackItemControlCircleSize = trackItemControlIconSize + 16;

class TrackItemDefaultControl extends StatelessWidget {
  const TrackItemDefaultControl({
    super.key,
    required this.track,
    this.isActive = false,
  });

  final Track track;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final theme = Theme.of(context);
    // final colorScheme = Theme.of(context).colorScheme;
    final AppColors appColors = theme.extension<AppColors>()!;

    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          width: trackItemControlCircleSize,
          height: trackItemControlCircleSize,
          child: CircularProgressIndicator(
            color: appColors.brandColor.withValues(alpha: 0.2),
            strokeWidth: 2,
            value: 1,
          ),
        ),
        IconButton(
          icon: Icon(
            isActive ? Icons.pause : Icons.play_arrow,
            size: trackItemControlIconSize,
            color: appColors.brandColor,
          ),
          style: IconButton.styleFrom(
            // minimumSize: Size.zero, // Set this
            // padding: EdgeInsets.zero, // and this
            shape: CircleBorder(),
            // backgroundColor: appColors.brandColor, // colorScheme.primary,
            // foregroundColor: appColors.brandColor, // colorScheme.onPrimary,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            appState.playTrack(track);
          },
        ),
      ],
    );
  }
}
