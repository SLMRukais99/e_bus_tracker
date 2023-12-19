import 'package:e_bus_tracker/model/passenger.dart';
import 'package:e_bus_tracker/passenger/view_Passenger_Profile.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/services/getuserauth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PassengerProfileEditScreen extends StatefulWidget {
  const PassengerProfileEditScreen({Key? key}) : super(key: key);

  @override
  _PassengerProfileEditScreenState createState() =>
      _PassengerProfileEditScreenState();
}

class _PassengerProfileEditScreenState
    extends State<PassengerProfileEditScreen> {
  late Future<UserDetailsP> futureData;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  late UserDetailsP data;

  late File _selectedImage;

  get imageXFile => null;

  get as => null;

  @override
  void initState() {
    futureData = AuthService().getUserProfile();
    super.initState();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    await AuthService().updatePassengerProfile(
      UserDetailsP(
        profileImageURL: _selectedImage != null
            ? 'gs://e-bus-tracker-e6623.appspot.com/user_profile_images' // Replace 'URL' with the actual URL or upload to Firestore Storage
            : data.profileImageURL,
        name: _nameController.text,
        homeAddress: _addressController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
      ),
    );

    // After updating, refresh the data and show it on the screen
    setState(() {
      futureData = AuthService().getUserProfile();
    });
  }

  void _navigateToProfileScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProfileTypeScreenP(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Text('No data available');
            } else {
              data = snapshot.data as UserDetailsP;
              _nameController.text = data.name ?? '';
              _addressController.text = data.homeAddress ?? '';
              _phoneController.text = data.phoneNumber ?? '';
              _emailController.text = data.email ?? '';
              _selectedImage = File(data.profileImageURL ??
                  'assets/images/placeholder_image.png');

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
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
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: _pickImage,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Home Address',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedImage != null) {
                              await _updateProfile();
                              _navigateToProfileScreen();
                            } else {
                              // Handle the case when no image is selected
                              print('No image selected');
                            }
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
                              "Save Changes",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
