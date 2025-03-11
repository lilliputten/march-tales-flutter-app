import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';

class CustomRouteButton extends StatelessWidget {
  const CustomRouteButton({
    super.key,
    required this.text,
    required this.routeName,
    required this.arguments,
    this.icon = Icons.more,
  });

  final String text;
  final String routeName;
  final dynamic arguments;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;
    final style = theme.textTheme.bodyMedium!.copyWith(color: appColors.brandColor);
    final ButtonStyle buttonStyle = OutlinedButton.styleFrom(
      textStyle: style,
      foregroundColor: appColors.brandColor,
      side: BorderSide(width: 1.0, color: appColors.brandColor),
    );
    return OutlinedButton.icon(
      style: buttonStyle,
      onPressed: () {
        Navigator.restorablePushNamed(
          context,
          routeName,
          arguments: arguments,
        );
      },
      icon: Icon(icon, color: appColors.brandColor),
      label: Text(text),
    );
  }
}
