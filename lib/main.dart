import 'package:e_bus_tracker/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/bus_shedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'bus_shedule',
      routes: {
        'bus_shedule': (context) => BusScheduleScreen(),
      },
    ),
  ));
}
