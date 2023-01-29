import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';

import '../models/users-model.dart';
import '../widgets/custom-bottom-nav.dart';
import 'BottomNavigationBar/bottom-navigation-bar.dart';
import 'edit-profile-screen.dart';
import 'home-screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final page = 'user';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  // XFile? _image;

  // var uuid = Uuid();
  // String _sessionToken = '123456';
  // List<dynamic> _placeList = [];

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

  Widget buildInfoFiellds(
      {required var height, required var width, required var text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      height: height,
      width: width,
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
          color: Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Color(0xff707070).withOpacity(0.20),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 4))
          ]),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Color(0xff1D468A)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: CustomBottomNavBar(context, page),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(user!.email).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.teal,
                ),
              );
            }
            List<UsersModel> _users = [];
            final users = snapshot.data;

            var name = users!.get("name");
            final id = users.get('id');
            final email = users.get('email');
            //final department = users.get('department');
            // final storeDescriptions = users?.get('storeDescription');
            String profilePic;
            String address;
            String semester;
            semester = users.get('semesters').toString();
            try {
              profilePic = users.get('profilePic');
              address = users.get('address').toString();
              // semester = users.get('semesters').toString();
            } catch (e) {
              address = "---";

              profilePic = '';
              // semester = '---';
            }

            final _user = UsersModel(
              name: name,
              id: id,
              // city: city,
              selectedCourses: [],
              email: email,
              address: address,
              semester: semester,
              profilePic: profilePic,
            );

            _users.add(_user);

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _users.length,
              itemBuilder: (context, index) {
                // name = _users[index].name;
                // emailController.text = _users[index].email;
                // departmentController.text = _users[index].department;
                // addressController.text = _users[index].address;
                profilePic = _users[index].profilePic;
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xff274E8E),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          height: screenHeight * 0.20,
                          width: screenWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(() => HomeScreen());
                                      },
                                      child: SvgPicture.asset(
                                          'assets/arrow-back.svg',
                                          color: Colors.white),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Welcome',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Text(
                                        _users[index].name,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 3.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (profilePic != '')
                                      ? Container(
                                          // margin: EdgeInsets.only(bottom: 3),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      profilePic))),
                                        )
                                      : Container(
                                          // margin: EdgeInsets.only(bottom: 3),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                    'assets/user.png',
                                                  ))),
                                        ),
                                  TextButton(
                                    onPressed: () {
                                      Get.to(() => EditProfileScreen());
                                    },
                                    child: Text(
                                      'Edit Profile',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Color(0xff707070).withOpacity(0.33),
                                      spreadRadius: 2,
                                      blurRadius: 5)
                                ]),
                            height: screenHeight,
                            width: screenWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: screenHeight * 0.22,
                                  width: screenWidth,
                                  margin: EdgeInsets.fromLTRB(20, 25, 20, 50),
                                  decoration: BoxDecoration(
                                      color: Color(0xffF3F3F3),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xff707070)
                                                .withOpacity(0.20),
                                            spreadRadius: 2,
                                            blurRadius: 3,
                                            offset: Offset(0, 4))
                                      ]),
                                  child: Center(
                                    child: (profilePic != '')
                                        ? CircleAvatar(
                                            radius: 80,
                                            backgroundImage: NetworkImage(
                                              profilePic,
                                            ))
                                        : CircleAvatar(
                                            radius: 80,
                                            backgroundImage: AssetImage(
                                              'assets/user.png',
                                            )),
                                  ),
                                ),
                                buildInfoFiellds(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    text: _users[index].name),
                                buildInfoFiellds(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    text: _users[index].email),
                                buildInfoFiellds(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    text: _users[index].address),
                                buildInfoFiellds(
                                    height: screenHeight * 0.06,
                                    width: screenWidth,
                                    text: _users[index].semester),
                              ],
                            )),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
