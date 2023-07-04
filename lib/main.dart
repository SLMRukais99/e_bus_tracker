import 'package:e_bus_tracker/bus_operator_profile_page.dart';
import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/signup.dart';
import 'package:e_bus_tracker/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/home.dart';
import 'package:e_bus_tracker/user_profile_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'user_profile_page',
    routes: {
      
      'splash': (context) => SplashScreenPage(),
     'login': (context) => Login(),
      'signup': (context) => SignUp(),
      'home': (context) => HomeScreen(),
      'bus_operator_profile_page': (context) => BusOperatorProfileScreen(),
      'user_profile_page': (context) => UserProfileScreen(),
      
    },
  ));
}
