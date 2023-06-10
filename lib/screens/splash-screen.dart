import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/second-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    Duration _duration = const Duration(seconds: 5);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    // SharedPreferences.getInstance().then((value) {
    //   if (value.containsKey('userId')) {
    //     Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const HomeScreen()));
    //   } else {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SecondScreen()));
    //   }
    // });
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  // void onAuthChange() {
  //   _auth.authStateChanges().listen((User? user) async {
  //     if (user == null) {
  //       Get.to(() => const LoginScreen());
  //     } else {
  //       DocumentSnapshot query =
  //           await _firestore.collection('users').doc(user.email).get();
  //       if (query.exists) {
  //         final data = query.data() as Map<String, dynamic>;

  //         if (data["status"] != 'ACTIVE') {
  //           Get.to(() => const LoginScreen());
  //         }
  //       } else {
  //         Get.to(() => const LoginScreen());
  //       }
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   onAuthChange();
  // }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: const Color(0xff547CBE),
                borderRadius: BorderRadius.circular(30.0)),
            child: Stack(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Lottie.asset(
                          'assets/welcome.json',
                          height: 240,
                        ),
                      ),
                      Image.asset(
                        'assets/icon-logo.png',
                        height: 250,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Stop asking strangers for direction",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Raleway-SemiBold',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Download our app!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Raleway-SemiBold',
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff1e4488),
          mini: false,
          onPressed: () {},
          child: Icon(
            Icons.send,
            size: 28,
          ),
        ),
      ),
    );
  }
}
