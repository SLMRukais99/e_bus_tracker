import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/bus_operator_profile_page.dart';
import 'package:e_bus_tracker/user_profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToBusOperatorProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BusOperatorProfileScreen()),
    );
  }

  void navigateToUserProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to E-Bus Tracker",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            ElevatedButton(
              onPressed: navigateToBusOperatorProfilePage,
              child: Text("Bus Operator Profile"),
            ),
            ElevatedButton(
              onPressed: navigateToUserProfilePage,
              child: Text("User Profile"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.pushNamed(context, 'login');
                });
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
