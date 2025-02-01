import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

const double previewSize = 80;

const double defaultSquareThumbnailImageBorderRadius = 10;

class SquareThumbnailImage extends StatelessWidget {
  const SquareThumbnailImage({
    super.key,
    required this.url,
    required this.size,
    this.borderRadius = defaultSquareThumbnailImageBorderRadius,
  });

  final String url;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    // final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    final previewHalfSize = size / 2;
    final previewProgressPadding = previewHalfSize / 2; // - 16;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        // color: theme.primaryColor,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Padding(
          padding: EdgeInsets.all(previewProgressPadding),
          child: CircularProgressIndicator(strokeWidth: 1),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error,
            color: theme.primaryColor.withValues(alpha: 0.5),
            size: previewHalfSize),
      ),
    );
  }
}
