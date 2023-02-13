import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/profile-screen.dart';
import 'package:iu_pathway_guide/screens/profile-view-screen.dart';
import '../models/users-model.dart';
import '../screens/edit-profile-screen.dart';
import '../screens/explore-screen.dart';
import '../screens/fav-screen.dart';
import '../screens/home-screen.dart';
import '../screens/sign-in-screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return StreamBuilder<DocumentSnapshot>(
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

        final name = users!.get("name");
        final id = users.get('id');
        final email = users.get('email');
        //final department = users.get('department');
        // final storeDescriptions = users?.get('storeDescription');
        String profilePic;
        String address;
        String semester;

        try {
          profilePic = users.get('profilePic');
          address = users.get('address').toString();
          semester = users.get('semester').toString();
        } catch (e) {
          address = "---";

          profilePic = '';
          semester = '---';
        }

        final _user = UsersModel(
          name: name,
          id: id,
          // city: city,
          email: email,
          address: address,
          selectedCourses: [],
          semester: semester,
          profilePic: profilePic,
        );

        _users.add(_user);

        return Container(
          width: width * 0.75,
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              // nameController.text = _users[index].name;
              // emailController.text = _users[index].email;
              // departmentController.text = _users[index].department;
              // addressController.text = _users[index].address;
              profilePic = _users[index].profilePic;
              return Container(
                constraints: BoxConstraints(
                  maxHeight: height,
                ),
                // height: double.infinity,
                width: width * 0.5,
                child: Drawer(
                  width: width * 0.5,
                  backgroundColor: const Color(0xff1D468A).withOpacity(0.95),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      DrawerHeader(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset('assets/arrow-back.svg',
                                    color: Colors.white),
                              ),
                              Text(
                                r'Hello, ' '${_users[index].name}',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(EditProfileScreen());
                                },
                                child: (profilePic != '')
                                    ? CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            NetworkImage(profilePic),
                                      )
                                    : CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            AssetImage('assets/user.png'),
                                      ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1.2,
                                  indent: 8,
                                  endIndent: 8,
                                  // height: 3,
                                ),
                              ),
                              Text(
                                'Menu',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white,
                                  thickness: 1.2,
                                  endIndent: 8,
                                  indent: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              // color: Colors.amber,
                              constraints: const BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: SvgPicture.asset(
                                      'assets/home.svg',
                                      color: Colors.white,
                                      height: 25,
                                    ),
                                    title: const Text(
                                      'Home',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Get.to(() => const HomeScreen());
                                      // Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 38,
                                    ),
                                    // SvgPicture.asset(
                                    //   'assets/search.svg',
                                    //   color: Colors.white,
                                    //   height: 28,
                                    // ),
                                    title: const Text(
                                      'Explore',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Get.to(() => ExploreScreen(
                                            isGuest: false,
                                          ));
                                      // Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: SvgPicture.asset(
                                      'assets/favourite.svg',
                                      color: Colors.white,
                                      height: 25,
                                    ),
                                    title: const Text(
                                      'Favourite',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Get.to(() => const FavouriteScreen());
                                      // Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    title: const Text(
                                      'Profile',
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      Get.to(() => const EditProfileScreen());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 50),
                        constraints: const BoxConstraints(
                          maxHeight: double.infinity,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                    indent: 13,
                                    // height: 3,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Get.off(() => LoginScreen());
                                  },
                                  child: const Text(
                                    'Sign out',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.5,
                                    endIndent: 13,
                                  ),
                                ),
                              ],
                            ),
                            // InkWell(
                            //     onTap: () {},
                            //     child: Icon(
                            //       Icons.logout,
                            //       color: Colors.black,
                            //       size: 45,
                            //     )),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: InkWell(
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    Get.off(() => LoginScreen());
                                  },
                                  child: Image.asset(
                                    'assets/signout.png',
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
