import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/explore-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:iu_pathway_guide/screens/splash-screen.dart';
import 'package:iu_pathway_guide/screens/third-screen.dart';
import 'package:lottie/lottie.dart';

import '../widgets/custom-bottom-nav.dart';
import '../widgets/text-form-field.dart';
import 'BottomNavigationBar/bottom-navigation-bar.dart';
import 'navigation-screen.dart';
import 'second-navigation-screen.dart';

class FourthScreen extends StatefulWidget {
  const FourthScreen({super.key});

  @override
  State<FourthScreen> createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  int selectedIndex = 0;
  // double _counter = 0;
  final TextEditingController searchController = TextEditingController();
  bool _value = false;

  // void increment() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  // void decrement() {
  //   setState(() {
  //     _counter--;
  //   });
  // }

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

  Widget _textFieldWidget({
    required String hintText,
    String? labelText,
    var errorStyle,
    required double height,
    var labelStyle,
    var preffixIcon,
    Widget? SuffixIcon,
    var initialValue,
    int maxLines = 1,
    FocusNode? focusNode,
    bool autoFocus = false,
    bool obscureText = false,
    bool readOnly = false,
    bool inDense = false,
    var style,
    double radius = 8,
    TextEditingController? controller,
    String? Function(String?)? onValidator,
    String? Function(String)? onChanged,
    String? Function(String)? onFieldSubmitted,
    Function()? suffixTap,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 10.0),
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          // ignore: prefer_const_constructors
          // boxShadow: [
          boxShadow: [
            BoxShadow(
              color: const Color(0xff707070).withOpacity(0.25),
              spreadRadius: 0.5,
              blurRadius: 7,
              offset: const Offset(0, 1), // changes position of shadow
            )
          ]
          // ]
          ),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        focusNode: focusNode,
        autofocus: autoFocus,
        readOnly: readOnly,

