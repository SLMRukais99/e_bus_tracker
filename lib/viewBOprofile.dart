import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_bus_tracker/bostarttrip.dart';
import 'package:e_bus_tracker/bus_operator_profile_page.dart';
import 'package:e_bus_tracker/login.dart';
import 'package:e_bus_tracker/ratings.dart';
import 'package:e_bus_tracker/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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

  String? image = '';
  String? name = '';
  String? route = '';
  String? busNo = '';
  String? phone = '';
  String? email = '';
<<<<<<< Updated upstream
  File? ImageXFile;
=======
  String? busName = '';
  File? imageXFile;
>>>>>>> Stashed changes

  Future _getDataFromFirestore() async {
    await FirebaseFirestore.instance
        .collection("busOperatorProfiles")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          image = snapshot.data()!["profileImageURL"];
          name = snapshot.data()!["name"];
          route = snapshot.data()!["route"];
          busNo = snapshot.data()!["busNo"];
          phone = snapshot.data()!["phoneNumber"];
          email = snapshot.data()!["email"];
        });

        // Download and cache the image locally if available
        /*if (image != null) {
          final imageFile = await _downloadImage(image!);
          setState(() {
            ImageXFile = imageFile;
          });
        }*/
      }
    });
  }

  Future<File?> _downloadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File('/path_to_local_image/image.jpg');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
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
                  .center, // Make elements stretch horizontally
              children: [
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    //showImageDialog
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.deepPurpleAccent,
                    minRadius: 70.0,
                    child: CircleAvatar(
                        radius: 63.0,
                        backgroundImage: ImageXFile == null
                            ? NetworkImage(image!)
                            : Image.file(ImageXFile!).image),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  'Name :' + name!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Bus Number :' + busNo!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Bus Route :' + route!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Phone Number:' + phone!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Email Address:' + email!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 65),
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
=======
        backgroundColor: Colors.deepPurple,
        title: Text("Profile"),
        actions: [],
      ),
      body: FutureBuilder(
          future: futuredata,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              // Handle the case where snapshot.data is null or not available
              return Text('No data available');
            } else {
              final data = snapshot.data as UserDetails;
              return ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
>>>>>>> Stashed changes
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Logout",
                          style: TextStyle(fontSize: 18),
                        ),
<<<<<<< Updated upstream
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
=======
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          (data.name ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Bus Name : ' + (data.busName ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Bus Number : ' + (data.busNo ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Bus Route : ' + (data.route ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Phone Number : ' + (data.phoneNumber ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Email Address : ' + (data.email ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 65),
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
              );
            }
          }),
>>>>>>> Stashed changes
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
