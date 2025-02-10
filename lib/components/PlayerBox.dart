import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/PlayerSlider.dart';
import 'package:march_tales_app/core/helpers/getDurationString.dart';
import 'package:march_tales_app/features/Track/db/TrackInfo.dart';
import 'package:march_tales_app/features/Track/db/TracksInfoDb.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackImageThumbnail.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

final logger = Logger();

// @see https://docs.flutter.dev/cookbook/networking/fetch-data
class PlayerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final track = appState.playingTrack;
    final player = appState.activePlayer;

    // No active track?
    if (track == null) {
      // Display nothing if no active track
      return Container();
    }

    return StreamBuilder(
        stream: player.playerStateStream,
        builder: (context, AsyncSnapshot snapshot) {
          // final PlayerState? playerState = snapshot.data;
          // final bool? playing = playerState?.playing;
          // final ProcessingState? processingState = playerState?.processingState;
          // final position = player.position;
          // final duration = player.duration;
          // logger.t('PlayerBox: playing: ${playing} processingState: ${processingState} position: ${position} duration: ${duration} ${playerState}');
          // appState.updatePlayerStatus(playerState);
          // int currentIndex = snapshot.data ?? 0;
          return PlayerWrapper(
              key: Key('PlayerWrapper_${track.id}'), track: track);
        });
  }
}

class PlayerWrapper extends StatefulWidget {
  const PlayerWrapper({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  State<PlayerWrapper> createState() => _PlayerWrapperState();
}

class _PlayerWrapperState extends State<PlayerWrapper> {
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

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    // final Track? track = appState.playingTrack;

    // if (track == null) {
    //   return Container();
    // }

    final Track track = widget.track;

    final Duration duration = track.duration;
    final Duration? position = appState.playingPosition;

    final showSlider = position != null;

    return Column(
      spacing: 0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showSlider
            ? PlayerSlider(
                position: position,
                duration: duration,
                onSeek: (Duration position) {
                  appState.playSeek(position);
                },
              )
            : Container(),
        Padding(
          // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: EdgeInsets.fromLTRB(10, showSlider ? 0 : 10, 10,
              10), // Show top padding only if there no track slider above
          child: Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TrackImageThumbnail(track: track, size: 50),
              Expanded(
                flex: 1,
                child: PlayerTrackDetails(),
              ),
              PlayerFavoriteIcon(track: track, trackInfo: this._trackInfo),
              Text('Play'),
            ],
          ),
        ),
      ],
    );
  }
}

class PlayerTrackDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodyMedium!;

    final track = appState.playingTrack;

    // No active track?
    if (track == null) {
      return Container();
    }

    final isPlaying = appState.isPlaying;
    final isPaused = appState.isPaused;
    final position = appState.playingPosition;
    final hasPosition = position != null && position.inMilliseconds != 0;

    String text = track.title;
    if (isPlaying || hasPosition) {
      final state = !isPlaying || isPaused ? 'paused' : 'playing';
      if (hasPosition) {
        final positionString = getDurationString(position);
        text += ' (${state} ${positionString})';
      }
    }

    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(color: textColor),
        ),
        // TrackTitle(track: track, textColor: textColor),
        // TrackDetailsInfo(track: track, isActive: isActive, textColor: textColor),
      ],
    );
  }
}

class PlayerFavoriteIcon extends StatelessWidget {
  const PlayerFavoriteIcon({
    super.key,
    required this.track,
    required this.trackInfo,
  });
  final Track track;
  final TrackInfo? trackInfo;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    // final colorScheme = theme.colorScheme;

    final isFavorite = trackInfo?.favorite ?? false;

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        // size: 20, // trackItemControlIconSize,
        color: appColors.brandColor,
      ),
      style: IconButton.styleFrom(
          // shape: CircleBorder(),
          ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        final setFavorite = !isFavorite;
        logger.d(
            '[TrackItem:PlayerFavoriteIcon:onPressed] track.id=${track.id} setFavorite=${setFavorite}');
        tracksInfoDb.setFavorite(track.id, favorite: setFavorite);
      },
    );
  }
}
