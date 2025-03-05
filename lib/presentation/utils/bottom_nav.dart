import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Ensures all icons and labels are visible
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.green, // Active tab color
      unselectedItemColor: Colors.grey, // Inactive tab color
      showUnselectedLabels: true, // Ensures unselected labels remain visible
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined), // Home icon
          activeIcon: Icon(Icons.home), // Filled icon when active
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings), // Settings/Gear icon for Services
          activeIcon: Icon(Icons.settings_applications), // More detailed settings icon
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined), // Shopping bag for Market
          activeIcon: Icon(Icons.shopping_bag), // Filled version when active
          label: 'Market',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline), // Profile icon
          activeIcon: Icon(Icons.person), // Filled profile icon when active
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rate_review_outlined), // Review icon
          activeIcon: Icon(Icons.rate_review), // Filled version when active
          label: 'Reviews',
        ),
      ],
    );
  }
}
