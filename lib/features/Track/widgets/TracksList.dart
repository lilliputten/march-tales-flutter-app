import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'TracksList.i18n.dart';

final logger = Logger();

class MoreButton extends StatelessWidget {
  // XXX To use auto-update and lazy-scroll
  const MoreButton({
    super.key,
    required this.isLoading,
    // this.onRefresh,
    this.onLoadNext,
  });

  final bool isLoading;
  // final RefreshCallback? onRefresh;
  final void Function()? onLoadNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final AppColors appColors = theme.extension<AppColors>()!;
    final buttonColorTheme = theme.buttonTheme.colorScheme!;
    // final appState = context.watch<AppState>();
    // final tracksIsLoading = appState.tracksIsLoading;
    // final baseColor = appColors.brandColor;
    final baseColor = buttonColorTheme.primary;
    final color = isLoading ? baseColor.withValues(alpha: 0.5) : baseColor;
    const double iconSize = 20;
    return Center(
      child: TextButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll<Color>(color),
        ),
        onPressed: isLoading ? null : this.onLoadNext,
        icon: isLoading
            ? SizedBox(
                height: iconSize,
                width: iconSize,
                child: CircularProgressIndicator(color: color, strokeWidth: 2),
              )
            : Icon(Icons.arrow_circle_down, size: iconSize, color: color),
        label: Text(isLoading ? 'Loading...'.i18n : 'Show more...'.i18n),
      ),
    );
  }
}

class TracksList extends StatelessWidget {
  const TracksList({
    super.key,
    required this.tracks,
    required this.count,
    required this.isLoading,
    this.asFavorite = false,
    this.onRefresh,
    this.onLoadNext,
  });

  final List<Track> tracks;
  final int count;
  final bool isLoading;
  final bool asFavorite;
  final RefreshCallback? onRefresh;
  final void Function()? onLoadNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final tracksCount = this.tracks.length;
    final hasMoreTracks = this.count > tracksCount;
    final showItems = hasMoreTracks ? tracksCount + 1 : tracksCount;

    final keyId = this.asFavorite ? 'FavoritesList' : 'TracksList';
    final listKey = PageStorageKey<String>(keyId);

    return RefreshIndicator(
      color: appColors.brandColor,
      strokeWidth: 2,
      onRefresh: () async {
        if (onRefresh != null) {
          await onRefresh!();
        }
      },
      child: ListView.separated(
        key: listKey,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        separatorBuilder: (context, index) => SizedBox(),
        itemCount: showItems,
        itemBuilder: (context, i) {
          if (i == tracksCount) {
            return MoreButton(onLoadNext: onLoadNext, isLoading: isLoading);
          } else {
            return TrackItem(track: this.tracks[i], asFavorite: this.asFavorite);
          }
        },
      ),
    );
  }
}
