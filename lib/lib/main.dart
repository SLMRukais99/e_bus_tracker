import 'package:flutter/material.dart';
import 'package:testing_project/login.dart';
import 'package:testing_project/signup.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => Login(),
      'signup': (context) => SignUp(),
    },
  ));
}
