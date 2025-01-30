import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

// import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/core/helpers/formats.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/TrackAuthorImageThumbnail.dart';

class TrackDetailsInfo extends StatelessWidget {
  const TrackDetailsInfo({
    super.key,
    required this.track,
    this.isActive = false,
    this.textColor,
  });
  final Track track;
  final bool isActive;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final AppColors appColors = theme.extension<AppColors>()!;
    // final dimmedColor = appColors.brandColor.withValues(alpha: 0.5);
    final style = theme.textTheme.bodySmall!;
    final basicColor =
        textColor ?? (isActive ? colorScheme.primary : colorScheme.onSurface);
    final dimmedColor = basicColor.withValues(alpha: 0.25);
    final delimiterColor = basicColor.withValues(alpha: 0.1);
    final textStyle = style.copyWith(color: basicColor);
    final items = [
      // Author
      Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            TrackAuthorImageThumbnail(track: track),
            Text(track.author.name, style: textStyle),
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
                  Text(track.played_count.toString(), style: textStyle),
                ]),
      // Duration
      Wrap(
          spacing: 2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.watch_later_outlined,
              size: style.fontSize,
              color: dimmedColor,
            ),
            Text(formatSecondsDuration(track.audio_duration), style: textStyle),
          ]),
      // Date
      Wrap(
          spacing: 2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              size: style.fontSize,
              color: dimmedColor,
            ),
            Text(
                formatDate(DateTime.parse(track.published_at),
                    context.locale.languageCode),
                style: textStyle),
          ]),
      // Rubrics
      track.rubrics.isEmpty
          ? null
          : Wrap(
              spacing: 3,
              children: track.rubrics.map((tag) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: delimiterColor, width: 1),
                  ),
                  child: Text(tag.text, style: textStyle),
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
                  Text(tag.text, style: textStyle),
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
}
