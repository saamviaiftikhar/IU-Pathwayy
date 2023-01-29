import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/fourth-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';

import '../widgets/text-form-field.dart';
import '../widgets/utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  // FocusNode nameFocus = FocusNode();
  // FocusNode emailFocus = FocusNode();
  // FocusNode passFocus = FocusNode();

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

  Future<void> forgotPassword() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) {
      const AlertDialog(
        content:
            Text('An email has been sent for reset password, Kindly check it'),
      );
      Get.to(() => const LoginScreen());
    }).catchError((error) {
      Utils().testMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/iu-logo.png',
                              height: 200,
                            ),
                            // const Padding(
                            //   padding: EdgeInsets.only(left: 30, bottom: 20),
                            //   child: Text(
                            //     'DEMO',
                            //     style: TextStyle(
                            //         fontSize: 60,
                            //         color: Color(0xff1D468A),
                            //         fontWeight: FontWeight.w400,
                            //         fontFamily: 'Raleway'),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          width: double.infinity,
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                    maxHeight: double.infinity),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFieldWidget(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      // autoFocus: true,
                                      // focusNode: emailFocus,
                                      preffixIcon: Transform.scale(
                                        scale: 0.6,
                                        child: SvgPicture.asset(
                                          'assets/email.svg',
                                          color: const Color(0xff1D468A)
                                              .withOpacity(0.52),
                                          height: 23,
                                          width: 20,
                                        ),
                                      ),
                                      height: 61,
                                      hintText: 'Enter Your Email',
                                      // onFieldSubmitted: (term) {
                                      //   emailFocus.unfocus();
                                      //   FocusScope.of(context)
                                      //       .requestFocus(passFocus);
                                      //   return null;
                                      // },
                                    ),
                                  ],
                                ),
                              ),

                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: TextButton(
                              //     onPressed: () {},
                              //     child: const Text(
                              //       'Forgot Password?',
                              //       style: TextStyle(
                              //           fontSize: 16,
                              //           color: Color(0xff1D468A),
                              //           // fontWeight: FontWeight.w400
                              //           fontFamily: 'Raleway'),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 50.0,
                                width: double.infinity,
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
                                                    color:
                                                        Colors.transparent)))),
                                    onPressed: () {
                                      setState(() {
                                        forgotPassword();
                                      });
                                    },
                                    child: const Text(
                                      'Send',
                                      style: TextStyle(
                                          fontSize: 21,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto'),
                                    )),
                              ),

                              // const Text(
                              //   "Already have an account?",
                              //   style: TextStyle(
                              //       fontSize: 18,
                              //       fontFamily: 'Raleway',
                              //       color: Color(0xff241D1D)),
                              // ),
                              TextButton(
                                onPressed: () {
                                  Get.off(() => const LoginScreen());
                                },
                                child: const Text(
                                  'Back to Sign In',
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Color(0xff1D468A),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                            ],
                          ),
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
