import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:march_tales_app/components/ThumbPlaceholder.dart';
import 'package:march_tales_app/core/constants/defaultThumbnailImageBorderRadius.dart';
import 'package:march_tales_app/core/constants/previewDimensionsRatio.dart';

// import 'package:march_tales_app/app/AppColors.dart';

class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({
    super.key,
    required this.url,
    // One of two dimensions should be defined as a non-zero. If one of them is undefined (zer) then it'll be calculated based on ratio (`previewDimensionsRatio`) value.
    this.width = 0,
    this.height = 0,
    this.borderRadius = defaultThumbnailImageBorderRadius,
  });

  final String url;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final AppColors appColors = theme.extension<AppColors>()!;

    if (width == 0 && height == 0) {
      throw Exception('At least one dimension should be defined');
    }
    final imageWidth = width != 0 ? width : height * previewDimensionsRatio;
    final imageHeight = height != 0 ? height : width / previewDimensionsRatio;

    // final previewHalfSize = min(imageWidth, imageHeight) / 2;
    // final previewProgressPadding = previewHalfSize / 2; // - 16;

    final placeholder = ThumbPlaceholder(width: imageWidth, height: imageHeight);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url,
        // color: theme.primaryColor,
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
        // placeholder: (context, url) => Padding(
        //   padding: EdgeInsets.all(previewProgressPadding),
        //   child: CircularProgressIndicator(strokeWidth: 1, color: appColors.brandColor),
        // ),
        // errorWidget: (context, url, error) =>
        //     Icon(Icons.error, color: theme.primaryColor.withValues(alpha: 0.5), size: previewHalfSize),
      ),
    );
  }
}
