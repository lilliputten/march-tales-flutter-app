import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:march_tales_app/features/Track/widgets/TrackItemControl.dart';
import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/helpers/formats.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';

const double previewSize = 80;
const previewHalfSize = previewSize / 2;
const previewProgressPadding = previewHalfSize - 16;

final logger = Logger();

// NOTE: See theme info at: https://api.flutter.dev/flutter/material/ThemeData-class.html

class TrackItem extends StatelessWidget {
  const TrackItem({
    super.key,
    required this.track,
  });

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          trackImage(context, track),
          Expanded(
            flex: 1,
            child: trackDetails(context, track),
          ),
          TrackItemActiveControl(track: track),
        ],
      ),
    );
  }
}

Widget trackImage(BuildContext context, Track track) {
  final theme = Theme.of(context);
  final String url = '${AppConfig.TALES_SERVER_HOST}${track.preview_picture}';
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: CachedNetworkImage(
      imageUrl: url,
      // color: theme.primaryColor,
      width: previewSize,
      height: previewSize,
      fit: BoxFit.cover,
      placeholder: (context, url) => Padding(
        padding: const EdgeInsets.all(previewProgressPadding),
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error,
          color: theme.primaryColor.withValues(alpha: 0.5),
          size: previewHalfSize),
    ),
  );
}

Widget trackDetailsInfo(BuildContext context, Track track) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  // final AppColors appColors = theme.extension<AppColors>()!;
  // final dimmedColor = appColors.brandColor.withValues(alpha: 0.5);
  final dimmedColor = colorScheme.primary.withValues(alpha: 0.25);
  final delimiterColor = colorScheme.onSurface.withValues(alpha: 0.1);
  final style = theme.textTheme.bodySmall!;
  final items = [
    // Author
    Wrap(spacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
      // TODO: Render an author image
      // Icon(
      //   Icons.mode_edit,
      //   size: style.fontSize,
      //   color: dimmedColor,
      // ),
      Text(track.author.name, style: style),
    ]),
    // Played count
    track.played_count == 0
        ? null
        : Wrap(
            spacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
                Icon(
                  Icons.headphones_outlined,
                  size: style.fontSize,
                  color: dimmedColor,
                ),
                Text(track.played_count.toString(), style: style),
              ]),
    // Duration
    Wrap(spacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
      Icon(
        Icons.watch_later_outlined,
        size: style.fontSize,
        color: dimmedColor,
      ),
      Text(formatSecondsDuration(track.audio_duration), style: style),
    ]),
    // Date
    Wrap(spacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
      Icon(
        Icons.calendar_month,
        size: style.fontSize,
        color: dimmedColor,
      ),
      Text(
          formatDate(
              DateTime.parse(track.published_at), context.locale.languageCode),
          style: style),
    ]),
    // Rubrics
    track.rubrics.isEmpty
        ? null
        : Wrap(
            spacing: 3,
            children: track.rubrics.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: delimiterColor, width: 1),
                ),
                child: Text(tag.text, style: style),
              );
            }).toList()),
    // Tags
    track.tags.isEmpty
        ? null
        : Wrap(
            spacing: 3,
            children: track.tags.map((tag) {
              return Wrap(spacing: 2, children: [
                Text('#', style: style.copyWith(color: dimmedColor)),
                Text(tag.text, style: style),
              ]);
            }).toList()),
  ].nonNulls;
  // Add delimiters between each other item
  final delimiter = Text('|', style: style.copyWith(color: delimiterColor));
  final delimitedItems =
      items.map((e) => [delimiter, e]).expand((e) => e).skip(1);
  return Wrap(
    spacing: 4,
    runSpacing: 2,
    crossAxisAlignment: WrapCrossAlignment.center,
    // runAlignment: WrapAlignment.center,
    children: delimitedItems.toList(),
  );
}

Widget trackTitle(BuildContext context, Track track) {
  final theme = Theme.of(context);
  final style = theme.textTheme.bodyLarge!;
  return Text(track.title, style: style);
}

Widget trackDetails(BuildContext context, Track track) {
  return Column(
    spacing: 8,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      trackTitle(context, track),
      trackDetailsInfo(context, track),
    ],
  );
}
