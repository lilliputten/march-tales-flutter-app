import 'package:flutter/material.dart';

import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TracksListBlock.dart';

const double _sidePadding = 5;

class TracksListBlockWithTitle extends StatelessWidget {
  const TracksListBlockWithTitle({
    super.key,
    required this.tracks,
    required this.count,
    this.title = '',
    this.onLoadNext,
    this.isLoading = false,
  });

  final List<Track> tracks;
  final int count;
  final String title;
  final bool isLoading;
  final void Function()? onLoadNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        title.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(_sidePadding),
                child: SectionTitle(
                  text: title,
                  extraText: '(${count})',
                ),
              )
            : null,
        TracksListBlock(
          compact: true,
          tracks: tracks,
          count: count,
          isLoading: isLoading,
          onLoadNext: onLoadNext,
        ),
      ].nonNulls.toList(),
    );
  }
}
