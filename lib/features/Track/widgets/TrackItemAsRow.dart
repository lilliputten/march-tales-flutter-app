import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackDetails.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemControl.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class TrackItemAsRow extends StatelessWidget {
  const TrackItemAsRow({
    super.key,
    required this.track,
    required this.isActiveTrack,
    required this.isAlreadyPlayed,
    required this.isPlaying,
    required this.progress,
    required this.isFavorite,
    this.asFavorite,
  });

  final Track track;
  final bool isActiveTrack;
  final bool isAlreadyPlayed;
  final bool isPlaying;
  final double progress;
  final bool isFavorite;
  final bool? asFavorite;

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
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                  child: TrackDetails(
                    track: track,
                    isActiveTrack: isActiveTrack,
                    isAlreadyPlayed: isAlreadyPlayed,
                    isPlaying: isPlaying,
                    isFavorite: isFavorite,
                    asFavorite: asFavorite,
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
