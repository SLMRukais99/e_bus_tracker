import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/signup.dart';
import 'package:e_bus_tracker/splash.dart';
import 'package:e_bus_tracker/tfauthentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splash',
    routes: {
      'splash': (context) => SplashScreenPage(),
      'login': (context) => Login(),
      'signup': (context) => SignUp(),
      'home': (context) => HomeScreen(),
      'tfauthentication': (context) => VerifyAccountScreen(),
    },
  ));
}
