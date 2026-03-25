import 'package:flutter/material.dart';

class AppNavbar extends StatelessWidget {
  /// Currently selected tab
  final int currentIndex;

  /// Callback for tab taps
  final void Function(int) onTap;

  const AppNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      animationDuration: const Duration(milliseconds: 300),
      height: 70,
      labelBehavior:
          NavigationDestinationLabelBehavior.alwaysShow, // Material 3 tweak
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: "Search",
        ),
        NavigationDestination(
          icon: Icon(Icons.speed_outlined),
          selectedIcon: Icon(Icons.speed),
          label: "Odometer",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "Profile",
        ),
        // Future: Location tab
        // NavigationDestination(
        //   icon: Icon(Icons.location_on_outlined),
        //   selectedIcon: Icon(Icons.location_on),
        //   label: "Location",
        // ),
      ],
    );
  }
}
