import 'package:e_bus_tracker/bus_operator/ratings.dart';
import 'package:e_bus_tracker/widget/crad_todo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_bus_tracker/common/show_model.dart';
import 'bostarttrip.dart';
import 'package:e_bus_tracker/bus_operator/navigation/bottom_navigation.dart';
import 'viewBOprofile.dart';

class BusScheduleScreen extends StatefulWidget {
  const BusScheduleScreen({Key? key}) : super(key: key);

  @override
  _BusScheduleScreenState createState() => _BusScheduleScreenState();
}

class _BusScheduleScreenState extends State<BusScheduleScreen> {
  int _currentIndex = 1;

  final CollectionReference _busSchedule =
      FirebaseFirestore.instance.collection('busShedule');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Color(0xFF673AB7),
        elevation: 0,
        toolbarHeight: 50,
        title: Text(
          'Bus Schedule',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    _showDatePicker(context);
                  },
                  icon: const Icon(CupertinoIcons.calendar),
                ),
              ],
            ),
          ),
        ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          builder: (context) => AddNewTaskModel(
                            onSave: (editedFrom, editedTo, editedDeptTime,
                                editedArrTime, editedDate) {},
                            documentId: '',
                          ),
                        );
                      },
                      child: const Text(
                        '+ Add Schedule',
                        style: TextStyle(color: Colors.grey),
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

                        return CardTodoListWidget(
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

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate.subtract(Duration(days: 365)), // One year ago
      lastDate: currentDate.add(Duration(days: 365)), // One year in the future
    );

    if (selectedDate != null && selectedDate != currentDate) {
      // Handle the selected date
      // You can update the UI or perform any actions here
    }
  }
}
