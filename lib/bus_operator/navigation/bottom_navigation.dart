import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  BottomNavigation({
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: widget.onTabTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey[600],
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.schedule_rounded,
              size: 30,
            ),
            label: 'Bus Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_rounded,
              size: 30,
            ),
            label: 'Rate',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
