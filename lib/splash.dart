import 'dart:async';
import 'package:e_bus_tracker/bus_operator/bostarttrip.dart';
import 'package:e_bus_tracker/passenger/passengerhome.dart';
import 'package:e_bus_tracker/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore instance

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (_auth.currentUser != null) {
        // Fetch user role from Firestore
        DocumentSnapshot userSnapshot = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();

        if (userSnapshot.exists) {
          String userRole = userSnapshot.get('role');

          // Navigate based on user role
          if (userRole == 'passenger') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      PassengerHomeScreen()), // Replace with passenger home page
            );
          } else if (userRole == 'busOperator') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      BOStartTrip()), // Replace with bus operator home page
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => SignUp()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => SignUp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Beyond Maps, Your Live Bus Guide!",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 101, 43, 108),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'By Continuing, you agree with our',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Terms of Service ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'and ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
