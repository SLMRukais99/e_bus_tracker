import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/signup.dart';
import 'package:e_bus_tracker/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splash',
    routes: {
      'splash': (context) => SplashScreenPage(),
      'login': (context) => Login(),
      'signup': (context) => SignUp(),
    },
  ));
}
