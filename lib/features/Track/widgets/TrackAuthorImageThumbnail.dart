import 'package:flutter/material.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Track.dart';
import 'package:march_tales_app/features/Track/widgets/SquareThumbnailImage.dart';

const double defaultTrackAuthorImageThumbnailBorderRadius = 24;

class TrackAuthorImageThumbnail extends StatelessWidget {
  const TrackAuthorImageThumbnail({
    super.key,
    required this.track,
    this.size = defaultTrackAuthorImageThumbnailBorderRadius,
    this.borderRadius = defaultTrackAuthorImageThumbnailBorderRadius / 2,
  });

  final Track track;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final String file = track.author.portrait_picture;
    if (file.isEmpty) {
      return SizedBox(width: size, height: size);
    }
    final String url = '${AppConfig.TALES_SERVER_HOST}${file}';
    return SquareThumbnailImage(url: url, size: size, borderRadius: borderRadius);
  }
}
