import 'package:flutter/material.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/core/constants/defaultThumbnailImageBorderRadius.dart';
import 'package:march_tales_app/core/constants/previewDimensionsRatio.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/ThumbnailImage.dart';

class TrackImageThumbnail extends StatelessWidget {
  const TrackImageThumbnail({
    super.key,
    required this.track,
    // One of two dimensions should be defined as a non-zero. If one of them is undefined (zer) then it'll be calculated based on ratio (`previewDimensionsRatio`) value.
    this.width = 0,
    this.height = 0,
    this.borderRadius = defaultThumbnailImageBorderRadius,
  });

  final Track track;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final String file = track.preview_picture;

    if (width == 0 && height == 0) {
      throw Exception('At least one dimension should be defined');
    }
    final imageWidth = width != 0 ? width : height * previewDimensionsRatio;
    final imageHeight = height != 0 ? height : width * previewDimensionsRatio;

    if (file.isEmpty) {
      return SizedBox(width: imageWidth, height: imageHeight);
    }
    final String url = '${AppConfig.TALES_SERVER_HOST}${file}_';
    return ThumbnailImage(url: url, width: imageWidth, height: imageHeight, borderRadius: borderRadius);
  }
}
