import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/RubricsInlineList.dart';
import 'package:march_tales_app/features/Track/widgets/TagsInlineList.dart';
import 'package:march_tales_app/features/Track/widgets/TrackAuthorImageThumbnail.dart';
import 'package:march_tales_app/screens/AuthorScreen.dart';
import 'TrackFullViewExtraBlock.i18n.dart';

final logger = Logger();

class TrackDescription extends StatelessWidget {
  const TrackDescription({
    super.key,
    required this.track,
  });
  final Track track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    return MarkdownBody(
      data: track.description,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        textAlign: WrapAlignment.start,
        a: TextStyle(
          color: appColors.brandColor,
        ),
      ),
      onTapLink: (text, url, title) {
        launchUrl(Uri.parse(url!));
      },
    );
  }
}

class TrackFullViewExtraBlock extends StatelessWidget {
  const TrackFullViewExtraBlock({
    super.key,
    required this.track,
  });
  final Track track;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.bodyMedium!;
    final double basicAlpha = 1;
    final double labelAlpha = basicAlpha / 2;
    final textColor = colorScheme.onSurface;
    final basicColorBase = textColor;
    final basicColor = basicColorBase;
    final labelColor = basicColor.withValues(alpha: labelAlpha);
    final textStyle = style.copyWith(color: basicColor);

    final items = [
      // Description
      AppConfig.LOCAL ? null : TrackDescription(track: track),
      // Author
      InkWell(
        onTap: () {
          Navigator.restorablePushNamed(
            context,
            AuthorScreen.routeName,
            arguments: track.author.id,
          );
        },
        child: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TrackAuthorImageThumbnail(
              track: track,
              size: 32,
            ),
            Text(track.author.name, style: textStyle),
          ],
        ),
      ),
      // Rubrics
      track.rubrics.isEmpty
          ? null
          : Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Rubrics:'.i18n, style: style.copyWith(color: labelColor)),
                RubricsInlineList(rubrics: track.rubrics, active: true),
              ],
            ),
      // Tags
      track.tags.isEmpty
          ? null
          : Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Tags:'.i18n, style: style.copyWith(color: labelColor)),
                TagsInlineList(tags: track.tags, active: true),
              ],
            ),
    ].nonNulls;

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.toList(),
    );
  }
}
