import 'dart:async';

import 'package:e_bus_tracker/bus_operator/bus_shedule.dart';
import 'package:e_bus_tracker/bus_operator/navigation/bottom_navigation.dart';
import 'package:e_bus_tracker/bus_operator/viewBOprofile.dart';
import 'package:e_bus_tracker/model/busoperator.dart';
import 'package:e_bus_tracker/services/getuserauth.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:e_bus_tracker/bus_operator/bostarttrip.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'ratings.dart';

class BOEndTrip extends StatefulWidget {
  final LatLng startLocationLatLng;
  final LatLng destinationLatLng;

  const BOEndTrip(
      {Key? key,
      required this.startLocationLatLng,
      required this.destinationLatLng})
      : super(key: key);

  @override
  State<BOEndTrip> createState() => _BOEndTripState();
}

class _BOEndTripState extends State<BOEndTrip> {
  int _currentIndex = 0;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  Set<Marker> markers = {};
  Set<Polyline> _polylines = {};

  late GoogleMapController newGoogleMapController;
  late LocationData currentLocation;
  StreamSubscription<LocationData>? locationSubscription;
  bool isLocationInitialized = false; // Add this flag

  late PolylinePoints polylinePoints;
  List<LatLng> routeCoordinates = []; // List to store route coordinates

  late DatabaseReference _locationRef; // Firebase Realtime Database reference

  late Future<UserDetails> futuredata;

  String? busNo = '';
  String? busName = '';

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initFirebase();
    _initMap();
    _startLocationTracking();
    _getBusOperatorDetails();
    _getCurrentLocation(); // Initialize currentLocation
    polylinePoints = PolylinePoints(); // Initialize PolylinePoints
  }

  // Initialize Firebase
  void _initFirebase() async {
    await Firebase.initializeApp();
    _locationRef = FirebaseDatabase.instance.reference().child('locations');
  }

  void _initMap() {
    markers.addAll([
      Marker(
          markerId: MarkerId('startLocation'),
          position: widget.startLocationLatLng,
          infoWindow: InfoWindow(title: 'Start Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)),
      Marker(
          markerId: MarkerId('destinationLocation'),
          position: widget.destinationLatLng,
          infoWindow: InfoWindow(title: 'Destination Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)),
    ]);
  }

  void _startLocationTracking() {
    Location location = Location();
    locationSubscription =
        location.onLocationChanged.listen((LocationData newLocation) {
      currentLocation = newLocation;
      _updateCurrentLocationMarker();
      _updateRoutePolyline(); // Call method to update route polyline

      // Store current location in Firebase Realtime Database
      _locationRef.child('current_buslocation').set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
      });
    });
  }

  void _updateCurrentLocationMarker() {
    markers
        .removeWhere((marker) => marker.markerId.value == 'currentBusLocation');
    markers.add(
      Marker(
        markerId: MarkerId('currentBusLocation'),
        position: LatLng(
          currentLocation.latitude ?? 0,
          currentLocation.longitude ?? 0,
        ),
        infoWindow: InfoWindow(title: 'Current Bus Location'),
      ),
    );
    setState(() {});
  }

  void _getCurrentLocation() async {
    try {
      Location location = Location();
      currentLocation = await location.getLocation();
      isLocationInitialized = true; // Update the flag
      _updateCurrentLocationMarker(); // Update the current location marker
    } catch (e) {
      print("Error getting location: $e");
    }
    _updateRoutePolyline(); // Initial route polyline update
  }

  void _updateRoutePolyline() async {
    if (isLocationInitialized) {
      try {
        String apiKey = 'AIzaSyCFwBrFsTMKu5IrsOOiMY-Nw8y_RNA_ZwE';
        String url =
            'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${widget.destinationLatLng.latitude},${widget.destinationLatLng.longitude}&key=$apiKey';

        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          List<PointLatLng> result = polylinePoints
              .decodePolyline(data['routes'][0]['overview_polyline']['points']);

          routeCoordinates.clear();
          for (var point in result) {
            routeCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          setState(() {
            _polylines.clear(); // Clear previous polyline
            final polyline = Polyline(
              polylineId: PolylineId('routePolyline'),
              color: Colors.deepPurple,
              points: routeCoordinates,
            );

            _polylines.add(polyline); // Add updated polyline
          });
        } else {
          print('Error fetching route: ${data['status']}');
        }
      } catch (e) {
        print("Error updating route: $e");
      }
    }
  }

  // Fetch bus operator details from Cloud Firestore
  void _getBusOperatorDetails() async {
    try {
      UserDetails userDetails = await _authService.getBusOperatorProfile();
      setState(() {
        busNo = userDetails.busNo;
        busName = userDetails.busName;
      });

      // Store bus details in Firebase Realtime Database
      _locationRef.child('busdetails').set({
        'busNo': busNo,
        'busName': busName,
      });
    } catch (e) {
      print('Error fetching bus operator details: $e');
    }
  }

  void _endTrip() {
    // Stop location tracking
    locationSubscription?.cancel();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BOStartTrip(),
      ),
    ); // Navigate back to the StartTrip screen
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
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
              height: 650,
              padding: EdgeInsets.all(5.0),
              child: isLocationInitialized // Check if location is initialized
                  ? GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      polylines: _polylines,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation.latitude ?? 0,
                            currentLocation.longitude ?? 0),
                        zoom: 14.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controllerGoogleMap.complete(controller);
                        newGoogleMapController = controller;
                      },
                      markers: markers,
                    )
                  : CircularProgressIndicator(
                      color: Colors.deepPurple,
                    ), // Show a loading indicator if location is not initialized yet
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ButtonWidget(onPress: _endTrip, title: "End Trip"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 160.0),
            BottomNavigation(
              currentIndex: _currentIndex,
              onTabTapped: (index) {
                setState(() {
                  _currentIndex = index;
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BOStartTrip(),
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
          ],
        ),
      ),
    );
  }
}
