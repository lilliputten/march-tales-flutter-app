import 'package:flutter/material.dart';

import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'RecentDetails.i18n.dart';

const double _sidePadding = 5;

Widget _mostRecentTrack({
  required final RecentResults recentResults,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 10,
    children: [
      Padding(
        padding: const EdgeInsets.all(_sidePadding),
        child: SectionTitle(
          text: 'The most recent'.i18n,
          // extraText: '(${count})',
        ),
      ),
      TrackItem(
        track: recentResults.mostRecentTrack,
        fullView: false,
        compact: false,
        asFavorite: false,
      ),
    ].nonNulls.toList(),
  );
}

Widget _randomTrack({
  required final RecentResults recentResults,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 10,
    children: [
      Padding(
        padding: const EdgeInsets.all(_sidePadding),
        child: SectionTitle(
          text: 'Random'.i18n,
          // extraText: '(${count})',
        ),
      ),
      TrackItem(
        track: recentResults.randomTrack,
        fullView: false,
        compact: false,
        asFavorite: false,
      ),
    ].nonNulls.toList(),
  );
}

Widget _popularTracks({
  required final RecentResults recentResults,
}) {
  final trackItems = recentResults.popularTracks.map((track) {
    return TrackItem(
      track: track,
      fullView: false,
      compact: true,
      asFavorite: false,
    );
  });
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 10,
    children: [
      Padding(
        padding: const EdgeInsets.all(_sidePadding),
        child: SectionTitle(
          text: 'Most popular'.i18n,
          // extraText: '(${count})',
        ),
      ),
      ...trackItems,
    ].nonNulls.toList(),
  );
}

class RecentDetails extends StatelessWidget {
  final RecentResults recentResults;

  const RecentDetails({
    super.key,
    required this.recentResults,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        _mostRecentTrack(recentResults: this.recentResults),
        _popularTracks(recentResults: this.recentResults),
        _randomTrack(recentResults: this.recentResults),
      ].nonNulls.toList(),
    );
  }
}
