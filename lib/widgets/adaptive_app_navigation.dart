import 'package:flutter/material.dart';

import '../core/utils/responsive.dart';

/// Shared dashboard destinations for bottom nav and navigation rail.
class AppNavDestinations {
  static const Color railBg = Color.fromARGB(255, 5, 2, 56);
  static const Color selected = Color.fromARGB(255, 138, 8, 214);

  static const List<NavigationRailDestination> railDestinations = [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.school_outlined),
      selectedIcon: Icon(Icons.school),
      label: Text('Tutors'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.chat_outlined),
      selectedIcon: Icon(Icons.chat),
      label: Text('Chat'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
  ];

  static const List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Tutors'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];
}

/// Left navigation rail for tablet and desktop.
class DashboardNavigationRail extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  const DashboardNavigationRail({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final extended = Responsive.isDesktop(context);

    return NavigationRail(
      extended: extended,
      minExtendedWidth: 200,
      backgroundColor: AppNavDestinations.railBg,
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      selectedIconTheme: const IconThemeData(color: AppNavDestinations.selected),
      unselectedIconTheme: const IconThemeData(color: Colors.white70),
      selectedLabelTextStyle: const TextStyle(color: AppNavDestinations.selected),
      unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
      destinations: AppNavDestinations.railDestinations,
    );
  }
}
