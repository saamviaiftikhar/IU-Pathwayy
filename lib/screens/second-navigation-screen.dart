import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:iu_pathway_guide/screens/splash-screen.dart';
import 'package:iu_pathway_guide/screens/third-screen.dart';
import 'package:lottie/lottie.dart';

import '../widgets/custom-bottom-nav.dart';
import '../widgets/text-form-field.dart';

class SecondNavigationScreen extends StatefulWidget {
  const SecondNavigationScreen({super.key});

  @override
  State<SecondNavigationScreen> createState() => _SecondNavigationScreenState();
}

class _SecondNavigationScreenState extends State<SecondNavigationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onAuthChange() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        Get.to(() => const LoginScreen());
      } else {
        DocumentSnapshot query =
            await _firestore.collection('users').doc(user.email).get();
        if (query.exists) {
          final data = query.data() as Map<String, dynamic>;

          if (data["status"] != 'ACTIVE') {
            Get.to(() => const LoginScreen());
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
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          bottomNavigationBar: CustomBottomNavBar(context, 'home'),
          body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0))),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color(0xffF3F3F3),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff707070).withOpacity(0.23),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        // color: Colors.amber,
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(''),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text(
                                  'Navigation',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Color(0xff241D1D),
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(
                                  color: Color(0xff241D1D),
                                  thickness: 5,
                                ),
                                Text(
                                  'Floor',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff241D1D),
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: InkWell(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                      'assets/reverse-menu.svg')),
                            )
                          ],
                        ),
                      ),
                      Row(
                        // scrollDirection: Axis.horizontal,
                        // shrinkWrap: true,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '1',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  color: Color(0xff1D468A),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '2',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffFFFFFF),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '3',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '4',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '5',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '6',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '7',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: 35,
                              decoration: const BoxDecoration(
                                  // color: Color(0xff707070),
                                  shape: BoxShape.circle),
                              child: const Text(
                                '8',
                                style: TextStyle(
                                    color: Color(0xff393939),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                      color: const Color(0xffF9F9F9),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xff707070).withOpacity(0.23),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      image: const DecorationImage(
                          image: AssetImage('assets/map-image-2.png'),
                          fit: BoxFit.contain)),
                )
              ],
            ),
          )),
    );
  }
}
