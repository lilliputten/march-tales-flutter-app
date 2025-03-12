import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:march_tales_app/shared/states/AppState.dart';

abstract class ScrollControlleProvider {
  const ScrollControlleProvider();

  ScrollController getScrollController();
}

@optionalTypeArgs
mixin ScrollControllerProviderMixin<T extends StatefulWidget> on State<T> implements ScrollControlleProvider {
  late final AppState _appState;
  final ScrollController _scrollController = new ScrollController();

  @override
  ScrollController getScrollController() {
    return this._scrollController;
  }

  @override
  void initState() {
    super.initState();
    this._appState = context.read<AppState>();
    Future.delayed(Duration.zero, () {
      this._appState.addScrollController(this._scrollController);
    });
  }

  @override
  void dispose() {
    Future.delayed(Duration.zero, () {
      this._appState.removeScrollController(this._scrollController);
    });
    super.dispose();
  }
}
