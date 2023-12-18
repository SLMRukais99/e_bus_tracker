import 'package:e_bus_tracker/model/passenger.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/services/getuserauth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // Add this import for rootBundle

import '../model/user.dart';

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
    data = UserDetailsP();
    _selectedImage =
        data.profileImageURL != null && data.profileImageURL!.isNotEmpty
            ? File(data.profileImageURL!)
            : File('assets/images/placeholder_image.png');
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
                          onPressed: () {
                            // Implement logic to update profile in Firestore
                            // You may want to call a function from your AuthService
                            // to handle the update operation.
                            /*AuthService().updateProfile(
                            UserDetails(
                              profileImageURL:
                                  _selectedImage != null ? 'URL' : data.profileImageURL,
                              name: _busNameController.text,
                              route: _routeController.text,
                              busNo: _busNoController.text,
                              phoneNumber: _phoneController.text,
                              email: _emailController.text,
                            ),
                          );*/
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
