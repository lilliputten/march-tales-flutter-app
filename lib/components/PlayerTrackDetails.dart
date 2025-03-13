import 'package:flutter/material.dart';

import 'package:logger/logger.dart';

import 'package:march_tales_app/core/helpers/formats.dart';

final logger = Logger();

class TrackTimes extends StatelessWidget {
  const TrackTimes({
    super.key,
    required this.duration,
    this.position,
  });
  final Duration duration;
  final Duration? position;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodySmall!;
    final double basicAlpha = 1;
    final double secondAlpha = basicAlpha / 2;
    final double thirdAlpha = basicAlpha / 4;
    final delimiterColor = textColor.withValues(alpha: thirdAlpha);
    final dimmedColor = textColor.withValues(alpha: secondAlpha);
    final textStyle = style.copyWith(color: dimmedColor);

    final showPosition = position == null
        ? Duration.zero
        : position! > duration
            ? duration
            : position!;

    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatDuration(showPosition),
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
        Text(
          '/',
          style: style.copyWith(color: delimiterColor),
        ),
        Text(
          formatDuration(duration),
          overflow: TextOverflow.ellipsis,
          style: textStyle,
        ),
      ],
    );
  }
}

class PlayerTrackDetails extends StatelessWidget {
  const PlayerTrackDetails({
    super.key,
    required this.title,
    required this.duration,
    this.position,
    this.onClick,
  });
  final String? title;
  final Duration duration;
  final Duration? position;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textColor = colorScheme.onSurface;
    final style = theme.textTheme.bodyMedium!;

    if (this.title == null) {
      return Container();
    }

    return InkWell(
      onTap: this.onClick,
      child: Column(
        spacing: 4,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.title!,
            overflow: TextOverflow.ellipsis,
            style: style.copyWith(color: textColor),
          ),
          TrackTimes(
            position: position,
            duration: duration,
          ),
        ],
      ),
    );
  }
}
