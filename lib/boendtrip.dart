import 'dart:async';

import 'package:e_bus_tracker/navigation/bottom_navigation.dart';
import 'package:e_bus_tracker/profileType.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:e_bus_tracker/bostarttrip.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    _initMap();
    _startLocationTracking();
    _getCurrentLocation(); // Initialize currentLocation
    polylinePoints = PolylinePoints(); // Initialize PolylinePoints
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
    });
  }

  void _updateCurrentLocationMarker() {
    markers.removeWhere((marker) => marker.markerId.value == 'currentLocation');
    markers.add(
      Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(
          currentLocation.latitude ?? 0,
          currentLocation.longitude ?? 0,
        ),
        infoWindow: InfoWindow(title: 'Current Location'),
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
        String apiKey = 'AIzaSyAZ1LALf2ubP2J4gxXPlra09XPf9TCaYDE';
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
            SizedBox(height: 30.0),
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
                  } else if (index == 2) {
                    // Navigate to star
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
