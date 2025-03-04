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

const double _screenHorizontalPadding = 15;

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
    final playerBoxState = appState.getPlayerBoxState();

    final double opacity = isAlreadyPlayed ? 0.5 : 1;

    final double width = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    final showVertical = height >= width;

    // Build track info widget items list...
    final itemsList = showVertical
        ? _trackItemAsCardItemsVertical(
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
        : _trackItemAsCardItemsHorizontal(
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

    // Build wrapper...
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

    // Create the widget...
    return new Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        onTap: () {
          // XXX Call setTrack from `PlayerBoxState`
          playerBoxState?.setTrack(track, play: false);
          // appState.setPlayingTrack(track, play: false);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: content,
        ),
      ),
    );
  }
}

List<Widget> _trackItemAsCardDetailItems({
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

List<Widget> _trackItemAsCardItemsHorizontal({
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
    ..._trackItemAsCardDetailItems(
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

List<Widget> _trackItemAsCardItemsVertical({
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
  final double height = (width - _screenHorizontalPadding * 2) / previewDimensionsRatio;
  return [
    TrackImageThumbnail(track: track, width: width, height: height),
    Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _trackItemAsCardDetailItems(
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
