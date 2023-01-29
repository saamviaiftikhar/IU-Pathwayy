import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iu_pathway_guide/screens/profile-view-screen.dart';
import '../screens/edit-profile-screen.dart';
import '../screens/explore-screen.dart';
import '../screens/fav-screen.dart';
import '../screens/home-screen.dart';

Widget CustomBottomNavBar(BuildContext context, page) {
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;
  var grayColor = Colors.grey;
  var activeColor = Color(0Xff7E95BB);
  return Container(
    padding: EdgeInsets.only(bottom: 2.0),
    height: height * 0.085,
    width: width,
    decoration: BoxDecoration(
        color: Color(0xffF9F9F9),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => HomeScreen());
              },
              icon: SvgPicture.asset('assets/home.svg',
                  height: 30, color: page == 'home' ? activeColor : grayColor),
            ),
            Text(
              'Home',
              style: TextStyle(
                color: page == 'home' ? activeColor : grayColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => ExploreScreen());
              },
              icon: SvgPicture.asset(
                'assets/search.svg',
                height: 30,
                color: page == 'explore' ? activeColor : grayColor,
              ),
            ),
            Text(
              'Explore',
              style: TextStyle(
                color: page == 'explore' ? activeColor : grayColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => FavouriteScreen());
              },
              icon: SvgPicture.asset('assets/favourite.svg',
                  height: 30,
                  color: page == 'favourite' ? activeColor : grayColor),
            ),
            Text(
              'Favourite',
              style: TextStyle(
                color: page == 'favourite' ? activeColor : grayColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => EditProfileScreen());
              },
              icon: SvgPicture.asset('assets/feather-user.svg',
                  height: 30, color: page == 'user' ? activeColor : grayColor),
            ),
            Text(
              'User',
              style: TextStyle(
                color: page == 'user' ? activeColor : grayColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            )
          ],
        ),
      ],
    ),
  );
}
