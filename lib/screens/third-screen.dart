import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/home-screen.dart';
import 'package:iu_pathway_guide/screens/second-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:lottie/lottie.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
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
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Lottie.asset('assets/chasing-loader.json',
                      height: 428, width: 428),
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
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          // alignment: Alignment.center,
                          width: width,
                          height: height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image.png',
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 50),
                              const Text(
                                'Personalized Scheduling ',
                                // maxLines: 3,
                                // textAlign: TextAlign.justify,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff241D1D),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Have your own personalized schedule",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff1D468A),
                                ),
                              ),
                              Text(
                                "notification according to your syllabus ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff1D468A),
                                ),
                              ),
                              Text(
                                "and never miss a class.",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Raleway',
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xff1D468A),
                                ),
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
                                Get.off(() => const SecondScreen());
                              },
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff241D1D),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff748DB7),
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                                const SizedBox(width: 3.0),
                                Container(
                                  height: 10,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1D468A),
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                              width: 148,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0xff1D468A)),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: const BorderSide(
                                                  color: Colors.transparent)))),
                                  onPressed: () {
                                    Get.to(() => const LoginScreen());
                                  },
                                  child: const Text(
                                    'Get Started',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto'),
                                  )),
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
