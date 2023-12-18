import 'package:e_bus_tracker/model/user.dart';
import 'package:e_bus_tracker/model/passenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign out the user
  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  // Get the current user's email
  Future<String?> getCurrentUserEmail() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.email;
    }
    return null;
  }

  Future<UserDetails> getBusOperatorProfile() async {
    final userRef1 = await FirebaseFirestore.instance
        .collection('busOperatorProfiles')
        .doc(_auth.currentUser!.uid)
        .get();
    print(userRef1.data());

    try {
      final UserDetails ud =
          UserDetails.fromJson(userRef1.data() as Map<String, dynamic>);
      return ud;
    } catch (e) {
      print('error');
      throw (e);
    }
  }

  // Get the user profile for the current user
  Future<UserDetailsP> getUserProfile() async {
    final userRef2 = await FirebaseFirestore.instance
        .collection('userProfiles')
        .doc(_auth.currentUser!.uid)
        .get();
    print(userRef2.data());

    try {
      final UserDetailsP ud =
          UserDetailsP.fromJson(userRef2.data() as Map<String, dynamic>);
      return ud;
    } catch (e) {
      print('error');
      throw (e);
    }
  }
}
