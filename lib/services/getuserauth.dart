import 'dart:io';

import 'package:e_bus_tracker/model/busoperator.dart';
import 'package:e_bus_tracker/model/passenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<void> updateBusOperatorProfile(UserDetails updatedProfile) async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('busOperatorProfiles')
          .doc(_auth.currentUser!.uid);

      if (updatedProfile.profileImageURL != null &&
          updatedProfile.profileImageURL is File) {
        // If there's a new image selected, upload it to Firebase Storage
        final File imageFile = updatedProfile.profileImageURL as File;
        final String imageName =
            '${_auth.currentUser!.uid}bus_operator_profile_image.jpg';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('bus_operator_profile_images/$imageName');
        await storageRef.putFile(imageFile);
        final String downloadURL = await storageRef.getDownloadURL();

        // Update the profile image URL in Firestore
        await userDocRef.update({'profileImageURL': downloadURL});
      }

      // Update other profile fields in Firestore
      await userDocRef.update({
        'busName': updatedProfile.busName,
        'busNo': updatedProfile.busNo,
        'route': updatedProfile.route,
        'phoneNumber': updatedProfile.phoneNumber,
        'email': updatedProfile.email,
      });
    } catch (e) {
      print('Error updating bus operator profile: $e');
      throw e;
    }
  }

  Future<void> updatePassengerProfile(UserDetailsP updatedProfile) async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(_auth.currentUser!.uid);

      if (updatedProfile.profileImageURL != null &&
          updatedProfile.profileImageURL is File) {
        // If there's a new image selected, upload it to Firebase Storage
        final File imageFile = updatedProfile.profileImageURL as File;
        final String imageName =
            '${_auth.currentUser!.uid}user_profile_image.jpg';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profile_images/$imageName');
        await storageRef.putFile(imageFile);
        final String downloadURL = await storageRef.getDownloadURL();

        // Update the profile image URL in Firestore
        await userDocRef.update({'profileImageURL': downloadURL});
      }

      // Update other profile fields in Firestore
      await userDocRef.update({
        'name': updatedProfile.name,
        'homeAddress': updatedProfile.homeAddress,
        'phoneNumber': updatedProfile.phoneNumber,
        'email': updatedProfile.email,
      });
    } catch (e) {
      print('Error updating bus operator profile: $e');
      throw e;
    }
  }

  // New method for uploading profile image to Firebase Storage
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      if (imageFile != null && imageFile.existsSync()) {
        final String imageName =
            '${_auth.currentUser!.uid}bus_operator_profile_image.jpg';
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('bus_operator_profile_images/$imageName');
        await storageRef.putFile(imageFile);
        final String downloadURL = await storageRef.getDownloadURL();
        return downloadURL;
      } else {
        // Handle the case when the file does not exist
        print('File does not exist');
        throw Exception('File does not exist');
      }
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }
}
