import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/constants/previewDimensionsRatio.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackDetails.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemControl.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

class TrackItemAsCard extends StatelessWidget {
  const TrackItemAsCard({
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

    final double opacity = isAlreadyPlayed ? 0.5 : 1;

    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    final showVertical = height >= width;

    final itemsList = showVertical
        ? trackItemAsCardItemsVertical(
            width: showVertical ? width : width / 3,
            detailsOpacity: opacity,
            appState: appState,
            track: track,
            isActiveTrack: isActiveTrack,
            isAlreadyPlayed: isAlreadyPlayed,
            isPlaying: isPlaying,
            progress: progress,
            isFavorite: isFavorite,
            asFavorite: asFavorite,
          )
        : trackItemAsCardItemsHorizontal(
            width: width,
            detailsOpacity: opacity,
            appState: appState,
            track: track,
            isActiveTrack: isActiveTrack,
            isAlreadyPlayed: isAlreadyPlayed,
            isPlaying: isPlaying,
            progress: progress,
            isFavorite: isFavorite,
            asFavorite: asFavorite,
          );
    final content = showVertical
        ? Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemsList,
          )
        : Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemsList,
          );

    return new Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: () {
          appState.setPlayingTrack(track, play: false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: content,
        ),
      ),
    );
  }
}

List<Widget> trackItemAsCardDetailItems({
  required final double width,
  required final double detailsOpacity,
  required final AppState appState,
  required final Track track,
  required final bool isActiveTrack,
  required final bool isAlreadyPlayed,
  required final bool isPlaying,
  required final double progress,
  required final bool isFavorite,
  final bool? asFavorite = false,
}) {
  // final double height = width / previewDimensionsRatio;
  return [
    Expanded(
      flex: 1,
      child: Opacity(
        opacity: detailsOpacity,
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
  ];
}

List<Widget> trackItemAsCardItemsHorizontal({
  required final double width,
  required final double detailsOpacity,
  required final AppState appState,
  required final Track track,
  required final bool isActiveTrack,
  required final bool isAlreadyPlayed,
  required final bool isPlaying,
  required final double progress,
  required final bool isFavorite,
  final bool? asFavorite = false,
}) {
  // final double height = width / previewDimensionsRatio;
  return [
    TrackImageThumbnail(track: track, height: 100),
    ...trackItemAsCardDetailItems(
      width: width,
      detailsOpacity: detailsOpacity,
      appState: appState,
      track: track,
      isActiveTrack: isActiveTrack,
      isAlreadyPlayed: isAlreadyPlayed,
      isPlaying: isPlaying,
      progress: progress,
      isFavorite: isFavorite,
      asFavorite: asFavorite,
    ),
  ];
}

List<Widget> trackItemAsCardItemsVertical({
  required final double width,
  required final double detailsOpacity,
  required final AppState appState,
  required final Track track,
  required final bool isActiveTrack,
  required final bool isAlreadyPlayed,
  required final bool isPlaying,
  required final double progress,
  required final bool isFavorite,
  final bool? asFavorite = false,
}) {
  final double height = width / previewDimensionsRatio;
  return [
    TrackImageThumbnail(track: track, width: width, height: height),
    Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: trackItemAsCardDetailItems(
        width: width,
        detailsOpacity: detailsOpacity,
        appState: appState,
        track: track,
        isActiveTrack: isActiveTrack,
        isAlreadyPlayed: isAlreadyPlayed,
        isPlaying: isPlaying,
        progress: progress,
        isFavorite: isFavorite,
        asFavorite: asFavorite,
      ),
    ),
  ];
}
