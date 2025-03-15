import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/MoreButton.dart';
import 'package:march_tales_app/components/mixins/ScrollControllerProviderMixin.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';

final logger = Logger();

class TracksList extends StatefulWidget {
  final List<Track> tracks;
  final int count;
  final bool isLoading;
  final bool asFavorite;
  final bool useScrollController;
  final RefreshCallback? onRefresh;
  final void Function()? onLoadNext;
  final bool fullView;
  final bool compact;

  const TracksList({
    super.key,
    required this.tracks,
    required this.count,
    this.isLoading = false,
    this.useScrollController = false,
    this.asFavorite = false,
    this.onRefresh,
    this.onLoadNext,
    this.fullView = false,
    this.compact = false,
  });

  @override
  State<TracksList> createState() => TracksListState();
}

// TODO: Use `ScrollControllerProviderMixin`
class TracksListState extends State<TracksList> with ScrollControllerProviderMixin {
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
        scrollController: this.widget.useScrollController ? this.getScrollController() : null,
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
  final bool fullView;
  final bool compact;

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
    this.fullView = false,
    this.compact = false,
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
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: showItems,
      itemBuilder: (context, i) {
        if (i == tracksCount) {
          return MoreButton(onLoadNext: this.onLoadNext, isLoading: this.isLoading);
        } else {
          return TrackItem(
              track: this.tracks[i], fullView: this.fullView, compact: this.compact, asFavorite: this.asFavorite);
        }
      },
    );
  }
}
