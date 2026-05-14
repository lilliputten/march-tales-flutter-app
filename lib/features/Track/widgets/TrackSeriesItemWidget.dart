import 'package:flutter/material.dart';

import 'package:march_tales_app/features/Track/loaders/loadTrackDetails.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/screens/TrackDetailsScreen.dart';
import 'TrackSeriesInfoBlock.i18n.dart';

class TrackSeriesItemWidget extends StatefulWidget {
  final int trackId;
  final int position;
  final int totalTracks;
  final bool isCurrentTrack;

  const TrackSeriesItemWidget({
    super.key,
    required this.trackId,
    required this.position,
    required this.totalTracks,
    required this.isCurrentTrack,
  });

  @override
  State<TrackSeriesItemWidget> createState() => _TrackSeriesItemWidgetState();
}

class _TrackSeriesItemWidgetState extends State<TrackSeriesItemWidget> {
  late Future<Track> _trackFuture;

  @override
  void initState() {
    super.initState();
    _trackFuture = loadTrackDetails(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final styleSmall = theme.textTheme.bodySmall!;

    final indexContent = Container(
      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        '${widget.position}/${widget.totalTracks}',
        style: styleSmall,
      ),
    );

    return FutureBuilder<Track>(
      future: _trackFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              spacing: 8,
              children: [
                indexContent,
                Expanded(
                  child: Text(
                    'Loading...'.i18n,
                    style: styleSmall,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              spacing: 8,
              children: [
                indexContent,
                Expanded(
                  child: Text(
                    'Error loading track'.i18n,
                    style: styleSmall,
                  ),
                ),
              ],
            ),
          );
        }

        final track = snapshot.data!;
        return GestureDetector(
          onTap: () {
            if (!widget.isCurrentTrack) {
              // Navigate to the corresponding track
              Navigator.restorablePushNamed(
                context,
                TrackDetailsScreen.routeName,
                arguments: track.id,
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: widget.isCurrentTrack ? theme.primaryColor.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Opacity(
              opacity: widget.isCurrentTrack ? 0.5 : 1.0,
              child: Row(
                spacing: 8,
                children: [
                  indexContent,
                  Expanded(
                    child: Text(
                      track.title,
                      style: styleSmall,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
