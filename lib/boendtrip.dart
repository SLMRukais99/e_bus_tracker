import 'dart:async';

import 'package:e_bus_tracker/navigation/bottom_navigation.dart';
import 'package:e_bus_tracker/profileType.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:e_bus_tracker/bostarttrip.dart';

class BOEndTrip extends StatefulWidget {
  final LocationData currentLocation;
  final LatLng destinationLatLng;

  const BOEndTrip(
      {Key? key,
      required this.currentLocation,
      required this.destinationLatLng})
      : super(key: key);

  @override
  State<BOEndTrip> createState() => _BOEndTripState();
}

class _BOEndTripState extends State<BOEndTrip> {
  int _currentIndex = 0;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  late GoogleMapController newGoogleMapController;

  Set<Marker> markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  void _initMap() async {
    await _getCurrentLocation();

    markers.add(
      Marker(
        markerId: MarkerId('destinationLocation'),
        position: widget.destinationLatLng,
        infoWindow: InfoWindow(title: 'Destination Location'),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Location location = Location();
      LocationData currentLocation = await location.getLocation();

      setState(() {
        markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(
              widget.currentLocation.latitude ?? 0,
              widget.currentLocation.longitude ?? 0,
            ),
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _endTrip() {
    // Clear markers to end the trip
    markers.clear();
    setState(() {});

    final polyline = Polyline(
      polylineId: PolylineId('tripPolyline'),
      color: Colors.blue,
      points: [
        LatLng(
          widget.currentLocation.latitude!,
          widget.currentLocation.longitude!,
        ),
        widget.destinationLatLng,
      ],
    );

    setState(() {
      _polylines.add(polyline);
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BOStartTrip(),
      ),
    ); // Navigate back to the StartTrip screen
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
              child: GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.currentLocation.latitude ?? 0,
                      widget.currentLocation.longitude ?? 0),
                  zoom: 14.0,
                ),
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
                  SizedBox(height: 20.0),
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ButtonWidget(onPress: _endTrip, title: "End Trip"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
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
