import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iu_pathway_guide/screens/home-screen.dart';

import 'sign-in-screen.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onAuthChange() {
    print("Function working");
    _auth.authStateChanges().listen((User? user) async {
      print(user);
      if (user == null) {
        Get.to(() => const LoginScreen());
      } else {
        DocumentSnapshot query =
            await _firestore.collection('users').doc(user.email).get();
        print(query);
        if (query.exists) {
          final data = query.data() as Map<String, dynamic>;
          print(data);
          if (data["status"] == 'ACTIVE') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: ((context) => HomeScreen())));
          }
        } else {
          Get.to(() => const LoginScreen());
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    onAuthChange();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