        style: style,
        maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: onValidator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        // cursorColor: primaryDarkColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          isDense: inDense,
          fillColor: const Color(0xffF3F3F3),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          errorStyle: errorStyle,
          labelStyle: labelStyle,
          labelText: labelText,
          // icon != null
          //     ? EdgeInsets.zero
          //     : const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
            borderSide: BorderSide.none,
          ),
          suffixIcon: SuffixIcon,
          // hintText == "Enter Password" ||
          //         hintText == "Enter Confirm Password"
          //     ? IconButton(
          //         onPressed: suffixTap,
          //         icon:
          //             Icon(obscureText ? Icons.visibility : Icons.visibility_off),
          //         // color: primaryDarkColor,
          //       )
          //     : null,
          hintText: hintText,
          prefixIcon: preffixIcon,
          hintStyle: const TextStyle(
            // letterSpacing: 3,
            fontWeight: FontWeight.w400,
            color: Color(0xff979797),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: CustomBottomNavBar(context, 'explore'),
          backgroundColor: Colors.black,
          body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                // image: DecorationImage(
                //     fit: BoxFit.cover,
                //     image: AssetImage(
                //       'assets/images.jpeg',
                //     )),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(37.0),
                  topRight: Radius.circular(37.0),
                )),
            child: Stack(
              children: [
                Container(
                    width: width,
                    height: height * 0.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/bg-images.jpeg',
                            )),
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(37.0),
                          topRight: Radius.circular(37.0),
                        ))),
                SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/iu-logo.png',
                            height: 270,
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.only(left: 30, bottom: 20),
                          //   child: Text(
                          //     'DEMO',
                          //     style: TextStyle(
                          //         fontSize: 60,
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w400,
                          //         fontFamily: 'Raleway'),
                          //   ),
                          // )
                        ],
                      ),
                      Container(
                        width: width,
                        // height: 495,
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  width: MediaQuery.of(context).size.width,
                                  // height:
                                  //     MediaQuery.of(context).size.height * 0.6,
                                  constraints: const BoxConstraints(
                                      maxHeight: double.infinity),
                                  decoration: BoxDecoration(
                                      // color: Colors.cyan,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Lottie.asset(
                                    'assets/chasing-loader.json',
                                  ),
                                ),
                                Container(
                                    // padding: const EdgeInsets.symmetric(
                                    //     horizontal: 20, vertical: 20),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    alignment: Alignment.bottomCenter,
                                    width: width,
                                    // height: 495,
                                    constraints: const BoxConstraints(
                                        maxHeight: double.infinity),
                                    decoration: BoxDecoration(
                                        // color: Colors.amberAccent,
                                        // borderRadius:
                                        //     BorderRadius.circular(40.0)
                                        ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15),
                                            child: Text(
                                              'Select Location',
                                              style: TextStyle(
                                                  fontSize: 21,
                                                  fontFamily: 'Raleway',
                                                  color: Color(0xff241D1D),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          _textFieldWidget(
                                              controller: searchController,
                                              hintText: 'Search',
                                              height: 50.0,
                                              preffixIcon: InkWell(
                                                onTap: () {},
                                                child: Transform.scale(
                                                  scale: 0.6,
                                                  child: SvgPicture.asset(
                                                    'assets/search.svg',
                                                    color:
                                                        const Color(0xff979797),
                                                  ),
                                                ),
                                              )),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 35, bottom: 20),
                                            child: Text(
                                              'Include Guest friendly location',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Raleway',
                                                  color: Color(0xff241D1D),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _value = !_value;
                                              });
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffF3F3F3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(
                                                              0xffB6B6B6)
                                                          .withOpacity(0.45),
                                                      spreadRadius: 0.5,
                                                      blurRadius: 7,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    )
                                                  ]),
                                              child: _value
                                                  ? Icon(
                                                      Icons
                                                          .check_box_outline_blank,
                                                      size: 30,
                                                      color: Colors.blue,
                                                    )
                                                  : Transform.scale(
                                                      scale: 0.6,
                                                      child: SvgPicture.asset(
                                                        'assets/correct.svg',
                                                        color: const Color(
                                                            0xffB6B6B6),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          // const Padding(
                                          //   padding: EdgeInsets.only(
                                          //       top: 20, bottom: 20),
                                          //   child: Text(
                                          //     'Guests',
                                          //     style: TextStyle(
                                          //         fontSize: 16,
                                          //         fontFamily: 'Raleway',
                                          //         color: Color(0xff241D1D),
                                          //         fontWeight: FontWeight.w600),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   margin: const EdgeInsets.only(
                                          //       bottom: 30),
                                          //   padding: const EdgeInsets.symmetric(
                                          //       horizontal: 15.0),
                                          //   height: 45,
                                          //   width: 160,
                                          //   decoration: BoxDecoration(
                                          //       color: const Color(0xffF3F3F3),
                                          //       borderRadius:
                                          //           BorderRadius.circular(15.0),
                                          //       boxShadow: [
                                          //         BoxShadow(
                                          //           color:
                                          //               const Color(0xffB6B6B6)
                                          //                   .withOpacity(0.45),
                                          //           spreadRadius: 0.5,
                                          //           blurRadius: 7,
                                          //           offset: const Offset(0,
                                          //               1), // changes position of shadow
                                          //         )
                                          //       ]),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.center,
                                          //     children: [
                                          //       InkWell(
                                          //         onTap: decrement,
                                          //         child: Container(
                                          //           alignment: Alignment.center,
                                          //           height: 30,
                                          //           width: 30,
                                          //           decoration: BoxDecoration(
                                          //               color: const Color(
                                          //                   0xffFFFFFF),
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(5.0),
                                          //               boxShadow: [
                                          //                 BoxShadow(
                                          //                   color: const Color(
                                          //                           0xffB6B6B6)
                                          //                       .withOpacity(
                                          //                           0.45),
                                          //                   spreadRadius: 0.5,
                                          //                   blurRadius: 7,
                                          //                   offset: const Offset(
                                          //                       0,
                                          //                       1), // changes position of shadow
                                          //                 )
                                          //               ]),
                                          //           child: Padding(
                                          //             padding:
                                          //                 const EdgeInsets.all(
                                          //                     8.0),
                                          //             child: SvgPicture.asset(
                                          //               'assets/decrement.svg',
                                          //               height: 10,
                                          //             ),
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       Text(
                                          //         '$_counter',
                                          //         style: const TextStyle(
                                          //             color: Color(0xff241D1D),
                                          //             fontSize: 23,
                                          //             fontFamily: 'Raleway',
                                          //             fontWeight:
                                          //                 FontWeight.w600),
                                          //       ),
                                          //       InkWell(
                                          //         onTap: increment,
                                          //         child: Container(
                                          //           alignment: Alignment.center,
                                          //           height: 30,
                                          //           width: 30,
                                          //           decoration: BoxDecoration(
                                          //               color: const Color(
                                          //                   0xffFFFFFF),
                                          //               borderRadius:
                                          //                   BorderRadius
                                          //                       .circular(5.0),
                                          //               boxShadow: [
                                          //                 BoxShadow(
                                          //                   color: const Color(
                                          //                           0xffB6B6B6)
                                          //                       .withOpacity(
                                          //                           0.45),
                                          //                   spreadRadius: 0.5,
                                          //                   blurRadius: 7,
                                          //                   offset: const Offset(
                                          //                       0,
                                          //                       1), // changes position of shadow
                                          //                 )
                                          //               ]),
                                          //           child: SvgPicture.asset(
                                          //             'assets/add.svg',
                                          //             height: 20,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          Container(
                                            margin: EdgeInsets.only(top: 55),
                                            height: 50.0,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all<Color>(
                                                            const Color(
                                                                0xff1D468A)),
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10.0),
                                                            side: const BorderSide(
                                                                color: Colors
                                                                    .transparent)))),
                                                onPressed: () {
                                                  Get.to(() =>
                                                      const NavigationScreen());
                                                },
                                                child: const Text(
                                                  'Search',
                                                  style: TextStyle(
                                                      fontSize: 21,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Roboto'),
                                                )),
                                          ),
                                          // SizedBox(height: 200),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
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
