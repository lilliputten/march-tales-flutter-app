import 'package:flutter/material.dart';

import 'package:march_tales_app/app/AppColors.dart';
import 'package:march_tales_app/components/HidableWrapper.dart';
import 'package:march_tales_app/core/types/HomePageData.dart';

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
    final theme = Theme.of(context);
    final AppColors appColors = theme.extension<AppColors>()!;

    return HidableWrapper(
      widgetSize: 82,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: appColors.brandColor,
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
