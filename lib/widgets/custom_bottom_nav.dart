
import 'package:flutter/material.dart';

import 'adaptive_app_navigation.dart';

class BottomNavWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      type: BottomNavigationBarType.fixed,

      backgroundColor: AppNavDestinations.railBg,
      selectedItemColor: AppNavDestinations.selected,
      unselectedItemColor: Colors.white,
      items: AppNavDestinations.bottomItems,
    );
  }
}