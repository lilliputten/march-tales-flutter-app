import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/RubricsLinileList.dart';
import 'package:march_tales_app/features/Track/widgets/SquareThumbnailImage.dart';
import 'package:march_tales_app/features/Track/widgets/TagsLinileList.dart';
import 'package:march_tales_app/features/Track/widgets/TracksListByIds.dart';
import 'AuthorDetails.i18n.dart';

final logger = Logger();

class AuthorTitle extends StatelessWidget {
  const AuthorTitle({
    super.key,
    required this.author,
  });
  final Author author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodyLarge!.copyWith(color: textColor);
    String text = author.name;
    if (AppConfig.LOCAL) {
      text += ' (${author.id})';
    }
    return Text(text, style: style);
  }
}

class AuthorDescription extends StatelessWidget {
  const AuthorDescription({
    super.key,
    required this.author,
  });
  final Author author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    return MarkdownBody(
      data: author.description,
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

class AuthorImageThumbnail extends StatelessWidget {
  const AuthorImageThumbnail({
    super.key,
    required this.author,
    this.size = 200,
    this.borderRadius,
  });

  final Author author;
  final double size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final String file = author.portrait_picture;
    if (file.isEmpty) {
      return SizedBox(width: this.size, height: this.size);
    }
    final String url = '${AppConfig.TALES_SERVER_HOST}${file}';
    return SquareThumbnailImage(
      url: url,
      size: this.size,
      borderRadius: this.borderRadius ?? this.size / 2,
    );
  }
}

class AuthorDetails extends StatelessWidget {
  const AuthorDetails({
    super.key,
    required this.author,
    this.fullView = false,
  });

  final Author author;
  final bool fullView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final colorScheme = theme.colorScheme;
    final style = theme.textTheme.bodyMedium!;
    final double basicAlpha = 1; // isAlreadyPlayed ? 0.3 : 1;
    final double labelAlpha = basicAlpha / 2;
    final textColor = colorScheme.onSurface;
    final labelColor = textColor.withValues(alpha: labelAlpha);
    final headerStyle = theme.textTheme.bodyLarge!.copyWith(color: appColors.brandColor);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthorImageThumbnail(author: author),
        AuthorTitle(author: author),
        AuthorDescription(author: author),
        // Rubrics
        author.rubrics.isEmpty
            ? null
            : Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Rubrics:'.i18n, style: style.copyWith(color: labelColor)),
                  RubricsLinileList(rubrics: author.rubrics, active: true),
                ],
              ),
        // Tags
        author.tags.isEmpty
            ? null
            : Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Tags:'.i18n, style: style.copyWith(color: labelColor)),
                  TagsLinileList(tags: author.tags, active: true),
                ],
              ),
        // TODO: Show tracks list from `author.track_ids`
        Padding(
          // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text("All author's tracks".i18n, style: headerStyle),
        ),
        TracksListByIds(
          ids: author.track_ids,
          useScrollController: false,
        ),
      ].nonNulls.toList(),
    );
  }
}
