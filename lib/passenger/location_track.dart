import 'package:e_bus_tracker/bus_operator/navigation/bottom_navigation.dart';
import 'package:e_bus_tracker/bus_operator/ratings.dart';
import 'package:e_bus_tracker/passenger/pRatings.dart';
import 'package:e_bus_tracker/passenger/passengerhome.dart';
import 'package:e_bus_tracker/passenger/viewSchedule.dart';
import 'package:e_bus_tracker/passenger/view_Passenger_Profile.dart';
import 'package:e_bus_tracker/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationTrack extends StatefulWidget {
  final LatLng departureLocationLatLng;
  final LatLng destinationLatLng;

  const LocationTrack({
    Key? key,
    required this.departureLocationLatLng,
    required this.destinationLatLng,
  }) : super(key: key);

  @override
  _LocationTrackState createState() => _LocationTrackState();
}

int _currentIndex = 0;

class _LocationTrackState extends State<LocationTrack> {
  DatabaseReference getData =
      FirebaseDatabase.instance.ref('locations/busdetails');
  late GoogleMapController newGoogleMapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  var _locationRef;
  var _busDetailsRef;

  String _busNo = '';
  String _busName = '';

  @override
  void initState() {
    super.initState();
    _initFirebase();
    _initMap();
    _listenToFirebase();
  }

  void _initFirebase() async {
    await Firebase.initializeApp();
    _locationRef = FirebaseDatabase.instance.reference().child('locations');
  }

  void _initMap() {
    markers.addAll([
      Marker(
        markerId: MarkerId('DepartureLocation'),
        position: widget.departureLocationLatLng,
        infoWindow: InfoWindow(title: 'Departure Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: MarkerId('destinationLocation'),
        position: widget.destinationLatLng,
        infoWindow: InfoWindow(title: 'Destination Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    ]);
  }

  void _listenToFirebase() {
    DatabaseReference busLocationRef =
        FirebaseDatabase.instance.ref('locations/current_buslocation');
    busLocationRef.onValue.listen((DatabaseEvent event) {
      DatabaseReference busDetailsRef =
          FirebaseDatabase.instance.ref('locations/busdetails');
      busDetailsRef.onValue.listen((DatabaseEvent event) {
        final dynamic data = event.snapshot.value;
        if (data != null) {
          _busName = data['busName'].toString();
          _busNo = data['busNo'].toString();
        }
      });

      busLocationRef.onValue.listen((DatabaseEvent event) {
        final dynamic snapshotValue = event.snapshot.value;
        if (snapshotValue != null && snapshotValue is Map) {
          double latitude = snapshotValue['latitude'] ?? 0.0;
          double longitude = snapshotValue['longitude'] ?? 0.0;

          LatLng busLocation = LatLng(latitude, longitude);
          _updateBusLocationMarker(busLocation, _busName, _busNo);
          _updatePolyline(busLocation);
        }
      });
    });
  }

  void _updateBusLocationMarker(
      LatLng location, String? busName, String? busNo) {
    print(_busName);
    print(_busNo);
    markers
        .removeWhere((marker) => marker.markerId.value == 'currentBusLocation');
    markers.add(
      Marker(
        markerId: MarkerId('currentBusLocation'),
        position: location,
        infoWindow: InfoWindow(
          title: 'Current Bus Location',
          snippet: 'BusName: $_busName | BusNo: $_busNo',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    setState(() {});
  }

  void _updatePolyline(LatLng busLocation) async {
    String apiKey = 'AIzaSyCFwBrFsTMKu5IrsOOiMY-Nw8y_RNA_ZwE';
    String url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${busLocation.latitude},${busLocation.longitude}'
        '&destination=${widget.departureLocationLatLng.latitude},${widget.departureLocationLatLng.longitude}'
        '&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> routes = data['routes'];
      if (routes.isNotEmpty) {
        String points = routes[0]['overview_polyline']['points'];
        polylineCoordinates = _decodePolyline(points);
        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: PolylineId('polyline'),
            color: Colors.deepPurple,
            points: polylineCoordinates,
          ),
        );
        setState(() {});
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      double latitude = lat / 1e5;
      double longitude = lng / 1e5;
      poly.add(LatLng(latitude, longitude));
    }

    return poly;
  }

  @override
  Widget build(BuildContext context) {
    Map data = {"temp": 0};
    return StreamBuilder<Object>(
        stream: getData.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final firstdata = (snapshot.data! as DatabaseEvent).snapshot.value
                as Map<Object?, dynamic?>;
          }
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
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: widget.departureLocationLatLng,
                        zoom: 14.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        newGoogleMapController = controller;
                      },
                      markers: markers,
                      polylines: polylines,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        SizedBox(height: 30.0),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: ButtonWidget(
                              onPress: _endTrip, title: "End Trip"),
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
                              builder: (context) =>
                                  const PassengerScheduleScreen(),
                            ),
                          );
                        } else if (index == 2) {
                          // Navigate to star
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PRatingScreen(),
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
        });
  }

  void _endTrip() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerHomeScreen(),
      ),
    );
  }
}
