import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/models/places-model.dart';
import 'package:iu_pathway_guide/screens/edit-profile-screen.dart';
import 'package:iu_pathway_guide/screens/profile-screen.dart';
import 'package:iu_pathway_guide/screens/sign-in-screen.dart';
import '../models/users-model.dart';
import '../widgets/custom-bottom-nav.dart';
import '../widgets/drawer-widget.dart';
import 'fourth-screen.dart';
import 'navigation-screen.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ExploreScreen extends StatefulWidget {
  final bool isGuest;
  const ExploreScreen({super.key, required this.isGuest});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  bool _value = false;

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: _globalKey,
        drawer: DrawerWidget(),
        bottomNavigationBar:
            CustomBottomNavBar(context, 'explore', isGuest: widget.isGuest),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
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
            //final department = users.get('department');
            // final storeDescriptions = users?.get('storeDescription');
            String profilePic;
            String address;
            String semester;

            try {
              profilePic = users.get('profilePic');
              address = users.get('address').toString();
              semester = users.get('semesters').toString();
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
              selectedCourses: [],
              address: address,
              semester: semester,
              profilePic: profilePic,
            );

            _users.add(_user);

            return ListView.builder(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
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
                                if (widget.isGuest) {
                                } else {
                                  _globalKey.currentState!.openDrawer();
                                }
                              },
                              child: SvgPicture.asset('assets/menu.svg')),
                          const Text(
                            'Explore',
                            style: TextStyle(
                                color: Color(0xff241D1D),
                                fontSize: 25,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.isGuest) {
                              } else {
                                Get.to(() => EditProfileScreen());
                              }
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
                                if (widget.isGuest) {
                                } else {
                                  Get.to(() => const FourthScreen());
                                }
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
                      const SizedBox(height: 15),
                      Expanded(
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: ExploreScreenStreams(),
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

class ExploreScreenStreams extends StatefulWidget {
  const ExploreScreenStreams({Key? key}) : super(key: key);

  @override
  State<ExploreScreenStreams> createState() => _ExploreScreenStreamsState();
}

class _ExploreScreenStreamsState extends State<ExploreScreenStreams> {
  final _firestore = FirebaseFirestore.instance;
  //bool isFavourite = false;
  final favouriteIconBorder =
      const Icon(Icons.favorite_border, color: Colors.white, size: 20.0);
  final favouriteIcon =
      const Icon(Icons.favorite, color: Color(0xffFDD00A), size: 20.0);
  // CartController cartController = CartController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _value = false;

  // checkWishlist({required productId}) async {
  //   User? user = _auth.currentUser;
  //   DocumentSnapshot query = await _firestore
  //       .collection('users')
  //       .doc(user!.email)
  //       .collection('wishlist')
  //       .doc(productId)
  //       .get();
  //   if (query.exists) {
  //     final wishlistData = query.data() as Map<String, dynamic>;
  //     return wishlistData['status'];
  //   } else {
  //     return 0;
  //   }
  // }

  void saveWishList({required placeId}) async {
    User? user = _auth.currentUser;
    DocumentSnapshot query = await _firestore
        .collection('users')
        .doc(user!.email)
        .collection('wishlist')
        .doc(placeId)
        .get();
    if (query.exists) {
      final wishlistData = query.data() as Map<String, dynamic>;
      if (wishlistData['status'] == 1) {
        _firestore
            .collection('users')
            .doc(user.email)
            .collection('wishlist')
            .doc(placeId)
            .set({'id': placeId, 'status': 0}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Product has been removed from wishlist')));
        });
      } else {
        _firestore
            .collection('users')
            .doc(user.email)
            .collection('wishlist')
            .doc(placeId)
            .set({'id': placeId, 'status': 1}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Product has been added to wishlist')));
        });
      }
    } else {
      _firestore
          .collection('users')
          .doc(user.email)
          .collection('wishlist')
          .doc(placeId)
          .set({'id': placeId, 'status': 1}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Product has been added to wishlist')));
      });
    }
  }

  void saveCart({required productId}) async {
    User? user = _auth.currentUser;
    DocumentSnapshot query = await _firestore
        .collection('users')
        .doc(user!.email)
        .collection('userCart')
        .doc(productId)
        .get();
    if (query.exists) {
      final cartData = query.data() as Map<String, dynamic>;
      if (cartData['status'] == 1) {
        _firestore
            .collection('users')
            .doc(user.email)
            .collection('userCart')
            .doc(productId)
            .set({'id': productId, 'status': 0}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Product has been removed from cart')));
        });
      } else {
        _firestore
            .collection('users')
            .doc(user.email)
            .collection('userCart')
            .doc(productId)
            .set({'id': productId, 'status': 1}).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product has been added to cart')));
        });
      }
    } else {
      _firestore
          .collection('users')
          .doc(user.email)
          .collection('userCart')
          .doc(productId)
          .set({'id': productId, 'status': 1}).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product has been added to cart')));
      });
    }
  }

  Widget buildExplorePlaces(
      {required String name,
      required String image,
      required String location,
      required String closingTime,
      required double rating,
      // required String totalRatings,
      required String placeId,
      required var onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 8.0),
        margin: EdgeInsets.only(bottom: 20),
        constraints: const BoxConstraints(maxHeight: double.infinity),
        decoration: BoxDecoration(
            color: const Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xff7070705).withOpacity(0.10),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: Offset(0.00, 2))
            ]),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 8.0),
              width: double.infinity,
              height: 185,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(image))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Color(0xff241D1D),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/location.svg',
                            width: 10,
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: Color(0xff241D1D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 12,
                            ignoreGestures: true,

                            // itemPadding: const EdgeInsets
                            //         .symmetric(
                            //     horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            "$rating",
                            style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        r'Closes: ' '$closingTime',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff241D1D),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              // _value = !_value;
                              saveWishList(placeId: placeId);
                            });
                          },
                          icon: Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.black,
                            size: 33,
                          ))
                      // icon: _value
                      //     ? Icon(
                      //         Icons.favorite,
                      //         color: Colors.black,
                      //         size: 33,
                      //       )
                      //     : Icon(
                      //         Icons.favorite_border_outlined,
                      //         color: Colors.black,
                      //         size: 33,
                      //       ))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('places')
          .orderBy('rating', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.teal,
            ),
          );
        }
        final explorePlaces = snapshot.data!.docs;
        List<PlacesModel> _explorePlaces = [];
        for (var places in explorePlaces) {
          final name = places.get('name');
          final id = places.get('id');
          // final vendorId = places.get('vendorId');

          final location = places.get('location');
          final closingTime = places.get('closingTime');
          final rating = (places.get('rating') as num?)?.toDouble();
          // final totalRatings = places.get('totalRatings').toString();

          String image;
          try {
            image = places.get('image').toString();
          } catch (e) {
            image = "";
          }

          final _place = PlacesModel(
            name: name,
            id: id,
            image: image,
            location: location,
            closingTime: closingTime,
            // vendorId: vendorId,
            rating: rating,
            // totalRatings: totalRatings,
          );

          _explorePlaces.add(_place);
        }

        return SizedBox(
          height: double.infinity,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              // ignore: unnecessary_null_comparison
              itemCount: _explorePlaces.length,
              itemBuilder: (context, int index) {
                return buildExplorePlaces(
                    name: _explorePlaces[index].name ?? '',
                    image: _explorePlaces[index].image as String,
                    location: _explorePlaces[index].location as String,
                    closingTime: _explorePlaces[index].closingTime as String,
                    rating: _explorePlaces[index].rating as double,
                    placeId: _explorePlaces[index].id as String,
                    onTap: () {
                      Get.to(() => NavigationScreen(
                            isGuest: true,
                          ));
                    });
              }),
        );
      },
    );
  }
}
