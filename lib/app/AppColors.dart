import 'package:flutter/material.dart';

import 'package:march_tales_app/core/config/AppConfig.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brandColor,
    required this.onBrandColor,
  });

  final Color brandColor;
  final Color onBrandColor;

  @override
  AppColors copyWith({Color? brandColor, Color? onBrandColor}) {
    return AppColors(
      brandColor: brandColor ?? this.brandColor,
      onBrandColor: onBrandColor ?? this.onBrandColor,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      brandColor: Color.lerp(brandColor, other.brandColor, t) ?? brandColor,
      onBrandColor:
          Color.lerp(onBrandColor, other.onBrandColor, t) ?? onBrandColor,
    );
  }

  @override
  String toString() =>
      'AppColors(brandColor: ${brandColor}, onBrandColor: ${onBrandColor})';
}

const appColors = AppColors(
  brandColor: Color(AppConfig.PRIMARY_COLOR),
  onBrandColor: Color(0xffffffff),
);
