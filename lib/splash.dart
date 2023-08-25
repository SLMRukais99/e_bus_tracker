<<<<<<< Updated upstream
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.orange,
      ),
      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenPage extends StatelessWidget {
=======
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_bus_tracker/bostarttrip.dart';
import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/signup.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  startTimer() {
    Timer(const Duration(seconds: 5), () async {
      if (await _auth.currentUser != null) {
        //send user to home screen
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => BOStartTrip()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (c) => SignUp()));
      }
    });
  }

  void initState() {
    super.initState();

    startTimer();
  }

>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("Assets/Background.png"),
                  fit: BoxFit.cover,
                ),
              ),
<<<<<<< Updated upstream
            ),
            Positioned(
              bottom: 160, // adjust the position of the button as needed
              left: 85,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigate to Sign up page
                  },
                  child: Text('Sign up',
                      style: TextStyle(color:Colors.white,)
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 160,
              right: 85,
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Log in page
                  },
                  child: Text('Log in',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      )
                  ),
                ),
              ),
            ),
            Positioned(
=======
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
                    )
                  ],
                ),
              ),
            ),
            const Positioned(
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
=======
                      ),
                    ],
                  ),
                ],
>>>>>>> Stashed changes
              ),
            ),
          ],
        ),
      ),
    );
  }
}

