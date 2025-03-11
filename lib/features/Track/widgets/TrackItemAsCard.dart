import 'dart:math';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/constants/previewDimensionsRatio.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackFullViewExtraBlock.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemBase.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemControls.dart';
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
    super.compact,
    super.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final double opacity = isAlreadyPlayed && !fullView ? 0.5 : 1;

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double height = MediaQuery.sizeOf(context).height;
    final showVertical = height >= screenWidth && !this.compact;

    // Build track info widget items list...
    final itemsList = showVertical
        ? _trackItemAsCardItemsVertical(
            width: screenWidth,
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
            compact: compact,
          )
        : _trackItemAsCardItemsHorizontal(
            width: screenWidth,
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
            compact: compact,
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
        onTap: onClick != null
            ? () {
                onClick!(track);
              }
            : null,
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
  final bool asFavorite = false,
  final bool fullView = false,
  final bool compact = false,
  final bool vertical = false,
}) {
  // final double height = width / previewDimensionsRatio;
  return [
    Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Opacity(
            opacity: detailsOpacity,
            child: TrackItemDetails(
              track: track,
              isActiveTrack: isActiveTrack,
              isAlreadyPlayed: isAlreadyPlayed,
              isPlaying: isPlaying,
              isFavorite: isFavorite,
              asFavorite: asFavorite,
              fullView: fullView,
              compact: compact,
            ),
          ),
          vertical || !fullView ? null : TrackFullViewExtraBlock(track: track)
        ].nonNulls.toList(),
      ),
    ),
    // TrackFavoriteIcon(track: track),
    TrackItemControls(
      track: track,
      isActiveTrack: isActiveTrack,
      isAlreadyPlayed: isAlreadyPlayed,
      isPlaying: isPlaying,
      progress: progress,
      isFavorite: isFavorite,
      fullView: fullView,
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
  final bool asFavorite = false,
  final bool fullView = false,
  final bool compact = false,
}) {
  // final double height = width / previewDimensionsRatio;
  final double thumbWidth = min(200, width / 5);
  return [
    TrackImageThumbnail(track: track, width: thumbWidth, borderRadius: compact ? 5 : 10),
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
      compact: compact,
      vertical: false,
    ),
    // TrackFullViewExtraBlock(track: track),
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
  final bool asFavorite = false,
  final bool fullView = false,
  final bool compact = false,
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
        compact: compact,
        vertical: true,
      ),
    ),
    fullView ? TrackFullViewExtraBlock(track: track) : null,
  ].nonNulls.toList();
}
