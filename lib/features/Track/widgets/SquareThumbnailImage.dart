import 'package:flutter/material.dart';

import 'package:march_tales_app/core/constants/defaultThumbnailImageBorderRadius.dart';
import 'package:march_tales_app/features/Track/widgets/ThumbnailImage.dart';

class SquareThumbnailImage extends StatelessWidget {
  const SquareThumbnailImage({
    super.key,
    required this.url,
    required this.size,
    this.borderRadius = defaultThumbnailImageBorderRadius,
  });

  final String url;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ThumbnailImage(url: url, borderRadius: borderRadius, width: size, height: size);
  }
}
