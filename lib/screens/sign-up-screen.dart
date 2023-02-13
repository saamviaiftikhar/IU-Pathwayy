import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/models/users-model.dart';
import 'package:iu_pathway_guide/screens/BottomNavigationBar/bottom-navigation-bar.dart';
import 'package:iu_pathway_guide/screens/fourth-screen.dart';
import 'package:iu_pathway_guide/screens/home-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:iu_pathway_guide/screens/splash-screen.dart';

import '../models/courses-model.dart';
import '../widgets/text-form-field.dart';
import '../widgets/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode confirmPassFocus = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameFocus = FocusNode();
    emailFocus = FocusNode();
    passFocus = FocusNode();
    confirmPassFocus = FocusNode();
    _getDropdownItems();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passFocus.dispose();
    confirmPassFocus.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedSemester;
  List<CoursesModel> selectedCourses = [];

  List semesters = [
    '1st Semester',
    '2nd Semester',
    '3rd Semester',
    '4th Semester',
    '5th Semester',
    '6th Semester',
    '7th Semester',
    '8th Semester',
  ];

  List<String> _dropdownItems = [];
  List<String> _selectedItems = [];

  void _getDropdownItems() async {
    var items = await _firestore.collection('courses').get();
    setState(() {
      _dropdownItems =
          items.docs.map((item) => item.data()['name']).cast<String>().toList();
    });
  }

  void signUp() async {
    List<String> coursesName = [];
    selectedCourses.forEach((element) {
      coursesName.add(element.name!);
    });
    if (passwordController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Password and Confirm Password not matched. Try Again!')));
    } else {
      DocumentSnapshot query = await _firestore
          .collection('allEmails')
          .doc(emailController.text)
          .get();
      if (query.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('This email address is already in used')));
      } else {
        _firestore.collection('allEmails').doc(emailController.text).set({
          'email': emailController.text,
          'createdAt': DateTime.now(),
        });

        _auth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          _firestore.collection('users').doc(value.user!.email).set({
            'name': nameController.text,
            'email': emailController.text,
            // 'address': addressController.text,
            // 'phone': phoneController.text,q
            'createdAt': DateTime.now(),
          
            'status': 'ACTIVE',
            'isSubscribed': false,
            'isAdmin': false,
            'id': value.user!.uid,
            'semesters': _selectedSemester,
            'selectedCourses': coursesName,
          });
          // _firestore.collection('users').;
        }).onError((error, stackTrace) {
          Utils().testMessage(error.toString());
        });
        Get.to(() => const SplashScreen());
      }
    }
  }

  void selectCourses(List<CoursesModel> val) {
    selectedCourses = val;
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
                  // constraints: const BoxConstraints(maxHeight: double.infinity),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/iu-logo.png',
                        height: 230,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 50,
                          ),
                          width: width,
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(
                                      maxHeight: double.infinity),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextFieldWidget(
                                          controller: nameController,
                                          // autoFocus: true,
                                          focusNode: nameFocus,
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
                                          hintText: 'Name',
                                          onFieldSubmitted: (term) {
                                            nameFocus.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(emailFocus);
                                            return null;
                                          },
                                          onValidator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please Enter name first";
                                            } else {
                                              return null;
                                            }
                                          }),
                                      TextFieldWidget(
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textInputAction: TextInputAction.next,
                                          // autoFocus: true,
                                          focusNode: emailFocus,
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
                                          hintText: 'Email',
                                          onFieldSubmitted: (term) {
                                            emailFocus.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(passFocus);
                                            return null;
                                          },
                                          onValidator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please Enter Email";
                                            } else {
                                              return null;
                                            }
                                          }),
                                      TextFieldWidget(
                                          height: 61,
                                          controller: passwordController,
                                          obscureText: obscureText,
                                          // autoFocus: true,
                                          focusNode: passFocus,
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
                                          onFieldSubmitted: (term) {
                                            passFocus.unfocus();
                                            FocusScope.of(context)
                                                .requestFocus(confirmPassFocus);
                                            return null;
                                          },
                                          onValidator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please Enter Password";
                                            } else {
                                              return null;
                                            }
                                          },
                                          SuffixIcon: obscureText
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6.0),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          obscureText =
                                                              !obscureText;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .visibility_off_outlined,
                                                        color:
                                                            Color(0xff979797),
                                                        size: 30,
                                                      )),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6.0),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          obscureText =
                                                              !obscureText;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.visibility,
                                                        color:
                                                            Color(0xff979797),
                                                        size: 30,
                                                      )),
                                                )),
                                      TextFieldWidget(
                                          height: 61,
                                          controller: confirmPassController,
                                          obscureText: obscureText,
                                          // autoFocus: true,
                                          focusNode: confirmPassFocus,
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
                                          hintText: 'Confirm Password',
                                          onValidator: (val) {
                                            if (val == null || val.isEmpty) {
                                              return "Please Enter Confirm Password";
                                            } else {
                                              return null;
                                            }
                                          },
                                          SuffixIcon: obscureText
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6.0),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          obscureText =
                                                              !obscureText;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .visibility_off_outlined,
                                                        color:
                                                            Color(0xff979797),
                                                        size: 30,
                                                      )),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 6.0),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          obscureText =
                                                              !obscureText;
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.visibility,
                                                        color:
                                                            Color(0xff979797),
                                                        size: 30,
                                                      )),
                                                )),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        margin: EdgeInsets.only(bottom: 12),
                                        height: 50,
                                        width: width,
                                        decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color(0xff1D468A),
                                                width: 1.3)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_view_month_rounded,
                                              color: const Color(0xff1D468A),
                                              size: 30,
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                              child: DropdownButton(
                                                  underline: Container(),
                                                  // icon: Icon(Icons
                                                  //     .calendar_view_day_outlined),
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select Semester',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff979797),
                                                    ),
                                                  ), // Not necessary for Option 1
                                                  value: _selectedSemester,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _selectedSemester =
                                                          newValue as String?;
                                                    });
                                                  },
                                                  items:
                                                      semesters.map((location) {
                                                    return DropdownMenuItem(
                                                      child: new Text(
                                                        location,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Roboto',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xff979797),
                                                        ),
                                                      ),
                                                      value: location,
                                                    );
                                                  }).toList()),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // MyDropdownButton()
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        height: 50,
                                        width: width,
                                        decoration: BoxDecoration(
                                            // color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Color(0xff1D468A),
                                                width: 1.3)),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.calendar_view_month_rounded,
                                              color: const Color(0xff1D468A),
                                              size: 30,
                                            ),
                                            SizedBox(width: 8.0),
                                            Expanded(
                                                child: MyDropdownButton(
                                              onChanged: selectCourses,
                                              selectedSemester:
                                                  _selectedSemester,
                                            )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 70),
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
                                                      BorderRadius.circular(
                                                          15.0),
                                                  side: const BorderSide(
                                                      color: Colors
                                                          .transparent)))),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (_selectedSemester != null ||
                                              _selectedSemester != "") {
                                            if (selectedCourses.isNotEmpty) {
                                              signUp();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Please Select Courses')));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Please Select Semester')));
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 21,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto'),
                                      )),
                                ),
                                SizedBox(height: height * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Raleway',
                                          color: Color(0xff241D1D)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Color(0xff1D468A),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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

class MyDropdownButton extends StatefulWidget {
  final String? selectedSemester;
  final void Function(List<CoursesModel>)? onChanged;
  const MyDropdownButton(
      {super.key, this.selectedSemester, required this.onChanged});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('courses').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Please Select Semester First");
          }

          final fetchCourses = snapshot.data!.docs;
          List<CoursesModel> _fetchCourses = [];
          for (var courses in fetchCourses) {
            final name = courses.get('name');
            final id = courses.get('id');
            final location = courses.get('location');
            final day = courses.get('day');
            final time = courses.get('time');
            // final semester = courses.get('semester');
            String semester;
            try {
              semester = courses.get('semester');
            } catch (e) {
              semester = "";
            }

            final _course = CoursesModel(
              name: name,
              id: id,
              day: day,
              location: location,
              time: time,
              semester: semester,
            );

            _fetchCourses.add(_course);
          }

          List<CoursesModel> itemList = _fetchCourses
              .where((element) => element.semester == widget.selectedSemester)
              .toList();

          return DropdownSearch<CoursesModel>.multiSelection(
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    border: InputBorder.none, hintText: "Select Courses"),
              ),
              items: itemList,
              itemAsString: (CoursesModel u) => u.name!,
              onChanged: widget.onChanged);
        });
  }
}

 // dropdownBuilder: (context, selectedItems) => Container(
              //       // color: Colors.red,
              //       child: ListView.builder(
              //           scrollDirection: Axis.horizontal,
              //           itemCount: selectedItems.length,
              //           itemBuilder: ((context, index) {
              //             return Padding(
              //               padding: const EdgeInsets.only(left: 8),
              //               child: Chip(
              //                 label: Row(
              //                   children: [
              //                     Text(
              //                       selectedItems[index].name!,
              //                       style: TextStyle(fontSize: 16),
              //                     ),
              //                     SizedBox(
              //                       width: 8,
              //                     ),
              //                     InkWell(
              //                       onTap: () {
              //                         if (selectedItems.isNotEmpty) {
              //                           selectedItems.removeAt(index);
              //                         }
              //                       },
              //                       child: CircleAvatar(
              //                         radius: 8,
              //                         backgroundColor: Colors.black,
              //                         child: Icon(
              //                           Icons.close,
              //                           color: Colors.white,
              //                           size: 12,
              //                         ),
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //                 backgroundColor: Colors.lightBlueAccent,
              //                 padding: EdgeInsets.only(
              //                   bottom: 6,
              //                 ),
              //               ),
              //             );
              //           })),
              //     ),