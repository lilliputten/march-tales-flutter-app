import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/app/RootScreen.dart';
import 'package:march_tales_app/app/homePages.dart';
import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/features/Track/loaders/RecentResults.dart';
import 'package:march_tales_app/features/Track/widgets/TrackItem.dart';
import 'package:march_tales_app/screens/AuthorsListScreen.dart';
import 'package:march_tales_app/screens/RubricsListScreen.dart';
import 'package:march_tales_app/screens/TagsListScreen.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'RecentDetails.i18n.dart';

const double _sidePadding = 5;

final logger = Logger();

Widget _stats({
  required final RecentResults recentResults,
  required BuildContext context,
}) {
  final appState = context.watch<AppState>();
  final stats = recentResults.stats;
  final theme = Theme.of(context);
  final style = theme.textTheme.bodyMedium!;
  final AppColors appColors = theme.extension<AppColors>()!;
  final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
    alignment: AlignmentDirectional.centerStart,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: Size.zero,
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    textStyle: style,
    foregroundColor: appColors.brandColor,
    // side: BorderSide(width: 1.0, color: appColors.brandColor),
  );

  final navigatorState = navigatorKey.currentState;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 10,
    children: [
      Padding(
        padding: const EdgeInsets.all(_sidePadding),
        child: SectionTitle(
          text: 'In numbers'.i18n,
          // extraText: '(${count})',
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: _sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 0,
          children: [
            // Tracks button
            TextButton.icon(
              style: buttonStyle,
              onPressed: () {
                appState.updateNavigationTabIndex(HomePages.tracks.index);
                // Clear all the current (!) navigator routes in order to see the top tabs' content...
                navigatorState?.popUntil((Route<dynamic> route) {
                  return route.isFirst;
                });
              },
              icon: Icon(Icons.headphones, color: appColors.brandColor),
              label: Wrap(
                spacing: 5,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Total tracks:'.i18n,
                    style: style,
                  ),
                  Text(
                    stats.tracksCount.toString(),
                    style: style,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              style: buttonStyle,
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  AuthorsListScreen.routeName,
                  // arguments: arguments,
                );
              },
              icon: Icon(Icons.people, color: appColors.brandColor),
              label: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Total authors:'.i18n,
                    style: style,
                  ),
                  Text(
                    stats.authorsCount.toString(),
                    style: style,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              style: buttonStyle,
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  RubricsListScreen.routeName,
                );
              },
              icon: Icon(Icons.shelves, color: appColors.brandColor),
              label: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Total rubrics:'.i18n,
                    style: style,
                  ),
                  Text(
                    stats.rubricsCount.toString(),
                    style: style,
                  ),
                ],
              ),
            ),
            TextButton.icon(
              style: buttonStyle,
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  TagsListScreen.routeName,
                );
              },
              icon: Icon(Icons.tag, color: appColors.brandColor),
              label: Wrap(
                spacing: 5,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Total tags:'.i18n,
                    style: style,
                  ),
                  Text(
                    stats.tagsCount.toString(),
                    style: style,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

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
    logger.t('[RecentDetails:build] recentResults=${this.recentResults}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        _stats(recentResults: this.recentResults, context: context),
        _mostRecentTrack(recentResults: this.recentResults),
        _randomTrack(recentResults: this.recentResults),
        _popularTracks(recentResults: this.recentResults),
      ].nonNulls.toList(),
    );
  }
}
