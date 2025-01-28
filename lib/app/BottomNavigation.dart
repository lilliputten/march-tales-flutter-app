import 'package:flutter/material.dart';

import 'homePages.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) handleIndex;
  const BottomNavigation({
    required this.selectedIndex,
    required this.handleIndex,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Fixed

      backgroundColor: Colors.black,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.grey,

      // showUnselectedLabels: true,
      // showSelectedLabels: false,

      items: homePages
          .map((page) =>
              BottomNavigationBarItem(icon: page.icon, label: page.label))
          .toList(),
      // currentIndex: _selectedIndex,
      currentIndex: selectedIndex,
      onTap: (value) {
        handleIndex(value);
        // setState(() {
        //   // _selectedIndex = value;
        //   _selectedIndex.value = value;
        // });
      },
    );
  }
}
