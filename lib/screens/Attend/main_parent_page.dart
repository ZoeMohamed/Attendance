import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
//LIBRARY UI COVID
import 'package:schools_management/screens/Attend/screens.dart';

import 'package:provider/provider.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:schools_management/models/job.dart';
import 'package:schools_management/models/notification.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/models/global.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:schools_management/widgets/custAlert.dart';
import 'package:schools_management/widgets/loading_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

//GEOLOCATION PACKAGE
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:background_location/background_location.dart';
// import 'package:permission_handler/permission_handler.dart';

//IMPORT PAGE
import 'package:schools_management/screens/Attend/go_attend.dart';
// import 'package:schools_management/screens/parent/survey_page.dart';
// import 'package:schools_management/screens/login_page.dart';

import 'package:connectivity/connectivity.dart';
// import 'package:trust_location/trust_location.dart';
// import 'package:location_permissions/location_permissions.dart';
import 'package:geolocator/geolocator.dart';

//Saya tambahin kak
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainParentPage extends StatefulWidget {
  static const routeName = '/main-parent-page';
  @override
  _MainParentPageState createState() => _MainParentPageState();
}

List<Job> jobs = [];
List<NotificationOffice> notif = [];

class _MainParentPageState extends State<MainParentPage> {
  int activeindex = 0;
  //INITIAL Variable
  ParentInf getParentInfo;
  String parentName;
  String parentEmail;
  String parentCreated_At;
  String parentImagesProf;
  String imgcapt;
  int parentID;
  double latitude = -6.229728;
  double longitude = 106.6894312;
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  String time = "waiting...";
  String addressName = "No Address!!";
  String city = "No Address Found ....";
  bool menuLeave = false;
  bool proccess = false;
  String urlprofileimage = "";
  String messageInfo =
      "Please click icon refresh, before using apps for attendance IN / attendance OUT";
  String messageRange = "Please wait...checking range coverage area";
  String time_in = "TIME : -";
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;
  DateTime now = DateTime.now();

  var _permissionStatus = Permission.location.status;
  bool _isMockLocation;

  _formatSize(String conteudo) {
    if (conteudo.length > 100) {
      return 12.00;
    } else {
      return 15.00;
    }
  }

