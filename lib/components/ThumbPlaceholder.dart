import 'package:flutter/material.dart';

import 'package:march_tales_app/core/constants/defaultThumbnailImageBorderRadius.dart';

class ThumbPlaceholder extends StatelessWidget {
  const ThumbPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.color = Colors.grey,
    this.alpha = 0.25,
    this.borderRadius = defaultThumbnailImageBorderRadius,
  });

  final double width;
  final double height;
  final Color color;
  final double alpha;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: Container(
          decoration: new BoxDecoration(
            color: color.withValues(alpha: alpha),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
