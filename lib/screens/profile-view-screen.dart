import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iu_pathway_guide/models/users-model.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/custom-bottom-nav.dart';
import '../widgets/utils/utils.dart';
import 'home-screen.dart';
import 'sign-in-screen.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String initialValue = 'initial value';
  final TextEditingController nameController =
      TextEditingController(text: 'initialValue');
  final TextEditingController emailController =
      TextEditingController(text: 'initialValue');
  final TextEditingController addressController =
      TextEditingController(text: 'initialValue');
  final TextEditingController semesterController =
      TextEditingController(text: 'initialValue');

  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode semesterFocus = FocusNode();
  FocusNode addressFocus = FocusNode();

  XFile? _image;

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
    // TODO: implement initState
    super.initState();
    nameFocus = FocusNode();
    emailFocus = FocusNode();
    semesterFocus = FocusNode();
    addressFocus = FocusNode();
    nameController.text;
    emailController.text;
    addressController.text;
    semesterController.text;

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
  }

  void updateProfile() async {
    User? user = _auth.currentUser;
    DocumentSnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .get();
    final data = query.data() as Map<String, dynamic>;
    data['name'] = nameController.text;
    data['address'] = addressController.text;
    data['department'] = semesterController.text;
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
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted) {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        var imageTemporary = File(image!.path);

        // ignore: unnecessary_null_comparison
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
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: CustomBottomNavBar(context, 'user'),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(user!.email).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              );
            }
            List<UsersModel> _users = [];
            final users = snapshot.data;
            final name = users!.get('name');
            final id = users.get('id');
            final email = users.get('email');
            final semester = users.get('semesters');
            String address;
            String profilePic;
            try {
              address = users.get('address');
              profilePic = users.get('profilePic');
            } catch (e) {
              address = '---';
              profilePic = '';
            }

            final _user = UsersModel(
                id: id,
                name: name,
                address: address,
                selectedCourses: [],
                email: email,
                semester: semester,
                profilePic: profilePic);
            _users.add(_user);

            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  nameController.text = _users[index].name;
                  emailController.text = _users[index].email;
                  addressController.text = _users[index].address;
                  semesterController.text = _users[index].semester;
                  profilePic = _users[index].profilePic;
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 25.0),
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
                              height: height,
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
                                              : CircleAvatar(
                                                  radius: 80,
                                                  backgroundImage: AssetImage(
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
                                  textFormFieldWidget(
                                      controller: semesterController,
                                      hintText: 'Semester',
                                      height: height * 0.06,
                                      keyboardType: TextInputType.text,
                                      focusNode: semesterFocus,
                                      onFieldSubmitted: (term) {
                                        semesterFocus.unfocus();

                                        // FocusScope.of(context).requestFocus(emailFocus);
                                      }
                                      // textInputAction: TextInputAction.next,
                                      ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                  );
                });
          }),
    );
  }
}