  @override
  void initState() {
    // print("perm");
    // print(_permissionStatus);
    cekPerm();
    //GetHelper.getLastAttend();

    //getLateAttend();

    // getstatusIN();
    getNotification();
    // _listenForPermissionStatus();
    // requestLocationPermission();
    BackgroundLocation.startLocationService();
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.getLocationUpdates((location) {
          setState(() {
            latitude = location.latitude.toDouble();
            longitude = location.longitude.toDouble();
            accuracy = location.accuracy.toString();
            altitude = location.altitude.toString();
            bearing = location.bearing.toString();
            speed = location.speed.toString();
            time = DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
                .toString();
          });

          print("""\n
          Latitude:  $latitude
          Longitude: $longitude
          Altitude: $altitude
          Accuracy: $accuracy
          Bearing:  $bearing
          Speed: $speed
          Time: $time
          """);
        });

        // getCurrentLocation();
        // getRoadname();
        // getCurrentLocation();
        // getRoadname();
        // getconnect();
        // getstatusIN();
        // getrangeOflocation();
        // Start location service here or do something else
      },
      onDenied: () {
        // return Alert(
        //   context: context,
        //   type: AlertType.warning,
        //   title: "Permission Denied",
        //   desc:
        // "Please Allow Location before using this apps, and go to setting your phone ...",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "Go Setting",
        //         style: TextStyle(color: Colors.white, fontSize: 18),
        //       ),
        // onPressed: () async {
        //   Navigator.pop(context);
        //   await requestPerm();
        // },
        //       color: Color.fromRGBO(0, 179, 134, 1.0),
        //     ),
        //   ],
        // ).show();
        return showCustAlert(
            height: 290,
            context: context,
            title: "Permission Denied",
            buttonString: "Go Setting",
            onSubmit: () async {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            detailContent:
                "Please Allow Location before using this apps, and go to setting your phone ...",
            pathLottie: "warning");

        // Show a message asking the user to reconsider or do something else
      },
    );
    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationOptions)
    //         .listen((Position position) {
    //   print(position == null
    //       ? 'Unknown'
    //       : position.latitude.toString() +
    //           ', ' +
    //           position.longitude.toString());
    // });

    _determinePosition();

    super.initState();
  }

  cekPerm() async {
    var statusLoc = await Permission.location.status;
    var statusCam = await Permission.camera.status;
    if (statusLoc.isUndetermined || statusCam.isUndetermined) {
      return requestPerm();
      // We didn't ask for permission yet.
    }
    if (statusLoc.isDenied || statusCam.isDenied) {
      return requestPerm();
    }
  }

  requestPerm() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
  // void getLocation() async {
  //   try {

  //   } on PlatformException catch (e) {
  //     print('PlatformException $e');
  //     print("Kena Errornya nih");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentEmail = getParentInfo.email;
    parentID = getParentInfo.id;
    parentCreated_At = getParentInfo.created_at;
    parentImagesProf = getParentInfo.image_profile;
    print("PROCECSS ST => " + proccess.toString());
    // Timer.periodic(new Duration(seconds: 40), (timer) {
    //   debugPrint(timer.tick.toString());

    //   print("delaay");
    // });

    return Scaffold(
      appBar: CustomAppBar(
        title: "Attendance",
      ),
      // body: CustomScrollView(
      //   physics: ClampingScrollPhysics(),
      //   slivers: <Widget>[
      //     _buildHeader(screenHeight),
      //     _buildPreventionTips(screenHeight),
      //     _buildYourOwnTest(screenHeight),
      //   ],
      // ),
      body: Container(color: Colors.white, child: _body(screenHeight)),
    );
  }

  Widget _body(double screenHeight) {
    double width = MediaQuery.of(context).size.width;
    String formattedTime = DateFormat.H().format(now);

    return Container(
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [Colors.white, Color.fromRGBO(208, 210, 221, 1)])),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();

          return;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  width: width / 1.1,
                  height: 350,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(14, 69, 84, 1),
                            borderRadius: BorderRadius.circular(7)),
                        width: width / 1.1,
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      ),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: (parentImagesProf == null
                                  ? new AssetImage("dev_assets/paytm/orang.png")
                                  : new NetworkImage(parentImagesProf)),
                              radius: 55,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(27, 104, 125, 1),
                                  borderRadius: BorderRadius.circular(7)),
                              width: 190,
                              height: 30,
                              child: Center(
                                child: Text(
                                  capitalize(parentName),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                (city != null)
                                    ? '📍 ${city}'
                                    : ' 📍 Please Wait..',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                              child: Text(
                                  messageInfo == null
                                      ? 'Jika belum melakukan absen silahkan absen waktu absen 05:00-13:00 dan waktu pulang 17:00'
                                      : '${messageInfo}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontFamily: "Montserrat",
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  )),
                            ),
                            ('${time_in}'.length < 10)
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Color.fromRGBO(27, 104, 125, 1),
                                    ),
                                    width: 80,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'dev_assets/paytm/watch.png',
                                          width: 20,
                                          height: 20,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            'Time In : -',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontFamily: "Lato"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Color.fromRGBO(27, 104, 125, 1),
                                    ),
                                    width: width / 2.9,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'dev_assets/paytm/watch.png',
                                          width: 20,
                                          height: 20,
                                          alignment: Alignment.centerLeft,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Text(
                                            '${time_in}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontFamily: "Lato"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: FlatButton(
                                    minWidth: 170,
                                    height: 40,
                                    onPressed: () async {
                                      setState(() {
                                        notif.clear();
                                        city = "Please wait...";
                                        messageInfo =
                                            "Wait getting data process...";
                                        proccess = true;
                                      });
                                      if (proccess) {
                                        showLoadingProgress(context);
                                      }

                                      print("PROCCESS DI BUTTON =>" +
                                          proccess.toString());
                                      await getconnect();
                                      await getNotification();
                                      await getCurrentLocation();
                                      //await getLocation();
                                      await getRoadname();
                                      await getstatusIN();
                                      await getrangeOflocation();
                                      print(menuLeave);
                                      if (menuLeave) {
                                        setState(() {
                                          proccess = false;
                                        });
                                        //print(menuLeave);
                                        // Navigator.pop(context);
                                        if (int.parse(formattedTime) <= 12) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => GoAttend(
                                                      lat: latitude,
                                                      long: longitude,
                                                      name: parentName,
                                                      user_id: parentID,
                                                      // menuLeave: menuLeave,
                                                    )),
                                          );
                                        } else {
                                          print("Masuk else lebih dari jam 12");
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) => SurveyPage(
                                          //             lat: latitude,
                                          //             long: longitude,
                                          //             name: parentName,
                                          //             user_id: parentID,
                                          //           )),
                                          // );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => GoAttend(
                                                      lat: latitude,
                                                      long: longitude,
                                                      name: parentName,
                                                      user_id: parentID,
                                                    )),
                                          );
                                        }

                                        //
                                      } else {
                                        setState(() {
                                          proccess = false;
                                        });
                                        // Alert(
                                        //   style: AlertStyle(
                                        //     animationType:
                                        //         AnimationType.fromTop,
                                        //     isCloseButton: true,
                                        //     isOverlayTapDismiss: false,
                                        //   ),
                                        //   context: context,
                                        //   type: AlertType.warning,
                                        //   title: "Warning !!",
                                        //   desc:
                                        // "Menu is disable ,you not allow to access this menu ..😩",
                                        //   buttons: [
                                        //     DialogButton(
                                        //       child: Text(
                                        //         "Close",
                                        //         style: TextStyle(
                                        //             color: Colors.black,
                                        //             fontSize: 18),
                                        //       ),
                                        //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
                                        // onPressed: () {
                                        //   // Navigator.pop(context);
                                        // },
                                        //       color: Color.fromRGBO(
                                        //           0, 179, 134, 1.0),
                                        //     ),
                                        //   ],
                                        // ).show();
                                        showCustAlert(
                                            height: 290,
                                            context: context,
                                            title: "Warning !!!",
                                            detailContent:
                                                "Menu is disable ,you not allow to access this menu ..😩",
                                            buttonString: "Close",
                                            onSubmit: () {
                                              Navigator.pop(context);
                                            },
                                            pathLottie: "warning");
                                      }
                                    },
                                    child: Text(
                                      "Go Attend",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    textColor: Colors.white,
                                    color: Color.fromRGBO(27, 104, 125, 1),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(7.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: FlatButton(
                                    minWidth: 20,
                                    height: 40,
                                    onPressed: () async {
                                      showLoadingProgress(context);
                                      await getstatusIN();
                                      await getRoadname();
                                      await getCurrentLocation();
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.refresh),
                                    textColor: Colors.white,
                                    color: Color.fromRGBO(27, 104, 125, 1),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CarouselSlider.builder(
                      itemCount: getRecentNotif(screenHeight).length,
                      options: CarouselOptions(
                          aspectRatio: 16 / 7,
                          viewportFraction: 0.999,
                          enableInfiniteScroll: false,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          onPageChanged: (index, reason) {
                            setState(() => activeindex = index);
                          }),
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          getRecentNotif(screenHeight)[itemIndex]),
                ),
                buildindicator(screenHeight)
              ]),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                padding: const EdgeInsets.all(0.0),
                height: screenHeight * 0.18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(255, 111, 247, 232),
                      Color.fromARGB(255, 31, 126, 161)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Stack(children: [
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Opacity(
                        child: Image.asset(
                          'assets/images/healthcare1.png',
                          fit: BoxFit.contain,
                        ),
                        opacity: 0.2),
                  ),
                  Positioned(
                    top: 30,
                    right: 30,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Stay Safe My Family!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Lato"),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'If you have any question, \nplease contact our IT, thanks.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "Montserrat"),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //MAKE WIDGET LATE ATTEND, IN TOLERANCE , OUT DATA
  List<Job> findJobs() {
    return jobs;
  }

  List<NotificationOffice> findNotif() {
    return notif;
  }

  List<Widget> getRecentJobs(screenHeight) {
    List<Widget> recentJobCards = [];
    List<Job> jobs = findJobs();
    for (Job job in jobs) {
      recentJobCards.add(getJobCard(job));
    }
    return recentJobCards;
  }

  List<Widget> getRecentNotif(screenHeight) {
    List<Widget> recentNotif = [];
    List<NotificationOffice> jobs = findNotif();
    for (NotificationOffice not in notif) {
      recentNotif.add(getNotif(not, screenHeight));
    }
    return recentNotif;
  }

  Widget getNotif(NotificationOffice notif, screenHeight) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 10.0,
      ),
      padding: const EdgeInsets.fromLTRB(25, 0, 10, 10),
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            // colors: [Palette.bluecolor, Palette.lightcolor],
            colors: [
              Color.fromRGBO(0, 117, 255, 1),
              Color.fromRGBO(98, 168, 220, 1),
            ]
            // colors: [
            //   Color.fromRGBO(9, 9, 121, 1),
            // ]
            //
            ),
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Stack(children: [
        Positioned(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 150, top: 10),
                child: Opacity(
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.transparent, BlendMode.color),
                    child: Image.network(
                      notif.images,
                      colorBlendMode: BlendMode.color,
                      width: 120,
                      height: 120,
                    ),
                  ),
                  opacity: 0.2,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${notif.title}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Lato",
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                '${notif.keterangan}',
                style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontSize: _formatSize(notif.keterangan)),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget getJobCard(Job job) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 20, bottom: 30, top: 30),
      height: 150,
      width: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              blurRadius: 20.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: job.userPict,
              ),
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black), text: job.name),
                ),
              ),
            ],
          ),
          Text(job.time + " - " + job.keterangan,
              style: jobCardTitileStyleBlack),
          Text(job.location, style: salaryStyle),
          //Text(makeSalaryToK(job.salary), style: salaryStyle)
        ],
      ),
    );
  }

  //GET LOCATION  LAT/ LONG FUNCTION
  Future getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      // showLoadingProgress();
    } else {
      // Alert(
      //   context: context,
      //   type: AlertType.warning,
      //   title: "GPS Not Active",
      //   desc: "Please Enable Your GPS ...",
      //   buttons: [
      //     DialogButton(
      //       child: Text(
      //         "Close",
      //         style: TextStyle(color: Colors.white, fontSize: 18),
      //       ),
      //       onPressed: () async {

      //         //await Geolocator.openLocationSettings();
      //       },
      //       color: Color.fromRGBO(0, 179, 134, 1.0),
      //     ),
      //   ],
      // ).show();
      showCustAlert(
          height: 280,
          context: context,
          title: "GPS Not Active",
          detailContent: "Please Enable Your GPS",
          buttonString: "Ok",
          onSubmit: () {
            Navigator.popUntil(
              context,
              ModalRoute.withName('/attendance'),
            );
            Geolocator.openLocationSettings();
          },
          pathLottie: "warning");
    }
    await BackgroundLocation().getCurrentLocation().then((location) {
      var lat = location.latitude.toDouble();
      var long = location.longitude.toDouble();
      setState(() {
        latitude = lat;
        longitude = long;
        proccess = true;
      });
      print("This is current Location LAT => " +
          latitude.toString() +
          "LONG => " +
          longitude.toString());
    });
    // TrustLocation.onChange.listen((values) => setState(() {
    //       latitude = double.parse(values.latitude);
    //       longitude = double.parse(values.longitude);
    //       _isMockLocation = values.isMockLocation;
    //       city = "LOKASI";
    //       print("This is current Location LAT => " +
    //           latitude.toString() +
    //           "LONG => " +
    //           longitude.toString());

    //       print("IS MOCK => " + _isMockLocation.toString());
    //       // time = DateTime.fromMillisecondsSinceEpoch(values.time.toInt())
    //       //     .toString();
    //     }));
  }

  //GET ROAD NAME / SUB CITY
  getRoadname() async {
    final coordinates = new Coordinates(latitude, longitude);
    try {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);

      var first = addresses.first;
      setState(() {
        addressName = first.addressLine;
        city = (first.subAdminArea == null)
            ? first.featureName
            : first.subAdminArea;
        proccess = false;
      });
      print(
          "CITY => ${first.featureName} : ${first.addressLine}, SUBADMINAREA ${first.subAdminArea}");
    } catch (e) {
      print(e);
    }
  }

  //REMOVE VALUE SHAREDPREF AFTER CLICK LOGOUT
  removeValuesSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Remove String
    prefs.remove("username");
    //Remove bool
    prefs.remove("password");
  }

  //GET LATE ATTEND
  getLateAttend() {
    GetHelper.getLastAttend().then((datanya) {
      setState(() {
        datanya.forEach((element) {
          jobs.add(new Job(
              "${element['name']}",
              "${element['keterangan']}",
              (element['img'] == null
                  ? new AssetImage("dev_assets/paytm/orang.png")
                  : new NetworkImage(element['img'])),
              "${element['waktu']}",
              "${element['location']}"));
        });
      });
    });
  }

  getNotification() {
    notif.clear();
    GetHelper.getNotification().then((datanya) {
      setState(() {
        datanya.forEach((element) {
          notif.add(new NotificationOffice(
              "${element['title']}",
              "${element['keterangan']}",
              "${element['images']}",
              "${element['time']}"));
        });
        //proccess = false;
      });
    });
  }

  //GET STATUS IN
  getstatusIN() async {
    if (isInternetOn == false) {
    } else {
      //showLoadingProgress();

    }
    if (proccess == true) {
      showLoadingProgress(context);
    }
    try {
      final response = await http.get(
        "https://la-att.intek.co.id/api/getstatusIN/${parentID.toString()}",
      );

      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);

        setState(() {
          menuLeave = userData["status"];
          urlprofileimage = userData["imagesprof"];
          messageInfo = userData["message"];
          time_in = userData["time"];
          proccess = false;
        });

        if (userData["status"] == false) {
          // Alert(
          //   style: AlertStyle(
          //     animationType: AnimationType.fromTop,
          //     isCloseButton: false,
          //     isOverlayTapDismiss: false,
          //   ),
          //   context: context,
          //   type: AlertType.info,
          //   title: "",
          //   desc: "",
          //   buttons: [
          //     DialogButton(
          //       child: Text(
          //         "Close",
          //         style: TextStyle(color: Colors.white, fontSize: 18),
          //       ),
          //       //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
          //       onPressed: () {
          //         Navigator.popUntil(
          //           context,
          //           ModalRoute.withName('/attendance'),
          //         );
          //       },
          //       color: Color.fromRGBO(0, 179, 134, 1.0),
          //     ),
          //   ],
          // ).show();
          showCustAlert(
              height: 310,
              context: context,
              title: "Hi , ${parentName}",
              detailContent: "${userData["message"]}",
              buttonString: "Close",
              onSubmit: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/attendance'),
                );
              },
              pathLottie: "warning");
        }
        print(userData);

        //return userData;

      }
    } catch (e) {
      print(e);
    }
  }

  getrangeOflocation() async {
    String formattedTime = DateFormat.H().format(now);
    if (isInternetOn == false) {
    } else {
      //showLoadingProgress();
    }
    // if (proccess == true) {
    //   showLoadingProgress();
    //   print("MASUK SINI");
    // }
    try {
      final response = await http.get(
        "https://la-att.intek.co.id/api/range/check/${parentID.toString()}?lat=${latitude}&long=${longitude}",
      );

      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);

        setState(() {
          menuLeave = userData["status"];
          messageRange = userData["message"];
        });
        if (menuLeave) {
          Navigator.pop(context);

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => GoAttend(
          //             lat: latitude,
          //             long: longitude,
          //             name: parentName,
          //             user_id: parentID,
          //           )),
          // );
        } else {
          // Alert(
          //   style: AlertStyle(
          //     animationType: AnimationType.fromTop,
          //     isCloseButton: false,
          //     isOverlayTapDismiss: false,
          //   ),
          //   context: context,
          //   type: AlertType.info,
          //   title: "Hi , ${parentName}",
          //   desc: "${userData["message"]}",
          //   buttons: [
          //     DialogButton(
          //       child: Text(
          //         "Close",
          //         style: TextStyle(color: Colors.white, fontSize: 18),
          //       ),
          //       //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
          //       onPressed: () {
          //         // Navigator.of(context).pop();
          //         Navigator.popUntil(
          //           context,
          //           ModalRoute.withName('/attendance'),
          //         );
          //       },
          //       color: Color.fromRGBO(0, 179, 134, 1.0),
          //     ),
          //   ],
          // ).show();
          showCustAlert(
              height: 310,
              context: context,
              title: "Hi , ${parentName}",
              detailContent: "${userData["message"]}",
              buttonString: "Close",
              onSubmit: () {
                Navigator.popUntil(
                  context,
                  ModalRoute.withName('/attendance'),
                );
              },
              pathLottie: "warning");
        }
        print("SAMPE SINI GETRANGE " + userData);
      }
    } catch (e) {
      print(e);

      setState(() {
        proccess = false;
      });
    }
  }

  // showLoadingProgress() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           content: Container(
  //               alignment: Alignment.center,
  //               height: 100,
  //               width: 100,
  //               child: Center(
  //                 child: CircularProgressIndicator(
  //                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
  //                 ),
  //               )),
  //         );
  //       }).then((val) {
  //     print(val);
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (BuildContext context) {
  //           return MainParentPage();
  //         },
  //       ),
  //     );
  //   });
  // }
  // showLoadingProgress() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return LoadingAlert();
  //       });
  // }

  //Ini saya tambahin baru kak buat  capitalize
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future getconnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
        menuLeave = false;
      });
      _alertphoneconnection(context);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
      // setState(() async {
      //   wifiBSSID = await (Connectivity().getWifiBSSID());
      //   wifiIP = await (Connectivity().getWifiIP());
      //   wifiName = await (Connectivity().getWifiName());
      // });

    }
    setState(() {
      proccess = false;
    });
  }

  Widget buildindicator(screenHeight) {
    return AnimatedSmoothIndicator(
        effect: SlideEffect(
            activeDotColor: Color.fromRGBO(27, 104, 125, 1),
            dotColor: Colors.grey,
            dotWidth: 20,
            dotHeight: 8),
        activeIndex: activeindex,
        count: getRecentNotif(screenHeight).length);
  }

  saveSFstring(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('city', city);
    prefs.setString('lat', latitude.toString());
    prefs.setString('long', longitude.toString());

    print("saving city and to shared pref");
  }

  _alertphoneconnection(context) {
    // Alert(
    //   style: AlertStyle(
    //     animationType: AnimationType.fromTop,
    //     isCloseButton: false,
    //     isOverlayTapDismiss: false,
    //   ),
    //   context: context,
    //   type: AlertType.warning,
    //   title: "Connection Lose ...",
    //   desc: "Please check your phone connection ,thanks ..😩",
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "Exit",
    //         style: TextStyle(color: Colors.white, fontSize: 18),
    //       ),
    //       onPressed: () {
    //         SystemNavigator.pop();
    //       },
    //       color: Color.fromRGBO(0, 179, 134, 1.0),
    //     ),
    //   ],
    // ).show();
    showCustAlert(
        height: 290,
        context: context,
        title: "Connection Lose",
        detailContent: "Please check your phone connection ,thanks ..😩",
        buttonString: "Exit",
        onSubmit: () {
          SystemNavigator.pop();
        },
        pathLottie: "warning");
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();

    super.dispose();
  }
}
