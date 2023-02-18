import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/edit-profile-screen.dart';
import 'package:iu_pathway_guide/screens/navigation-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import 'package:lottie/lottie.dart';
import '../models/courses-model.dart';
import '../models/users-model.dart';
import '../widgets/custom-bottom-nav.dart';
import '../widgets/drawer-widget.dart';
import 'fourth-screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
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
      // margin: const EdgeInsets.symmetric(horizontal: .0),
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        bottomNavigationBar: CustomBottomNavBar(context, 'home'),
        drawer: DrawerWidget(
          isGuest: false,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(user?.email).snapshots(),
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
            semester = users.get('semesters').toString();

            try {
              profilePic = users.get('profilePic');
              address = users.get('address').toString();
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
                // nameController.text = _users[index].name;
                // emailController.text = _users[index].email;
                // departmentController.text = _users[index].department;
                // addressController.text = _users[index].address;
                profilePic = _users[index].profilePic;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                // setState(() async {
                                //   _scaffoldKey.currentContext!.openDrawer();
                                // });
                                _globalKey.currentState!.openDrawer();
                              },
                              child: SvgPicture.asset('assets/menu.svg')),
                          const Text(
                            'Home',
                            style: TextStyle(
                                color: Color(0xff241D1D),
                                fontSize: 25,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => EditProfileScreen());
                            },
                            child: (profilePic != '')
                                ? CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: NetworkImage(
                                      profilePic,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage('assets/user.png'),
                                  ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      _textFieldWidget(
                        controller: searchController,
                        hintText: 'Search',
                        height: 45.0,
                        preffixIcon: InkWell(
                          onTap: () {},
                          child: Transform.scale(
                            scale: 0.6,
                            child: SvgPicture.asset(
                              'assets/search.svg',
                              color: const Color(0xff979797),
                            ),
                          ),
                        ),
                        SuffixIcon: SizedBox(
                          height: 45.0,
                          width: 116,
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
                                Get.to(() => const FourthScreen());
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SvgPicture.asset('assets/find.svg'),
                                  const Text(
                                    'Find',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Roboto'),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      // const SizedBox(height: 10),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(top: 30),
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                  color: Color(0xffF9F9F9),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            Color(0xff707070).withOpacity(0.25),
                                        spreadRadius: 2,
                                        blurRadius: 5)
                                  ]),
                              child: Lottie.asset('assets/chasing-loader.json'),
                            ),
                            Container(
                              alignment: Alignment.center,
                              // padding: const EdgeInsets.symmetric(
                              //     horizontal: 20, vertical: 20),
                              margin: const EdgeInsets.only(
                                top: 30,
                              ),
                              padding: const EdgeInsets.only(
                                bottom: 10,
                                top: 10,
                              ),
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(15.0),
                                // boxShadow: [
                                //   BoxShadow(
                                //       color: Color(0xff707070).withOpacity(0.25),
                                //       spreadRadius: 2,
                                //       blurRadius: 5)
                                // ]
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20, top: 10),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'My Courses',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff241D1D),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: width,
                                      // height: 70,
                                      child: StreamBuilder<DocumentSnapshot>(
                                          stream: _firestore
                                              .collection('users')
                                              .doc(user!.email)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.teal,
                                                ),
                                              );
                                            }
                                            // final wishlistPlaces = snapshot.data!.docs;
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
                                            semester = users
                                                .get('semesters')
                                                .toString();
                                            try {
                                              profilePic =
                                                  users.get('profilePic');
                                              address = users
                                                  .get('address')
                                                  .toString();
                                            } catch (e) {
                                              address = "---";

                                              profilePic = '';
                                            }

                                            final _user = UsersModel(
                                              name: name,
                                              id: id,
                                              // city: city,
                                              email: email,
                                              selectedCourses: [],
                                              address: address,
                                              semester: semester,
                                              profilePic: profilePic,
                                            );

                                            _users.add(_user);
                                            return GridView.builder(
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 1,
                                                        mainAxisSpacing: 10,
                                                        crossAxisSpacing: 10,
                                                        childAspectRatio: 0.4),
                                                // ignore: unnecessary_null_comparison
                                                itemCount: _users.length,
                                                itemBuilder:
                                                    (context, int index) {
                                                  return HomeScreenStreams(
                                                      semester: _users[index]
                                                          .semester,
                                                      isAdmin:
                                                          users.get("isAdmin"));
                                                });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

class HomeScreenStreams extends StatefulWidget {
  String? semester;
  bool? isAdmin;
  HomeScreenStreams({Key? key, required this.semester, this.isAdmin})
      : super(key: key);

  @override
  State<HomeScreenStreams> createState() => _HomeScreenStreamsState();
}

class _HomeScreenStreamsState extends State<HomeScreenStreams> {
  final _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget buildCourses(
      {required String name,
      required String courseId,
      required String location,
      required String day,
      required String time,
      required var onTap,
      required String semester}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 15, bottom: 10),
        height: 91,
        width: 163,
        decoration: BoxDecoration(
            color: const Color(0xffF3F3F3),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 2), // changes position of shadow
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  color: Color(0xff1D468A),
                  fontWeight: FontWeight.w600,
                  fontSize: 12),
              textAlign: TextAlign.justify,
              maxLines: 1,
            ),
            SizedBox(height: 3.0),
            Text(
              location,
              style: TextStyle(
                  color: Color(0xff393939),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            SizedBox(height: 3.0),
            Text(
              '$day ' '$time',
              style: TextStyle(
                  color: Color(0xff393939),
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // print(widget.semester);
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('courses')
          .where('semester', isEqualTo: widget.semester)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.teal,
            ),
          );
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

        return SizedBox(
          height: height,
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 5.0,
                  childAspectRatio: 1.5),
              // ignore: unnecessary_null_comparison
              itemCount: _fetchCourses.length,
              itemBuilder: (context, int index) {
                return buildCourses(
                    name: _fetchCourses[index].name ?? '',
                    semester: _fetchCourses[index].semester as String,
                    location: _fetchCourses[index].location as String,
                    time: _fetchCourses[index].time as String,
                    day: _fetchCourses[index].day as String,
                    courseId: _fetchCourses[index].id as String,
                    onTap: () {
                      Get.to(() => NavigationScreen(
                            isAdmin: widget.isAdmin,
                          ));
                    });
              }),
        );
      },
    );
  }
}
