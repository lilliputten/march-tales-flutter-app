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
    this.onLoadNext,
  });

  final bool isLoading;
  final void Function()? onLoadNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColorTheme = theme.buttonTheme.colorScheme!;
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
    this.useScrollController = false,
    this.asFavorite = false,
    this.onRefresh,
    this.onLoadNext,
  });

  final List<Track> tracks;
  final int count;
  final bool isLoading;
  final bool asFavorite;
  final bool useScrollController;
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
    if (this.widget.useScrollController) {
      Future.delayed(Duration.zero, () {
        this._appState.addScrollController(this.scrollController);
      });
    }
  }

  @override
  void dispose() {
    if (this.widget.useScrollController) {
      Future.delayed(Duration.zero, () {
        this._appState.removeScrollController(this.scrollController);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final keyId = this.widget.asFavorite ? 'FavoritesList' : 'TracksList';

    return RefreshIndicator(
      color: appColors.brandColor,
      strokeWidth: 2,
      onRefresh: () async {
        if (this.widget.onRefresh != null) {
          await this.widget.onRefresh!();
        }
      },
      child: TracksListView(
        keyId: keyId,
        tracks: this.widget.tracks,
        count: this.widget.count,
        isLoading: this.widget.isLoading,
        useScrollController: this.widget.useScrollController,
        scrollController: this.widget.useScrollController ? this.scrollController : null,
        asFavorite: this.widget.asFavorite,
        onRefresh: this.widget.onRefresh,
        onLoadNext: this.widget.onLoadNext,
      ),
    );
  }
}

class TracksListView extends StatelessWidget {
  final List<Track> tracks;
  final String? keyId;

  /// Total available track count
  final int count;
  final bool isLoading;
  final bool asFavorite;
  final bool useScrollController;
  final ScrollController? scrollController;
  final RefreshCallback? onRefresh;
  final void Function()? onLoadNext;

  const TracksListView({
    super.key,
    this.keyId,
    required this.tracks,
    required this.count,
    required this.isLoading,
    this.useScrollController = false,
    this.scrollController,
    this.asFavorite = false,
    this.onRefresh,
    this.onLoadNext,
  });

  @override
  Widget build(BuildContext context) {
    final tracksCount = this.tracks.length;
    final hasMoreTracks = this.count > tracksCount;
    final showItems = hasMoreTracks ? tracksCount + 1 : tracksCount;

    final resolvedKeyId = this.keyId ?? (this.asFavorite ? 'FavoritesList' : 'TracksList');
    final listKey = PageStorageKey<String>(resolvedKeyId);

    return ListView.separated(
      key: listKey,
      // scrollDirection: Axis.vertical,
      // shrinkWrap: true,
      controller: this.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      separatorBuilder: (context, index) => SizedBox(height: 5),
      itemCount: showItems,
      itemBuilder: (context, i) {
        if (i == tracksCount) {
          return MoreButton(onLoadNext: this.onLoadNext, isLoading: this.isLoading);
        } else {
          return TrackItem(track: this.tracks[i], asFavorite: this.asFavorite);
        }
      },
    );
  }
}
