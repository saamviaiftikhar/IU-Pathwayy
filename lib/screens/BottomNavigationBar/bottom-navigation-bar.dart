import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iu_pathway_guide/screens/profile-screen.dart';

import '../explore-screen.dart';
import '../fav-screen.dart';
import '../fourth-screen.dart';
import '../home-screen.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({super.key});

  @override
  State<MyBottomBar> createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ExploreScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: width >= 360 && height >= 780
            ? Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0)),
                  child: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/home.svg',
                            height: 25,
                          ),
                          label: 'Home'),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/search.svg',
                            height: 25,
                            color: const Color(0xff979797),
                          ),
                          label: 'Explore'),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/favourite.svg',
                            height: 25,
                          ),
                          label: 'Favourite'),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/feather-user.svg',
                            height: 25,
                          ),
                          label: 'User'),
                    ],
                    currentIndex: _selectedIndex,
                    fixedColor: const Color(0xff1D468A),
                    // selectedItemColor: Color(0xff1D468A),
                    selectedLabelStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                    onTap: _onItemTapped,
                    type: BottomNavigationBarType.fixed,
                  ),
                ),
              )
            : Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(52),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(37.0),
                      bottomRight: Radius.circular(37.0)),
                  child: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/home.svg'),
                          label: 'Home'),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            'assets/search.svg',
                            color: const Color(0xff979797),
                          ),
                          label: 'Explore'),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/favourite.svg'),
                          label: 'Favourite'),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset('assets/feather-user.svg'),
                          label: 'User'),
                    ],
                    currentIndex: _selectedIndex,
                    fixedColor: const Color(0xff1D468A),
                    // selectedItemColor: Color(0xff1D468A),
                    selectedLabelStyle: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                    onTap: _onItemTapped,
                    type: BottomNavigationBarType.fixed,
                  ),
                ),
              ),
      ),
    );
  }
}
