import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/shared/states/AppState.dart';
import 'CustomBackButton.i18n.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.isRoot = false,
  });

  final bool isRoot;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
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
        if (isRoot) {
          appState.updateNavigationTabIndex(0);
          // Clear all the current (!) navigator routes in order to see the top tabs' content...
          Navigator.popUntil(context, (Route<dynamic> route) {
            return route.isFirst;
          });
        } else {
          Navigator.pop(context);
        }
      },
      icon: Icon(Icons.arrow_back_rounded, color: appColors.brandColor),
      label: Text('Back'.i18n),
    );
  }
}
