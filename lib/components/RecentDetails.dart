import 'package:flutter/material.dart';

import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'RecentDetails.i18n.dart';

const double _sidePadding = 5;

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
        Padding(
          padding: const EdgeInsets.all(_sidePadding),
          child: SectionTitle(
            text: 'The most recent'.i18n,
            // extraText: '(${count})',
          ),
        ),
        TrackItem(
          track: this.recentResults.mostRecentTrack,
          fullView: false,
          compact: false,
          asFavorite: false,
        ),
      ].nonNulls.toList(),
    );
  }
}
