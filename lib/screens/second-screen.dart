import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:iu_pathway_guide/screens/splash-screen.dart';
import 'package:iu_pathway_guide/screens/third-screen.dart';
import 'package:lottie/lottie.dart';

import '../widgets/text-form-field.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
          backgroundColor: Colors.black,
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30.0)),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    'assets/path.png',
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          // margin: const EdgeInsets.symmetric(vertical: 10.0),
                          // alignment: Alignment.center,
                          width: width,
                          height: height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 20.0,
                                ),
                                color: Colors.transparent,
                                height: 300,
                                width: 300,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned(
                                      right: -90.0,
                                      bottom: 5.0,
                                      // top: ,
                                      left: 30,
                                      child: Lottie.asset(
                                          'assets/area-map.json',
                                          height: 428,
                                          width: 428),
                                    ),
                                    Positioned(
                                      bottom: 20.0,
                                      child: Lottie.asset(
                                          'assets/pie-chart.json',
                                          height: 155,
                                          width: 155),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Navigate or Explore',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Roboto-Bold',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff241D1D),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    "Stop asking strangers for direction",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: 'Raleway-SemiBold',
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff1D468A),
                                    ),
                                  ),
                                  Text(
                                    "Download our app!",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: 'Raleway-SemiBold',
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff1D468A),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        margin: const EdgeInsets.only(
                            bottom: 30, left: 10, right: 10, top: 0.0),
                        height: 40,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.off(() => const SplashScreen());
                              },
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff979797),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1D468A),
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                const SizedBox(width: 3.0),
                                Container(
                                  height: 10,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff748DB7),
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => const ThirdScreen());
                              },
                              child: const Text(
                                'NEXT',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff241D1D),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
