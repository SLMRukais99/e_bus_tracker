import 'dart:async';

import 'package:e_bus_tracker/bus_shedule.dart';
import 'package:e_bus_tracker/navigation/bottom_navigation.dart';
import 'package:e_bus_tracker/viewBOprofile.dart';
import 'package:e_bus_tracker/ratings.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:e_bus_tracker/boendtrip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as gm_places;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as location_lib;
import 'package:url_launcher/url_launcher.dart';

class BOStartTrip extends StatefulWidget {
  const BOStartTrip({Key? key}) : super(key: key);

  @override
  State<BOStartTrip> createState() => _BOStartTripState();
}

class _BOStartTripState extends State<BOStartTrip> {
  int _currentIndex = 0;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  late GoogleMapController newGoogleMapController;
  late location_lib.LocationData currentLocation;
  location_lib.Location location = location_lib.Location();
  Set<Marker> markers = {};

  TextEditingController _destinationController = TextEditingController();
  gm_places.GoogleMapsPlaces _places = gm_places.GoogleMapsPlaces(
      apiKey: "AIzaSyAZ1LALf2ubP2J4gxXPlra09XPf9TCaYDE");

  @override
  void initState() {
    super.initState();
    currentLocation = location_lib.LocationData.fromMap({
      'latitude': 0.0,
      'longitude': 0.0,
    });
    _getCurrentLocation();
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
            infoWindow: InfoWindow(title: 'Start Location'),
          ),
        );
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  void _startJourney(LatLng destinationLatLng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}&travelmode=driving';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BOEndTrip(
            startLocationLatLng: LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            ),
            destinationLatLng: destinationLatLng,
          ),
        ),
      );
    } else {
      print("Could not launch Google Maps");
    }
  }

  void _onDestinationChanged(String value) async {
    if (value.isNotEmpty) {
      try {
        final places = await _places.searchByText(value);
        if (places != null && places.results.isNotEmpty) {
          final destinationLatLng = LatLng(
            places.results.first.geometry!.location.lat,
            places.results.first.geometry!.location.lng,
          );
          setState(() {
            markers.removeWhere(
                (marker) => marker.markerId.value == 'destinationLocation');
            markers.add(
              Marker(
                markerId: MarkerId('destinationLocation'),
                position: destinationLatLng,
                infoWindow: InfoWindow(title: 'Destination Location'),
              ),
            );
          });
        } else {
          _showErrorSnackBar("No results found for the entered destination.");
        }
      } catch (e) {
        _showErrorSnackBar(
            "Error occurred while searching for the destination.");
        print("Error searching for the destination: $e");
      }
    } else {
      setState(() {
        markers.removeWhere(
            (marker) => marker.markerId.value == 'destinationLocation');
      });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
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
                    TextField(
                      controller: _destinationController,
                      onChanged: _onDestinationChanged,
                      decoration: InputDecoration(
                        labelText: 'Destination',
                        hintText: 'Enter destination...',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Press on 'Target Icon Button' in the map to get \nyour current location before starting the trip.",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.0),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ButtonWidget(
                        title: "Start Trip",
                        onPress: () {
                          if (_destinationController.text.isEmpty) {
                            _showErrorSnackBar("Please enter a destination.");
                            return;
                          }

                          if (markers.isNotEmpty) {
                            LatLng destinationLatLng = markers
                                .where((marker) =>
                                    marker.markerId ==
                                    MarkerId('destinationLocation'))
                                .first
                                .position;
                            _startJourney(destinationLatLng);
                          } else {
                            _showErrorSnackBar(
                                "Please select a valid destination.");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
