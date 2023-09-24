import 'dart:io';
import 'package:e_bus_tracker/model/user.dart';
import 'package:e_bus_tracker/services/getuserauth.dart';
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

  late Future<UserDetails> futuredata;

  String? image = '';
  String? name = '';
  String? route = '';
  String? busNo = '';
  String? phone = '';
  String? email = '';
  String? busName = '';
  File? imageXFile;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    futuredata = AuthService().getBusOperatorProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseServices().signOutUser();
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              });
            },
          ),
        ],
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
                          height: 28,
                        ),
                        GestureDetector(
                          onTap: () {
                            //showImageDialog
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            minRadius: 70.0,
                            child: CircleAvatar(
                              radius: 67.0,
                              backgroundImage: imageXFile == null
                                  ? (data.profileImageURL != null &&
                                          data.profileImageURL!.isNotEmpty
                                      ? NetworkImage(data.profileImageURL!)
                                      : AssetImage(
                                              'assets/images/placeholder_image.png')
                                          as ImageProvider)
                                  : Image.file(imageXFile!).image,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          (data.name ?? ''),
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 2.0,
                          )),
                          child: Row(
                            children: [
                              Text(
                                'Bus Name : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data.busName ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 2.0,
                          )),
                          child: Row(
                            children: [
                              Text(
                                'Bus Number : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data.busNo ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 2.0,
                          )),
                          child: Row(
                            children: [
                              Text(
                                'Bus Route : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data.route ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 2.0,
                          )),
                          child: Row(
                            children: [
                              Text(
                                'Phone : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data.phoneNumber ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 2.0,
                          )),
                          child: Row(
                            children: [
                              Text(
                                'Email : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  data.email ?? '',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        const SizedBox(height: 30),
                        Container(
                          width: 300.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BusOperatorProfileScreen()));*/
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "Edit",
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
