import 'package:flutter/material.dart';

import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/constants/hidableDeltaFactor.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

class HidableWrapper extends StatelessWidget {
  const HidableWrapper({
    super.key,
    this.wrap = true,
    this.show = true,
    this.bypass = false,
    required this.widgetSize,
    required this.child,
  });

  /// Only wrap the content -- it'll be always vusuke
  final bool wrap;
  final bool show;
  final bool bypass;
  final double widgetSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (this.bypass) {
      return this.child;
    }
    if (!this.show) {
      return SizedBox();
    }
    if (!this.wrap) {
      return SizedBox(
        height: this.widgetSize,
        child: this.child,
      );
    }
    return Hidable(
      controller: appState.getLastScrollController(),
      preferredWidgetSize: Size.fromHeight(this.widgetSize),
      deltaFactor: hidableDeltaFactor,
      child: this.child,
    );
  }
}
