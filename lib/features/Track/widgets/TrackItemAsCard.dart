import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/constants/previewDimensionsRatio.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemBase.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemControl.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemDetails.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

const double _screenHorizontalPadding = 15;

class TrackItemAsCard extends TrackItemBase {
  const TrackItemAsCard({
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
            fullView: fullView,
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
            fullView: fullView,
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
          onClick(track);
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
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
  final bool? fullView = false,
}) {
  // final double height = width / previewDimensionsRatio;
  return [
    Expanded(
      flex: 1,
      child: Opacity(
        opacity: detailsOpacity,
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
  final bool? fullView = false,
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
      fullView: fullView,
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
  final bool? fullView = false,
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
        fullView: fullView,
      ),
    ),
  ];
}
