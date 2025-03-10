import 'package:flutter/material.dart';

import 'package:hidable/hidable.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/core/constants/hidableDeltaFactor.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

class HidableWrapper extends StatelessWidget {
  const HidableWrapper({
    super.key,
    this.wrap = true,
    required this.widgetSize,
    required this.child,
  });

  final bool wrap;
  final double widgetSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (!this.wrap) {
      return this.child;
    }
    return Hidable(
      controller: appState.getLastScrollController(),
      preferredWidgetSize: Size.fromHeight(this.widgetSize),
      deltaFactor: hidableDeltaFactor,
      child: this.child,
    );
  }
}
