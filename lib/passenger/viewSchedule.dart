import 'package:e_bus_tracker/passenger/pRatings.dart';
import 'package:e_bus_tracker/passenger/passengerhome.dart';
import 'package:e_bus_tracker/passenger/view_Passenger_Profile.dart';
import 'package:e_bus_tracker/widget/show_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_bus_tracker/common/show_model.dart';
import 'package:e_bus_tracker/bus_operator/navigation/bottom_navigation.dart';

class PassengerScheduleScreen extends StatefulWidget {
  const PassengerScheduleScreen({Key? key}) : super(key: key);

  @override
  _PassengerScheduleScreenState createState() =>
      _PassengerScheduleScreenState();
}

class _PassengerScheduleScreenState extends State<PassengerScheduleScreen> {
  int _currentIndex = 1;

  final CollectionReference _busSchedule =
      FirebaseFirestore.instance.collection('busShedule');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xFF673AB7),
        title: Text(
          'Bus Schedule',
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Upcoming Schedule",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: _busSchedule.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final List<QueryDocumentSnapshot> documents =
                        snapshot.data!.docs;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final Map<String, dynamic>? data =
                            documents[index].data() as Map<String, dynamic>?;

                        final String toWhere = data?['toWhere'] ?? '';
                        final String date = data?['date'] ?? '';
                        final String deptTimeTask = data?['deptTimeTask'] ?? '';
                        final String arrTimeTask = data?['arrTimeTask'] ?? '';

                        return ShowCardListWidget(
                          documentId: documents[index].id,
                          fromWhere: data?['fromWhere'] ?? '',
                          toWhere: toWhere,
                          date: date,
                          deptTimeTask: deptTimeTask,
                          arrTimeTask: arrTimeTask,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
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
                  builder: (context) => const PassengerHomeScreen(),
                ),
              );
            } else if (index == 1) {
              // Navigate to schedule
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
    );
  }
}
