import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItemAsCard.dart';
import 'package:march_tales_app/screens/TrackDetailsScreen.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

// NOTE: See theme info at: https://api.flutter.dev/flutter/material/ThemeData-class.html

class TrackItem extends StatefulWidget {
  final Track track;
  final bool asFavorite;
  final bool fullView;
  final bool compact;

  const TrackItem({
    super.key,
    required this.track,
    this.asFavorite = false,
    this.fullView = false,
    this.compact = false,
  });

  @override
  State<TrackItem> createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  TrackInfo? _trackInfo;

  void updateTrackInfo(TracksInfoDbUpdate update) {
    final trackInfo = update.trackInfo;
    final Track track = this.widget.track;
    if (trackInfo.id == track.id) {
      setState(() {
        this._trackInfo = trackInfo;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final Track track = this.widget.track;
    // Load inital value
    tracksInfoDb.getById(track.id).then((trackInfo) {
      if (trackInfo != null) {
        setState(() {
          this._trackInfo = trackInfo;
        });
      }
    });
    // Subscribe to the future updates
    tracksInfoDb.updateEvents.subscribe(this.updateTrackInfo);
  }

  @override
  void dispose() {
    tracksInfoDb.updateEvents.unsubscribe(this.updateTrackInfo);
    super.dispose();
  }

  void _handleClick(Track track) {
    // Show track details page
    // @see https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments
    // @see https://api.flutter.dev/flutter/widgets/Navigator/restorablePush.html
    Navigator.restorablePushNamed(
      context,
      TrackDetailsScreen.routeName,
      arguments: track.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Track track = this.widget.track;

    final appState = context.watch<AppState>();

    // Determine this track state...
    final playingTrack = appState.playingTrack;
    final isActiveTrack = playingTrack != null && playingTrack.id == track.id;
    final isPlaying = isActiveTrack && appState.isPlaying && !appState.isPaused;

    final TrackInfo? trackInfo = this._trackInfo;
    int? position = trackInfo?.position.inMilliseconds;
    int? duration = track.duration.inMilliseconds;

    final isFavorite = appState.isFavoriteTrackId(track.id);

    double progress = 0;
    if (duration != 0 && position != null) {
      progress = position / duration;
    }

    final isAlreadyPlayed = !isActiveTrack && progress >= 1;

    return TrackItemAsCard(
        track: track,
        isActiveTrack: !this.widget.fullView && isActiveTrack,
        isAlreadyPlayed: isAlreadyPlayed,
        isPlaying: isPlaying,
        progress: progress,
        isFavorite: isFavorite,
        asFavorite: this.widget.asFavorite,
        fullView: this.widget.fullView,
        compact: this.widget.compact,
        onClick: this.widget.fullView ? null : this._handleClick);
  }
}
