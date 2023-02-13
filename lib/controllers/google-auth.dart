import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iu_pathway_guide/screens/explore-screen.dart';

import '../screens/splash-screen.dart';

class GoogleLogin {
  googleLogin() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      print("Google");
      var result = await googleSignIn.signIn();
      if (result == null) {
        return;
      }

      print("Google sign in successful");
      print(result.email);

      final userData = await result.authentication;

      final userCredential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);

      var finalResult = await auth.signInWithCredential(userCredential);
      DocumentSnapshot query = await firestore
          .collection('allEmails')
          .doc(finalResult.user!.email)
          .get();
      if (query.exists) {
        DocumentSnapshot userQuery = await firestore
            .collection('users')
            .doc(finalResult.user!.email)
            .get();
        if (userQuery.exists) {
          final data = userQuery.data() as Map<String, dynamic>;
          if (data["status"] == 'ACTIVE') {
            print("Go to explore");
            Get.to(() => ExploreScreen(
                  isGuest: true,
                ));
          } else {
            const SnackBar(content: Text('The user has been blocked.'));
            FirebaseAuth.instance.signOut();
          }
        } else {
          const SnackBar(content: Text('Incorrect email.'));
          FirebaseAuth.instance.signOut();
        }
      } else {
        firestore.collection('allEmails').doc(finalResult.user!.email).set({
          'email': finalResult.user!.email,
          'createdAt': DateTime.now(),
        });

        // DocumentSnapshot dashboardQuery = await FirebaseFirestore.instance
        //     .collection('settings')
        //     .doc('dashboard')
        //     .get();

        // final dashboardData = dashboardQuery.data() as Map<String, dynamic>;

        // dashboardData['totalUsers'] = dashboardData['totalUsers'] + 1;
        // firestore.collection('settings').doc('dashboard').set(dashboardData);

        firestore.collection('users').doc(finalResult.user!.email).set({
          'name': finalResult.user!.displayName,
          'email': finalResult.user!.email,
          // 'address': addressController.text,
          // 'phone': '',

          'isAdmin': false,
          'createdAt': DateTime.now(),
          'status': 'ACTIVE',
          'isSubscribed': false,
          'id': finalResult.user!.uid,
          'semesters': "",
          'selectedCourses': [],
        });

        print("working fine here");

        Get.to(() => ExploreScreen(
              isGuest: true,
            ));
      }

      print(finalResult.user!.uid);
    } catch (e) {
      print(e);
    }
  }
}
