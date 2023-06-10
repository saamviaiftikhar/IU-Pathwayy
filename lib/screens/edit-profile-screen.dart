// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iu_pathway_guide/models/courses-model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/users-model.dart';
import '../widgets/custom-bottom-nav.dart';
import '../widgets/utils/utils.dart';
import 'home-screen.dart';
import 'profile-screen.dart';
import 'sign-in-screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController =
      TextEditingController(text: "Your initial value");
  final TextEditingController emailController =
      TextEditingController(text: "Your initial value");
  final TextEditingController addressController =
      TextEditingController(text: "Your initial value");
  final _formKey = GlobalKey<FormState>();

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode semesterFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  String _selectedSemester = "";
  User? user = FirebaseAuth.instance.currentUser;
  XFile? _image;

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

  void onAuthChange() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        Get.to(() => LoginScreen());
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

  List<CoursesModel> selectedCourses = [];
  List<dynamic> coursesName = [];

  void selectCourses(List<CoursesModel> val) {
    selectedCourses = val;
  }

  void getUserInfo() async {
    var userData =
        await _firestore.collection('users').doc(user!.email).snapshots();

    userData.first.then((value) {
      nameController.text = value.get("name");
      emailController.text = value.get("email");
      addressController.text = value.get("address");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    semesterFocus = FocusNode();
    addressFocus = FocusNode();
    nameController.text;
    emailController.text;
    // phoneController.text;
    addressController.text;

    getUserInfo();

    // addressController.addListener(() {
    //   onChange();
    // });
    onAuthChange();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    semesterFocus.dispose();
    addressFocus.dispose();
    // comfirmPassFocus.dispose();
  }

  // void onChange() {
  //   if (_sessionToken == null) {
  //     setState(() {
  //       _sessionToken = uuid.v4();
  //     });
  //   }

  //   // getSuggestion(addressController.text);
  // }

  // void getSuggestion(String input) async {
  //   String kPLACESAPIKEY = 'AIzaSyA3NQcP2xQrv_Bzwq2MdXlgGBxsC8hlEZM';
  //   String baseURL =
  //       'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  //   String request =
  //       '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';

  //   var response = await http.get(Uri.parse(request));
  //   var data = response.body.toString();
  //   print('data');
  //   print(data);

  //   if (response.statusCode == 200) {
  //     _placeList = jsonDecode(response.body.toString())['predictions'];
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  void updateProfile() async {
    List<String> courses = [];
    selectedCourses.forEach((element) {
      courses.add(element.name!);
    });

    User? user = _auth.currentUser;
    DocumentSnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get();
    final data = query.data() as Map<String, dynamic>;
    data['name'] = nameController.text;
    data['address'] = addressController.text;
    data['semesters'] = _selectedSemester;
    data['selectedCourses'] = courses;
    _firestore.collection('users').doc(user.email).set(data).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('The Profile has been updated.')));
    }).onError((error, stackTrace) {
      Utils().testMessage(error.toString());
    });
  }

  Future pickImage() async {
    final firebaseStorage = FirebaseStorage.instance;
    try {
      await Permission.camera.request();
      var permissionStatus = await Permission.camera.status;
      if (permissionStatus.isGranted) {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        var imageTemporary = File(image!.path);

        if (image != null) {
          var snapshot = (await firebaseStorage
              .ref()
              .child('users/${image.name}')
              .putFile(imageTemporary));

          var downloadUrl = await snapshot.ref.getDownloadURL();

          User? user = _auth.currentUser;
          DocumentSnapshot query = await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.email)
              .get();
          final data = query.data() as Map<String, dynamic>;
          data['profilePic'] = downloadUrl;

          _firestore
              .collection('users')
              .doc(user.email)
              .set(data)
              .then((value) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('The Profile Pic has been updated.')));
          }).onError((error, stackTrace) {
            Utils().testMessage(error.toString());
          });
          setState(() {
            _image = downloadUrl as XFile?;
          });
        } else {
          print('No Image Path Received');
        }
      } else {
        print('Permission not granted. Try Again with permission access');
      }
    } catch (error) {
      print(error);
    }
  }

  Widget textFormFieldWidget({
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
      // width: width,
      margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
      decoration: BoxDecoration(
          color: Color(0xffF3F3F3),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Color(0xff707070).withOpacity(0.20),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 4))
          ]),

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
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 8.0),
          errorStyle: errorStyle,
          labelStyle: labelStyle,
          labelText: labelText,
          // icon != null
          //     ? EdgeInsets.zero
          //     : const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: CustomBottomNavBar(context, 'user'),
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

            final name = users!.get("name");
            final id = users.get('id');
            final email = users.get('email');
            String profilePic;
            String address;

            List<dynamic> courses = [];
            courses = users.get('selectedCourses');
            _selectedSemester = users.get('semesters');

            try {
              coursesName = courses;
              profilePic = users.get('profilePic');
              address = users.get('address').toString();
            } catch (e) {
              address = "";

              profilePic = '';
              // semester = '';
            }

            final _user = UsersModel(
              name: name,
              id: id,
              selectedCourses: courses,
              email: email,
              address: address,
              semester: _selectedSemester,
              profilePic: profilePic,
            );

            // nameController.text = _user.name;
            // emailController.text = _user.email;
            // semesterController.text = _user.semester;
            // addressController.text = _user.address;
            // profilePic = _user.profilePic;

            _users.add(_user);

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(color: Colors.white),
                  height: height,
                  width: width,
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
                            height: height * 0.17,
                            width: width,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 20.0),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Welcome',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Container(
                                            height: height * 0.03,
                                            width: width * 0.61,
                                            color: Colors.transparent,
                                            child: Text(
                                              // 'MUhee UDDIn abrro',
                                              _users[index].name,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 1.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                (profilePic != '')
                                    ? Container(
                                        // margin: EdgeInsets.only(bottom: 3),
                                        height: 90,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:
                                                    NetworkImage(profilePic))),
                                      )
                                    : Container(
                                        // margin: EdgeInsets.only(bottom: 3),
                                        height: 90,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage(
                                                  'assets/user.png',
                                                ))),
                                      ),
                              ],
                            )),
                        Expanded(
                          child: SingleChildScrollView(
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
                              height: height * 1.1,
                              width: width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height * 0.22,
                                    width: width,
                                    margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF3F3F3),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff707070)
                                                  .withOpacity(0.20),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 4))
                                        ]),
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          (profilePic != '')
                                              ? CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage: NetworkImage(
                                                    '$profilePic',
                                                  ))
                                              : _image != null || _image != ""
                                                  ? CircleAvatar(
                                                      radius: 80,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        '$_image',
                                                      ))
                                                  : CircleAvatar(
                                                      radius: 80,
                                                      backgroundImage:
                                                          AssetImage(
                                                        'assets/user.png',
                                                      )),
                                          Positioned(
                                            bottom: 0.0,
                                            right: 5.0,
                                            child: InkWell(
                                              onTap: () async {
                                                setState(() {
                                                  pickImage();
                                                });
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 50,
                                                width: 50,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white60,
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.black,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  textFormFieldWidget(
                                      controller: nameController,
                                      hintText: 'Name',
                                      height: height * 0.06,
                                      focusNode: nameFocus,
                                      keyboardType: TextInputType.text,

                                      // textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        nameFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(emailFocus);
                                        return null;
                                      }),
                                  textFormFieldWidget(
                                      controller: emailController,
                                      hintText: 'Email',
                                      height: height * 0.06,
                                      readOnly: true,
                                      focusNode: emailFocus,
                                      keyboardType: TextInputType.emailAddress,
                                      // textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        emailFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(addressFocus);
                                      }),
                                  textFormFieldWidget(
                                      controller: addressController,
                                      hintText: 'Address',
                                      height: height * 0.06,
                                      keyboardType: TextInputType.text,
                                      focusNode: addressFocus,
                                      // textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (term) {
                                        addressFocus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(semesterFocus);
                                      }),
                                  // textFormFieldWidget(
                                  //     controller: semesterController,
                                  //     hintText: 'Semester',
                                  //     height: height * 0.06,
                                  //     keyboardType: TextInputType.text,
                                  //     focusNode: semesterFocus,
                                  //     onFieldSubmitted: (term) {
                                  //       semesterFocus.unfocus();

                                  //       // FocusScope.of(context).requestFocus(emailFocus);
                                  //     }
                                  //     // textInputAction: TextInputAction.next,
                                  //     ),
                                  Container(
                                    // margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    height: height * 0.06,
                                    // width: width,
                                    margin: EdgeInsets.fromLTRB(20, 25, 20, 0),
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF3F3F3),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0xff707070)
                                                  .withOpacity(0.20),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 4))
                                        ]),

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
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xff979797),
                                          ),
                                        ), // Not necessary for Option 1
                                        value: _selectedSemester,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedSemester =
                                                newValue.toString();
                                          });
                                        },
                                        items: semesters.map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(
                                              location,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff979797),
                                              ),
                                            ),
                                            value: location,
                                          );
                                        }).toList()),
                                  ),

                                  SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Courses",
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  _user.selectedCourses.isNotEmpty
                                      ? Wrap(
                                          spacing: 10,
                                          children: List.generate(
                                              _user.selectedCourses.length,
                                              (indexx) => Chip(
                                                    label: Text(
                                                        _user.selectedCourses[
                                                            indexx]),
                                                    backgroundColor:
                                                        Colors.lightBlueAccent,
                                                  )))
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: MyDropdownButton(
                                            selectedSemester: _selectedSemester,
                                            onChanged: selectCourses,
                                          ),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    child: Container(
                                      // margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                                              10.0),
                                                      side: const BorderSide(
                                                          color: Colors
                                                              .transparent)))),
                                          onPressed: () async {
                                            setState(() {
                                              updateProfile();
                                            });
                                          },
                                          child: const Text(
                                            'Update',
                                            style: TextStyle(
                                                fontSize: 21,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Roboto-Bold'),
                                          )),
                                    ),
                                  ),

                                  // SizedBox(height: height*0.1,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.14,
                        )
                      ]),
                );
              },
            );
          },
        ),
      ),
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

          print(itemList);

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
