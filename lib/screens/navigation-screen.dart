import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/custom-bottom-nav.dart';
import '../widgets/drawer-widget.dart';
import 'package:location/location.dart';

class NavigationScreen extends StatefulWidget {
  bool? isAdmin;
  bool? isGuest;
  NavigationScreen({super.key, this.isGuest, this.isAdmin = true});

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
  String? floorId;

  String? _selectedFloor;
  TextEditingController _floorController = TextEditingController();

  List floors = [
    'floor 1',
    'floor 2',
    'floor 3',
    'floor 4',
  ];

  void getLocation() async {
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
    widget.isAdmin = widget.isGuest != null ? false : false;
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
                floatingActionButton: widget.isAdmin!
                    ? FloatingActionButton.extended(
                        label: const Text('Add Floor'),
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return SizedBox(
                                  height: 400,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Add Floor Here',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black)),
                                        SizedBox(height: 20),
                                        Text("${_locationData!.altitude}"),
                                        SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: DropdownButton(
                                              underline: Container(),
                                              // icon: Icon(Icons
                                              //     .calendar_view_day_outlined),
                                              isExpanded: true,
                                              hint: Text(
                                                'Select Floor',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff979797),
                                                ),
                                              ), // Not necessary for Option 1
                                              value: _selectedFloor,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedFloor =
                                                      newValue as String?;
                                                });
                                              },
                                              items: floors.map((location) {
                                                return DropdownMenuItem(
                                                  child: new Text(
                                                    location,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xff979797),
                                                    ),
                                                  ),
                                                  value: location,
                                                );
                                              }).toList()),
                                        ),
                                        SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: TextFormField(
                                            controller: _floorController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Enter Floor Value',
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff979797),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            _firestore
                                                .collection("floor")
                                                .doc(floorId)
                                                .update({
                                              "$_selectedFloor": int.parse(
                                                  _floorController.text)
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                      )
                    : SizedBox.shrink(),
                resizeToAvoidBottomInset: false,
                key: _globalKey,
                // bottomNavigationBar: MyBottomBar(),
                backgroundColor: Colors.black,
                bottomNavigationBar: CustomBottomNavBar(context, 'explore',
                    isGuest: widget.isGuest),
                drawer: DrawerWidget(),
                body: StreamBuilder(
                    stream: _firestore.collection("floor").snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      floorId = snapshot.data!.docs.first.id;

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
                                                if (widget.isGuest != null &&
                                                    widget.isGuest!)
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
                                                      snapshot.data!.docs.first
                                                          .get("floor 1")
                                                  ? Color(0xff1D468A)
                                                  : Colors.transparent,
                                              shape: BoxShape.circle),
                                          child: Text(
                                            '1',
                                            style: TextStyle(
                                                color:
                                                    _locationData!.altitude! <
                                                            snapshot.data!.docs
                                                                .first
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
                                                              .data!.docs.first
                                                              .get("floor 1") &&
                                                      _locationData!.altitude! <
                                                          snapshot
                                                              .data!.docs.first
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
                                                            snapshot.data!.docs
                                                                .first
                                                                .get(
                                                                    "floor 1") &&
                                                        _locationData!
                                                                .altitude! <
                                                            snapshot.data!.docs
                                                                .first
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
                                  image: DecorationImage(
                                      image: _locationData!.altitude! <
                                              snapshot.data!.docs.first
                                                  .get("floor 1")
                                          ? AssetImage('assets/1st-floor.jpg')
                                          : _locationData!.altitude! >
                                                      snapshot.data!.docs.first
                                                          .get("floor 1") &&
                                                  _locationData!.altitude! <
                                                      snapshot.data!.docs.first
                                                          .get("floor 2")
                                              ? AssetImage(
                                                  'assets/2nd-floor.png')
                                              : AssetImage(
                                                  'assets/map-image.png'),
                                      fit: BoxFit.contain)),
                            )
                          ],
                        ),
                      );
                    })),
          );
  }
}
