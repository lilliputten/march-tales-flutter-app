import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemBase.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemControl.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemDetails.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class TrackItemAsRow extends TrackItemBase {
  const TrackItemAsRow({
    super.key,
    required super.track,
    required super.isActiveTrack,
    required super.isAlreadyPlayed,
    required super.isPlaying,
    required super.progress,
    required super.isFavorite,
    super.asFavorite,
    super.fullView,
    required super.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final playerBoxState = appState.getPlayerBoxState();

    final double opacity = isAlreadyPlayed ? 0.5 : 1;

    return new Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: () {
          playerBoxState?.setTrack(track, play: false);
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrackImageThumbnail(track: track, height: 60),
              Expanded(
                flex: 1,
                child: Opacity(
                  opacity: opacity,
                  child: TrackItemDetails(
                    track: track,
                    isActiveTrack: isActiveTrack,
                    isAlreadyPlayed: isAlreadyPlayed,
                    isPlaying: isPlaying,
                    isFavorite: isFavorite,
                    asFavorite: asFavorite,
                    fullView: fullView,
                  ),
                ),
              ),
              // TrackFavoriteIcon(track: track),
              TrackItemControl(
                track: track,
                isActiveTrack: isActiveTrack,
                isAlreadyPlayed: isAlreadyPlayed,
                isPlaying: isPlaying,
                progress: progress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
