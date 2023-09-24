import 'dart:io';

import 'package:e_bus_tracker/bostarttrip.dart';
import 'package:e_bus_tracker/phone.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

class BusOperatorProfileScreen extends StatefulWidget {
  const BusOperatorProfileScreen({Key? key}) : super(key: key);

  @override
  State<BusOperatorProfileScreen> createState() =>
      _BusOperatorProfileScreenState();
}

class _BusOperatorProfileScreenState extends State<BusOperatorProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController routeController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController busnoController = TextEditingController();
  TextEditingController busNameController = TextEditingController();

  File? image; // Holds the selected image
  bool isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      // Generate a unique filename for each uploaded image
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload the image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('bus_operator_profile_images')
          .child(uniqueFileName);
      final uploadTask = storageRef.putFile(image);

      // Get the download URL
      final snapshot = await uploadTask;
      final downloadURL = await snapshot.ref.getDownloadURL();

      print('Image uploaded successfully. Download URL: $downloadURL');

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _saveUserProfile() async {
    final name = nameController.text;
    final route = routeController.text;
    final phoneNumber = phoneNoController.text;
    final email = emailController.text;
    final busNo = busnoController.text;
    final busName = busNameController.text;

    if (!_validatePhoneNumber(phoneNumber)) {
      showSnackBar('Invalid phone number');
      return;
    }

    if (!_validateEmail(email)) {
      showSnackBar('Invalid email address');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Upload the image
      String? downloadURL;
      if (image != null) {
        downloadURL = await _uploadImage(image!);
      }

      final FirebaseAuth _auth = FirebaseAuth.instance;

      // Add the bus operator profile data to Firestore
      final busOperatorProfileData = {
        'name': name,
        'route': route,
        'phoneNumber': phoneNumber,
        'email': email,
        'busNo': busNo,
        'busName': busName,
        'profileImageURL': downloadURL,
      };
      await FirebaseFirestore.instance
          .collection('busOperatorProfiles')
          .doc(_auth.currentUser!.uid)
          .set(busOperatorProfileData);

      setState(() {
        nameController.clear();
        routeController.clear();
        phoneNoController.clear();
        emailController.clear();
        busnoController.clear();
        busNameController.clear();
        image = null;
        isLoading = false;
      });

      // Navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BOStartTrip()),
      );
    } catch (e) {
      // Handle any errors that occur during saving
      print('Error saving user profile: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  bool _validatePhoneNumber(String value) {
    if (value.isEmpty) return false;
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(value);
  }

  bool _validateEmail(String value) {
    if (value.isEmpty) return false;
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(value);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    routeController.dispose();
    phoneNoController.dispose();
    emailController.dispose();
    busnoController.dispose();
    busNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bus Operator Profile'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          // Show image picker options
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text('Pick from Gallery'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Take a Photo'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF808080),
                          ),
                          child: Center(
                            child: image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: Image.file(
                                      image!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 23),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: busNameController,
                      decoration: InputDecoration(
                        labelText: 'Bus Name',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter Your Bus Name',
                        prefixIcon: Icon(
                          Icons.airport_shuttle,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: routeController,
                      decoration: InputDecoration(
                        labelText: 'Bus Route',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter the bus route',
                        prefixIcon: Icon(
                          Icons.route,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: busnoController,
                      decoration: InputDecoration(
                        labelText: 'Bus No',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter your bus number',
                        prefixIcon: Icon(
                          Icons.airport_shuttle_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: phoneNoController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: 'Phone No',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter your phone number',
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ButtonWidget(
                        title: "Submit",
                        onPress: () async {
                          final phoneNumber = phoneNoController.text;
                          final email = emailController.text;
                          if (_validatePhoneNumber(phoneNumber) &&
                              _validateEmail(email)) {
                            await _saveUserProfile();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TwoFactorAuthScreen()),
                            );
                          } else {
                            showSnackBar('Invalid phone number or email');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
