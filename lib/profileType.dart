import 'package:e_bus_tracker/bostarttrip.dart';
import 'package:e_bus_tracker/bus_operator_profile_page.dart';
import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/ratings.dart';
import 'package:e_bus_tracker/services/firebase_services.dart';
import 'package:e_bus_tracker/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'bus_shedule.dart';
import 'navigation/bottom_navigation.dart';

class ProfileTypeScreen extends StatefulWidget {
  const ProfileTypeScreen({super.key});

  @override
  State<ProfileTypeScreen> createState() => _ProfileTypeScreenState();
}

class _ProfileTypeScreenState extends State<ProfileTypeScreen> {
  int _currentIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text("Profile"),
          actions: []),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 45.0), // Reduce horizontal padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Make elements stretch horizontally
              children: [
                SizedBox(height: 65), // Add space between boxes and Next button
                Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Handle next button press
                        await FirebaseServices().signOutUser();
                        FirebaseAuth.instance.signOut().then((value) {
                          print("Signed Out");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTabTapped: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              // Navigate to home
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BOStartTrip(),
                ),
              );
            } else if (index == 1) {
              // Navigate to schedule
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BusScheduleScreen(),
                ),
              );
            } else if (index == 2) {
              // Navigate to star
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RatingScreen(),
                ),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileTypeScreen(),
                ),
              );
            }
          });
        },
      ),
    );
  }
}
