import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'SplashScreen.i18n.dart';

class SplashScreen extends StatefulWidget {
  // @override
  // SplashScreen createState() => _SplashScreen();
  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  // var animationController = AnimationController(duration: new Duration(seconds: 2), vsync: this);

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    final style = theme.textTheme.bodySmall!.copyWith(color: appColors.onBrandColor);
    const double size = 60.0;

    return Material(
      surfaceTintColor: Colors.red,
      child: ColoredBox(
        color: appColors.brandColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: animationController.drive(ColorTween(begin: Colors.blueAccent, end: Colors.red)),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Loading...'.i18n,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}
