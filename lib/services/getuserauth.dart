import 'package:e_bus_tracker/model/user.dart';
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

  // Get the bus operator profile for the current user
  Future<UserDetails> getBusOperatorProfile() async {
    final userRef = await FirebaseFirestore.instance
        .collection('busOperatorProfiles')
        .doc(_auth.currentUser!.uid)
        .get();
    print(userRef.data());

    try {
      final UserDetails ud =
          UserDetails.fromJson(userRef.data() as Map<String, dynamic>);
      return ud;
    } catch (e) {
      print('error');
      throw (e);
    }
  }
}
