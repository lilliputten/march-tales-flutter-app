import 'package:flutter/material.dart';

import 'package:hidable/hidable.dart';
import 'package:march_tales_app/core/constants/hidableDeltaFactor.dart';
import 'package:provider/provider.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/core/types/HomePageData.dart';
import 'package:march_tales_app/shared/states/AppState.dart';

class BottomNavigation extends StatelessWidget {
  final List<HomePageData> homePages;
  final int selectedIndex;
  final Function(int) handleIndex;
  const BottomNavigation({
    required this.homePages,
    required this.selectedIndex,
    required this.handleIndex,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    return Hidable(
      controller: appState.getLastScrollController(),
      preferredWidgetSize: const Size.fromHeight(82),
      enableOpacityAnimation: true, // optional, defaults to `true`.
      deltaFactor: hidableDeltaFactor,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixed
        selectedItemColor: appColors.brandColor, // colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: this.homePages.map((page) => BottomNavigationBarItem(icon: page.icon, label: page.label)).toList(),
        currentIndex: this.selectedIndex,
        onTap: (value) {
          this.handleIndex(value);
        },
      ),
    );
  }
}
