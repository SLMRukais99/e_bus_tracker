import 'dart:io';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';



class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
    // Upload the image to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('user_profile_images').child('image.jpg');
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
    final homeAddress = homeController.text;
    final phoneNumber = phoneNoController.text;
    final email = emailController.text;

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

      // Add the user profile data to Firestore
      final userProfileData = {
        'name': name,
        'homeAddress': homeAddress,
        'phoneNumber': phoneNumber,
        'email': email,
        'profileImageURL': downloadURL,
      };
 await FirebaseFirestore.instance.collection('userProfiles').add(userProfileData);
      
      setState(() {
        nameController.clear();
        homeController.clear();
        phoneNoController.clear();
        emailController.clear();
        image = null;
        isLoading = false;
      });

      Navigator.pushReplacementNamed(context, 'home');
    } catch (e) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.deepPurple,
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
                      controller: homeController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter your home address',
                        prefixIcon: Icon(
                          Icons.home_outlined,
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
                    SizedBox(height: 16.0),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),
                        hintText: 'Enter your home email',
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
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: isLoading ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 200),
                            child: ButtonWidget(
                              title: "Submit",
                              onPress: () async {
                                final phoneNumber = phoneNoController.text;
                                final email = emailController.text;
                                if (_validatePhoneNumber(phoneNumber) && _validateEmail(email)) {
                                  await _saveUserProfile();
                                } else {
                                  showSnackBar('Invalid phone number or email');
                                }
                              },
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: isLoading ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                              ),
                            ),
                          ),
                        ],
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
