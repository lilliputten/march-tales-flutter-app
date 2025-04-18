import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/blocks/MoreButton.dart';
import 'package:march_tales_app/blocks/NoTracksInfo.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';

final logger = Logger();

class TracksListBlock extends StatelessWidget {
  final List<Track> tracks;

  /// Total available track count
  final int count;
  final bool isLoading;
  final bool asFavorite;
  final void Function()? onLoadNext;
  final bool fullView;
  final bool compact;

  const TracksListBlock({
    super.key,
    required this.tracks,
    required this.count,
    this.isLoading = false,
    this.asFavorite = false,
    this.onLoadNext,
    this.fullView = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final tracksCount = this.tracks.length;
    final hasMoreTracks = this.count > tracksCount;

    final trackItems = tracks.map((track) {
      return TrackItem(track: track, fullView: this.fullView, compact: this.compact, asFavorite: this.asFavorite);
    });
    final items = [
      ...trackItems,
      isLoading || hasMoreTracks
          ? MoreButton(
              onLoadNext: this.onLoadNext,
              isLoading: this.isLoading,
              // onlyLoader: true,
            )
          : null,
      !isLoading && count == 0 ? NoTracksInfo() : null,
    ].nonNulls;

    return Column(
      spacing: 5,
      children: items.toList(),
    );
  }
}
