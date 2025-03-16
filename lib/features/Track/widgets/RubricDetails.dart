import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/CustomRouteButton.dart';
import 'package:march_tales_app/components/SectionTitle.dart';
import 'package:march_tales_app/components/data-driven/ShowTracksListBlockLoader.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Rubric.dart';
import 'package:march_tales_app/features/Track/widgets/TagsInlineList.dart';
import 'package:march_tales_app/screens/RubricsListScreen.dart';
import 'RubricDetails.i18n.dart';

final logger = Logger();

const double sidePadding = 5;

class RubricTitle extends StatelessWidget {
  const RubricTitle({
    super.key,
    required this.rubric,
  });
  final Rubric rubric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: textColor,
    );
    String text = rubric.text;
    if (AppConfig.LOCAL) {
      text += ' (${rubric.id})';
    }
    return Text(text, style: style);
  }
}

class RubricDetailsInfo extends StatelessWidget {
  const RubricDetailsInfo({
    super.key,
    required this.rubric,
    this.fullView = false,
  });

  final Rubric rubric;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.bodyMedium!;
    final double basicAlpha = 1;
    final double labelAlpha = basicAlpha / 2;
    final textColor = colorScheme.onSurface;
    final labelColor = textColor.withValues(alpha: labelAlpha);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          prefixText: 'Rubric'.i18n.toUpperCase(),
          text: rubric.text,
        ),
        SizedBox(height: 1),
        // RubricTitle(rubric: rubric),
        /* // Authors
        rubric.authors.isEmpty
            ? null
            : Wrap(
                spacing: 10,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  Text('Authors:'.i18n, style: style.copyWith(color: labelColor)),
                  AuthorsInlineList(authors: rubric.authors, active: true, compact: true),
                ],
              ),
        */
        // Tags
        rubric.tags.isEmpty
            ? null
            : Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Tags:'.i18n, style: style.copyWith(color: labelColor)),
                  TagsInlineList(tags: rubric.tags, active: true),
                ],
              ),
      ].nonNulls.toList(),
    );
  }
}

class RubricDetails extends StatelessWidget {
  const RubricDetails({
    super.key,
    required this.rubric,
    this.fullView = false,
  });

  final Rubric rubric;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: RubricDetailsInfo(rubric: rubric, fullView: fullView),
        ),
        Padding(
          padding: const EdgeInsets.all(sidePadding),
          child: CustomRouteButton(
            text: 'All rubrics list'.i18n,
            routeName: RubricsListScreen.routeName,
            arguments: null,
          ),
        ),
        // Show tracks list from `author.track_ids`
        ShowTracksListBlockLoader(
          query: '?filter=rubric__id:${rubric.id}',
          title: "All rubric's tracks".i18n,
        ),
        Padding(
          padding: const EdgeInsets.all(sidePadding),
          child: CustomBackButton(),
        ),
      ].nonNulls.toList(),
    );
  }
}
