import 'package:flutter/material.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';
import 'package:march_tales_app/features/Track/types/Author.dart';
import 'package:march_tales_app/features/Track/widgets/SquareThumbnailImage.dart';

class AuthorImageThumbnail extends StatelessWidget {
  const AuthorImageThumbnail({
    super.key,
    required this.author,
    this.size = 200,
    this.borderRadius,
  });

  final Author author;
  final double size;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final String file = author.portrait_picture;
    if (file.isEmpty) {
      return SizedBox(width: this.size, height: this.size);
    }
    final String url = '${AppConfig.TALES_SERVER_HOST}${file}';
    return SquareThumbnailImage(
      url: url,
      size: this.size,
      borderRadius: this.borderRadius ?? this.size / 2,
    );
  }
}
