import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'TracksList.i18n.dart';

final logger = Logger();

class MoreButton extends StatelessWidget {
  // TODO: To use auto-update and lazy-scroll
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

class TracksList extends StatefulWidget {
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
  State<TracksList> createState() => TracksListState();
}

class TracksListState extends State<TracksList> {
  late AppState _appState;
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    this._appState = context.read<AppState>();
    Future.delayed(Duration.zero, () {
      this._appState.addScrollController(this.scrollController);
    });
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      this._appState.removeScrollController(this.scrollController);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final tracksCount = this.widget.tracks.length;
    final hasMoreTracks = this.widget.count > tracksCount;
    final showItems = hasMoreTracks ? tracksCount + 1 : tracksCount;

    final keyId = this.widget.asFavorite ? 'FavoritesList' : 'TracksList';
    final listKey = PageStorageKey<String>(keyId);

    return RefreshIndicator(
      color: appColors.brandColor,
      strokeWidth: 2,
      onRefresh: () async {
        if (this.widget.onRefresh != null) {
          await this.widget.onRefresh!();
        }
      },
      child: ListView.separated(
        key: listKey,
        controller: this.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        separatorBuilder: (context, index) => SizedBox(height: 5),
        itemCount: showItems,
        itemBuilder: (context, i) {
          if (i == tracksCount) {
            return MoreButton(onLoadNext: this.widget.onLoadNext, isLoading: this.widget.isLoading);
          } else {
            return TrackItem(track: this.widget.tracks[i], asFavorite: this.widget.asFavorite);
          }
        },
      ),
    );
  }
}
