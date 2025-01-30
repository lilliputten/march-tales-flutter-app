import 'package:flutter/material.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/SquareThumbnailImage.dart';

class TrackImageThumbnail extends StatelessWidget {
  const TrackImageThumbnail({
    super.key,
    required this.track,
    required this.size,
    this.borderRadius = defaultSquareThumbnailImageBorderRadius,
  });

  final Track track;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final String file = track.preview_picture;
    if (file.isEmpty) {
      return SizedBox(width: size, height: size);
    }
    final String url = '${AppConfig.TALES_SERVER_HOST}${file}';
    return SquareThumbnailImage(
        url: url, size: size, borderRadius: borderRadius);
  }
}
