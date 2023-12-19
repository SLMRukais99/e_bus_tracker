import 'package:e_bus_tracker/bus_operator/viewBOprofile.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/services/getuserauth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../model/busoperator.dart';

class BusOperatorProfileEditScreen extends StatefulWidget {
  const BusOperatorProfileEditScreen({Key? key}) : super(key: key);

  @override
  _BusOperatorProfileEditScreenState createState() =>
      _BusOperatorProfileEditScreenState();
}

class _BusOperatorProfileEditScreenState
    extends State<BusOperatorProfileEditScreen> {
  late Future<UserDetails> futureData;

  TextEditingController _busNameController = TextEditingController();
  TextEditingController _busNoController = TextEditingController();
  TextEditingController _routeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  late UserDetails data;

  late File _selectedImage;

  get imageXFile => null;

  get as => null;

  @override
  void initState() {
    futureData = AuthService().getBusOperatorProfile();
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
    await AuthService().updateBusOperatorProfile(
      UserDetails(
        profileImageURL: _selectedImage != null
            ? 'gs://e-bus-tracker-e6623.appspot.com/bus_operator_profile_images' // Replace 'URL' with the actual URL or upload to Firestore Storage
            : data.profileImageURL,
        busName: _busNameController.text,
        busNo: _busNoController.text,
        route: _routeController.text,
        phoneNumber: _phoneController.text,
        email: _emailController.text,
      ),
    );

    // After updating, refresh the data and show it on the screen
    setState(() {
      futureData = AuthService().getBusOperatorProfile();
    });
  }

  void _navigateToProfileScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProfileTypeScreen(),
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
              data = snapshot.data as UserDetails;
              _busNameController.text = data.busName ?? '';
              _busNoController.text = data.busNo ?? '';
              _routeController.text = data.route ?? '';
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
                      controller: _busNameController,
                      decoration: InputDecoration(
                        labelText: 'Bus Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _busNoController,
                      decoration: InputDecoration(
                        labelText: 'Bus Number',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: _routeController,
                      decoration: InputDecoration(
                        labelText: 'Bus Route',
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
