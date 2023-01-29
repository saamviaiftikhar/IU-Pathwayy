import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screens/splash-screen.dart';

class GoogleLogin {
  googleLogin() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var result = await googleSignIn.signIn();
      if (result == null) {
        return;
      }

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
          final data = query.data() as Map<String, dynamic>;
          if (data["status"] == 'ACTIVE') {
            Get.to(() => const SplashScreen());
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
          'createdAt': DateTime.now(),
          'status': 'ACTIVE',
          'isSubscribed': false,
          'id': finalResult.user!.uid,
        });

        Get.to(() => const SplashScreen());
      }

      print(finalResult.user!.uid);
      // print('Result $result');
      // print(result.displayName);
      // print(result.email);
    } catch (e) {
      print(e);
    }
  }
}
