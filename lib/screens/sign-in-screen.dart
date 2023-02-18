import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iu_pathway_guide/screens/bottomnavbar.dart';
import 'package:iu_pathway_guide/screens/forgot-screen.dart';
import 'package:iu_pathway_guide/screens/home-screen.dart';
import 'package:iu_pathway_guide/screens/profile-screen.dart';
import 'package:iu_pathway_guide/screens/sign-up-screen.dart';

import '../controllers/google-auth.dart';
import '../widgets/text-form-field.dart';
import '../widgets/utils/utils.dart';
import 'BottomNavigationBar/bottom-navigation-bar.dart';
import 'splash-screen.dart';

class LoginScreen extends StatefulWidget {
  final bool isGuest;
  const LoginScreen({super.key, this.isGuest = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  var googleLogin = GoogleLogin();
  bool isGuest = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  void onAuthChange() {
    if (widget.isGuest == false) {
      _auth.authStateChanges().listen((User? user) async {
        if (user == null) {
          Get.to(() => const LoginScreen());
        } else {
          DocumentSnapshot query =
              await _firestore.collection('users').doc(user.email).get();

          if (query.exists) {
            final data = query.data() as Map<String, dynamic>;

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
  }

  @override
  void initState() {
    super.initState();
    print("Init State");
    onAuthChange();
    emailFocus = FocusNode();
    passFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emailFocus.dispose();
    passFocus.dispose();
  }

  void login() async {
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) async {
      DocumentSnapshot query =
          await _firestore.collection('users').doc(value.user!.email).get();
      if (query.exists) {
        final data = query.data() as Map<String, dynamic>;
        if (data["status"] == 'ACTIVE') {
          Get.to(() => const HomeScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('The user has been blocked.')));
          _auth.signOut();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect email or password')));
        _auth.signOut();
      }
    }).onError((error, stackTrace) {
      Utils().testMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Container(
          width: double.infinity,
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
                // color: Colors.transparent,
                width: width,
                // height: height * 0.9,
                constraints: BoxConstraints(
                  maxHeight: double.infinity,
                ),

                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            'assets/iu-logo.png',
                            height: 230,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Welcome',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color(0xff241D1D),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 46, vertical: 20),
                          width: double.infinity,
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFieldWidget(
                                controller: emailController,
                                // autoFocus: true,
                                focusNode: emailFocus,
                                preffixIcon: Transform.scale(
                                  scale: 0.6,
                                  child: SvgPicture.asset(
                                    'assets/user.svg',
                                    color: const Color(0xff1D468A),
                                    height: 23,
                                    width: 20,
                                  ),
                                ),
                                height: 61,
                                hintText: 'Email',
                                onFieldSubmitted: (term) {
                                  emailFocus.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(passFocus);
                                  return null;
                                },
                              ),
                              TextFieldWidget(
                                  height: 61,
                                  controller: passwordController,
                                  // autoFocus: true,
                                  focusNode: passFocus,
                                  obscureText: obscureText,
                                  preffixIcon: SizedBox(
                                    height: 23,
                                    width: 20,
                                    child: Transform.scale(
                                      scale: 0.6,
                                      child: SvgPicture.asset(
                                        'assets/lock.svg',
                                        color: const Color(0xff1D468A),
                                      ),
                                    ),
                                  ),
                                  hintText: 'Password',
                                  SuffixIcon: obscureText
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obscureText = !obscureText;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.visibility_off_outlined,
                                                color: Color(0xff979797),
                                                size: 30,
                                              )),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obscureText = !obscureText;
                                                });
                                              },
                                              icon: Icon(
                                                Icons.visibility,
                                                color: Color(0xff979797),
                                                size: 30,
                                              )),
                                        )),
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    Get.to(() => const ForgotPasswordScreen());
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff1D468A),
                                        // fontWeight: FontWeight.w400
                                        fontFamily: 'Raleway'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 45.0,
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
                                                    BorderRadius.circular(10.0),
                                                side: const BorderSide(
                                                    color:
                                                        Colors.transparent)))),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        login();
                                      }
                                    },
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontSize: 21,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto-Bold'),
                                    )),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   height: 100,
                        //   decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       shape: BoxShape.circle,
                        //       boxShadow: [
                        //         BoxShadow(
                        //             color: Colors.white.withOpacity(0.52),
                        //             blurRadius: 3.0,
                        //             spreadRadius: 3.0)
                        //       ]),
                        //   child: SvgPicture.asset(
                        //     'assets/qrcode.svg',
                        //   ),
                        // ),
                        // Image.asset(
                        //   'assets/qrcode.png',
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                // color: Color(0xffFFECEC),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Color(0xffFFECEC).withOpacity(0.40),
                                      spreadRadius: 30,
                                      blurRadius: 30)
                                ]),
                            child: Center(
                              child: Text(
                                '-OR-',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff241D1D),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              googleLogin.googleLogin();
                            });
                          },
                          child: SvgPicture.asset(
                            'assets/google.svg',
                            // color: const Color(0xff1D468A).withOpacity(0.52),
                            height: 47,
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {},
                        //   child: SvgPicture.asset(
                        //     'assets/twitter.svg',
                        //     // color: const Color(0xff1D468A).withOpacity(0.52),
                        //   ),
                        // ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Raleway',
                                    color: Color(0xff241D1D)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // setState(() {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               const SignUpScreen()));
                                  // });
                                  Get.to(() => const SignUpScreen());
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Color(0xff1D468A),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
