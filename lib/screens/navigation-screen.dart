import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/custom-bottom-nav.dart';
import '../widgets/drawer-widget.dart';
import 'package:location/location.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Position? positionVal;
  Location location = new Location();
  LocationData? _locationData;
  double? Floor1;
  double? Floor2;

  void getLocation() async {
    //    bool serviceEnabled;
    // LocationPermission permission;

    // // Test if location services are enabled.
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   return Future.error('Location services are disabled.');
    // }

    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     // Permissions are denied, next time you could try
    //     // requesting permissions again (this is also where
    //     // Android's shouldShowRequestPermissionRationale
    //     // returned true. According to Android guidelines
    //     // your App should show an explanatory UI now.
    //     return Future.error('Location permissions are denied');
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   // Permissions are denied forever, handle appropriately.
    //   return Future.error(
    //     'Location permissions are permanently denied, we cannot request permissions.');
    // }

    // await Geolocator.getCurrentPosition();

    //   final LocationSettings locationSettings = LocationSettings(
    //     accuracy: LocationAccuracy.high,
    //     distanceFilter: 10,
    //   );
    //   StreamSubscription<Position> positionStream =
    //       Geolocator.getPositionStream(locationSettings: locationSettings)
    //           .listen((Position? position) {
    //     setState(() {
    //       positionVal = position!;
    //     });
    //   });
    // bool _serviceEnabled;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    // _locationData = await location.getLocation();
    // setState(() {});

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    location.onLocationChanged.listen((event) {
      setState(() {
        _locationData = event;
      });
    });
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _locationData == null
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                key: _globalKey,
                // bottomNavigationBar: MyBottomBar(),
                backgroundColor: Colors.black,
                bottomNavigationBar: CustomBottomNavBar(context, 'explore'),
                drawer: DrawerWidget(),
                body: StreamBuilder(
                    stream: _firestore.collection("floor").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      print(snapshot.data!.docs.last.get("floor 1"));
                      print(_locationData!.altitude);
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF3F3F3),
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xff707070)
                                            .withOpacity(0.23),
                                        blurRadius: 5,
                                        spreadRadius: 2)
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    // color: Colors.amber,
                                    constraints: const BoxConstraints(
                                        maxHeight: double.infinity),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(''),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Navigation',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Color(0xff241D1D),
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Divider(
                                              color: Color(0xff241D1D),
                                              thickness: 5,
                                            ),
                                            Text(
                                              'Floor',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff241D1D),
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 30),
                                          child: InkWell(
                                              onTap: () {
                                                _globalKey.currentState!
                                                    .openDrawer();
                                              },
                                              child: SvgPicture.asset(
                                                  'assets/reverse-menu.svg')),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    // scrollDirection: Axis.horizontal,
                                    // shrinkWrap: true,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: _locationData!.altitude! <
                                                      snapshot.data!.docs.last
                                                          .get("floor 1")
                                                  ? Color(0xff1D468A)
                                                  : Colors.transparent,
                                              shape: BoxShape.circle),
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                                color: _locationData!
                                                            .altitude! <
                                                        snapshot.data!.docs.last
                                                            .get("floor 1")
                                                    ? Colors.white
                                                    : Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: _locationData!.altitude! >
                                                          snapshot
                                                              .data!.docs.last
                                                              .get("floor 1") &&
                                                      _locationData!.altitude! <
                                                          snapshot
                                                              .data!.docs.last
                                                              .get("floor 2")
                                                  ? Color(0xff1D468A)
                                                  : Colors.transparent,
                                              shape: BoxShape.circle),
                                          child: Text(
                                            '2',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: _locationData!
                                                                .altitude! >
                                                            snapshot
                                                                .data!.docs.last
                                                                .get(
                                                                    "floor 1") &&
                                                        _locationData!
                                                                .altitude! <
                                                            snapshot
                                                                .data!.docs.last
                                                                .get("floor 2")
                                                    ? Color(0xffFFFFFF)
                                                    : Color(0xff393939),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                              // color: Color(0xff707070),
                                              shape: BoxShape.circle),
                                          child: const Text(
                                            '3',
                                            style: TextStyle(
                                                color: Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                              // color: Color(0xff707070),
                                              shape: BoxShape.circle),
                                          child: const Text(
                                            '4',
                                            style: TextStyle(
                                                color: Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                              // color: Color(0xff707070),
                                              shape: BoxShape.circle),
                                          child: const Text(
                                            '5',
                                            style: TextStyle(
                                                color: Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                              // color: Color(0xff707070),
                                              shape: BoxShape.circle),
                                          child: const Text(
                                            '6',
                                            style: TextStyle(
                                                color: Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                              // color: Color(0xff707070),
                                              shape: BoxShape.circle),
                                          child: const Text(
                                            '7',
                                            style: TextStyle(
                                                color: Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 35,
                                          decoration: const BoxDecoration(
                                              // color: Color(0xff707070),
                                              shape: BoxShape.circle),
                                          child: const Text(
                                            '8',
                                            style: TextStyle(
                                                color: Color(0xff393939),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Text("${_locationData!.altitude}"),
                            Text("${_locationData!.latitude}"),
                            Text("${_locationData!.longitude}"),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF9F9F9),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xff707070)
                                            .withOpacity(0.23),
                                        blurRadius: 5,
                                        spreadRadius: 2)
                                  ],
                                  image: const DecorationImage(
                                      image: AssetImage('assets/map-image.png'),
                                      fit: BoxFit.contain)),
                            )
                          ],
                        ),
                      );
                    })),
          );
  }
}