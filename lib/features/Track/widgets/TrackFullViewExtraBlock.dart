import 'package:flutter/material.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

class TrackFullViewExtraBlock extends StatelessWidget {
  const TrackFullViewExtraBlock({
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
