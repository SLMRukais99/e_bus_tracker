import 'dart:async';

import 'package:e_bus_tracker/bus_operator/navigation/bottom_navigation.dart';
import 'package:e_bus_tracker/passenger/location_track.dart';
import 'package:e_bus_tracker/passenger/pRatings.dart';
import 'package:e_bus_tracker/passenger/viewSchedule.dart';
import 'package:e_bus_tracker/passenger/view_Passenger_Profile.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as gm_places;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as location_lib;

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int _currentIndex = 0;

  LatLng? selectedDepartureLocation;
  LatLng? selectedDestinationLocation;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  late GoogleMapController newGoogleMapController;
  late location_lib.LocationData currentLocation;
  location_lib.Location location = location_lib.Location();
  Set<Marker> markers = {};

  LatLng? departureLocation;
  LatLng? destinationLocation;

  TextEditingController _departureController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  gm_places.GoogleMapsPlaces _places = gm_places.GoogleMapsPlaces(
      apiKey: "AIzaSyCFwBrFsTMKu5IrsOOiMY-Nw8y_RNA_ZwE");

  @override
  void initState() {
    super.initState();
    currentLocation = location_lib.LocationData.fromMap({
      'latitude': 0.0,
      'longitude': 0.0,
    });
    _getCurrentLocation();
    setCustomMarker();
  }

  late BitmapDescriptor mapMarker;

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/startlocation_marker.png');
  }

  Future<void> _getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(
                currentLocation.latitude ?? 0, currentLocation.longitude ?? 0),
            icon: mapMarker,
            infoWindow: InfoWindow(title: 'Start Location'),
          ),
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _setLocation(LatLng location, String locationName, bool isdep) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(locationName),
          position: location,
          infoWindow: InfoWindow(title: locationName),
        ),
      );

      if (isdep == true) {
        selectedDepartureLocation = location;
      } else {
        selectedDestinationLocation = location;
      }
    });
  }

  void _showLocationBottomSheet(bool isDepature, String title,
      TextEditingController controller, String locationName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  // Use current location as the selected location
                  _getUserLocation(true, controller, locationName);
                  Navigator.pop(context);
                },
                child: Text('Use Current Location'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter Location',
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  // Handle the location input here
                  String enteredLocation = controller.text;
                  if (enteredLocation.isNotEmpty) {
                    if (locationName == 'Destination Location' &&
                        _departureController.text == enteredLocation) {
                      _showErrorSnackBar(
                          "Departure and destination cannot be the same.");
                    } else if (locationName == 'Departure Location' &&
                        _destinationController.text == enteredLocation) {
                      _showErrorSnackBar(
                          "Departure and destination cannot be the same.");
                    } else {
                      _places.searchByText(enteredLocation).then((places) {
                        if (places != null && places.results.isNotEmpty) {
                          final locationLatLng = LatLng(
                            places.results.first.geometry!.location.lat,
                            places.results.first.geometry!.location.lng,
                          );
                          _setLocation(
                              locationLatLng, locationName, isDepature);
                          Navigator.pop(context);
                        } else {
                          _showErrorSnackBar(
                              "No results found for the entered $locationName location.");
                        }
                      });
                    }
                  } else {
                    _showErrorSnackBar("Please enter a location.");
                  }
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _getUserLocation(
    bool isDeparture,
    TextEditingController controller,
    String locationName,
  ) async {
    try {
      final locationData = await location.getLocation();
      LatLng currentLatLng = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );
      if (isDeparture) {
        selectedDepartureLocation =
            currentLatLng; // Update selectedDepartureLocation
        controller.text = 'Your location';
      } else {
        selectedDestinationLocation =
            currentLatLng; // Update selectedDestinationLocation
        controller.text = 'Your location';
      }
      _setLocation(currentLatLng, locationName, isDeparture);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _navigateToLocationTrack() {
    print(selectedDepartureLocation);
    print(selectedDestinationLocation);

    if (selectedDepartureLocation != null &&
        selectedDestinationLocation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationTrack(
            departureLocationLatLng: selectedDepartureLocation!,
            destinationLatLng: selectedDestinationLocation!,
          ),
        ),
      );
    } else {
      _showErrorSnackBar(
          "Please enter both departure and destination locations.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 550,
              padding: EdgeInsets.all(5.0),
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(currentLocation.latitude ?? 0,
                      currentLocation.longitude ?? 0),
                  zoom: 14.0,
                ),
                padding: EdgeInsets.only(top: 50),
                onMapCreated: (GoogleMapController controller) {
                  _controllerGoogleMap.complete(controller);
                  newGoogleMapController = controller;
                },
                markers: markers,
              ),
            ),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showLocationBottomSheet(
                        true,
                        'Enter Departure Location',
                        _departureController,
                        'Departure Location',
                      );
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _departureController,
                        decoration: InputDecoration(
                          labelText: 'Departure Location',
                          hintText: 'Enter departure...',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showLocationBottomSheet(
                        false,
                        'Enter Destination Location',
                        _destinationController,
                        'Destination Location',
                      );
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                          labelText: 'Destination Location',
                          hintText: 'Enter destination...',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    "Press on 'Target Icon Button' in the map to get \nyour current location.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15.0),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ButtonWidget(
                      title: "View Available Buses",
                      onPress: _navigateToLocationTrack,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 90.0),
            BottomNavigation(
              currentIndex: _currentIndex,
              onTabTapped: (index) {
                setState(() {
                  _currentIndex = index;
                  if (index == 0) {
                    // Navigate to home
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PassengerHomeScreen(),
                      ),
                    );
                  } else if (index == 1) {
                    // Navigate to schedule
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PassengerScheduleScreen(),
                      ),
                    );
                  } else if (index == 2) {
                    // Navigate to star
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PRatingScreen(),
                      ),
                    );
                  } else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileTypeScreenP(),
                      ),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
