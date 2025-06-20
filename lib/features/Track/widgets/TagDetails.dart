import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/blocks/SectionTitle.dart';
import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/CustomRouteButton.dart';
import 'package:march_tales_app/components/data-driven/ShowTracksListBlockLoader.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Tag.dart';
import 'package:march_tales_app/features/Track/widgets/RubricsInlineList.dart';
import 'package:march_tales_app/screens/TagsListScreen.dart';
import 'TagDetails.i18n.dart';

final logger = Logger();

const double sidePadding = 5;

class TagTitle extends StatelessWidget {
  const TagTitle({
    super.key,
    required this.tag,
  });
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: textColor,
    );
    String text = tag.text;
    if (AppConfig.LOCAL) {
      text += ' (${tag.id})';
    }
    return Text(text, style: style);
  }
}

class TagDetailsInfo extends StatelessWidget {
  const TagDetailsInfo({
    super.key,
    required this.tag,
    this.fullView = false,
  });

  final Tag tag;
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
          prefixText: 'Tag'.i18n.toUpperCase(),
          text: tag.text,
        ),
        SizedBox(height: 1),
        // Tags
        tag.rubrics.isEmpty
            ? null
            : Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Rubrics:'.i18n, style: style.copyWith(color: labelColor)),
                  RubricsInlineList(rubrics: tag.rubrics, active: true),
                ],
              ),
      ].nonNulls.toList(),
    );
  }
}

class TagDetails extends StatelessWidget {
  const TagDetails({
    super.key,
    required this.tag,
    this.fullView = false,
  });

  final Tag tag;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: TagDetailsInfo(tag: tag, fullView: fullView),
        ),
        Padding(
          padding: const EdgeInsets.all(sidePadding),
          child: CustomRouteButton(
            text: 'All tags'.i18n,
            routeName: TagsListScreen.routeName,
            arguments: null,
          ),
        ),
        // Show tracks list from `author.track_ids`
        ShowTracksListBlockLoader(
          query: '?filter=tag__id:${tag.id}',
          title: "All tag's tracks".i18n,
        ),
        Padding(
          padding: const EdgeInsets.all(sidePadding),
          child: CustomBackButton(),
        ),
      ].nonNulls.toList(),
    );
  }
}
