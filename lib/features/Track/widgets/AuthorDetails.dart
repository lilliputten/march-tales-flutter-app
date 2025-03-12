import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:logger/logger.dart';
import 'package:march_tales_app/screens/AuthorsListScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/CustomBackButton.dart';
import 'package:march_tales_app/components/CustomRouteButton.dart';
import 'package:march_tales_app/components/SectionTitle.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/RubricsInlineList.dart';
import 'package:march_tales_app/features/Track/widgets/SquareThumbnailImage.dart';
import 'package:march_tales_app/features/Track/widgets/TagsInlineList.dart';
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
    final style = theme.textTheme.bodyLarge!.copyWith(
      fontWeight: FontWeight.bold,
      color: textColor,
    );
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

const double sidePadding = 5;

class AuthorDetailsInfo extends StatelessWidget {
  const AuthorDetailsInfo({
    super.key,
    required this.author,
    this.fullView = false,
  });

  final Author author;
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
        AuthorImageThumbnail(author: author),
        SizedBox(height: 1),
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
                  RubricsInlineList(rubrics: author.rubrics, active: true),
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
                  TagsInlineList(tags: author.tags, active: true),
                ],
              ),
      ].nonNulls.toList(),
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
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: AuthorDetailsInfo(author: author, fullView: fullView),
        ),
        Padding(
          padding: const EdgeInsets.all(sidePadding),
          child: CustomRouteButton(
            text: 'All authors list'.i18n,
            routeName: AuthorsListScreen.routeName,
            arguments: null,
          ),
        ),
        // Show tracks list from `author.track_ids`
        author.track_ids.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.all(sidePadding),
                child: SectionTitle(text: '${"All author's tracks".i18n} (${author.track_ids.length})'),
              ),
        author.track_ids.isEmpty
            ? null
            : TracksListByIds(
                ids: author.track_ids,
                useScrollController: false,
                compact: true,
              ),
        Padding(
          padding: const EdgeInsets.all(sidePadding),
          child: CustomBackButton(),
        ),
      ].nonNulls.toList(),
    );
  }
}
