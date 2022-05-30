
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:countup/countup.dart';

import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:rxdart/subjects.dart';

import 'package:schools_management/models/Gridmodel.dart';

import 'package:schools_management/models/ImageSliderModel.dart';

import 'package:schools_management/models/report.dart';

import 'package:schools_management/provider/parent.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:schools_management/screens/login_page.dart';

import 'package:schools_management/helper/get_helper.dart';

import 'package:intl/intl.dart';

import 'package:flutter_svg/svg.dart';

import 'package:blinking_text/blinking_text.dart';

import 'package:intl/date_symbol_data_local.dart';

class DashboardMenu extends StatefulWidget {
  static const routeName = '/app-menu';

  @override
  _DashboardMenuState createState() => _DashboardMenuState();
}

class _DashboardMenuState extends State<DashboardMenu> {
  String formatJam;

  String formatMenit;

  DateFormat formatHari;

  DateFormat formatTanggal;

  DateFormat formatTahun;

  var report = Report();

  StreamController<Report> _linearcontroller;

  int index = 0;

  ParentInf getParentInfo;

  String parentName;

  String parentEmail;

  String parentCreated_At;

  String parentImagesProf;

  String imgcapt;

  int parentID;

  List<ImageSliderModel> list = new List();

  // PermissionStatus _permissionStatus = PermissionStatus.unknown;

  bool showImageWidget = false;

  @override
  void initState() {
    cekPerm();

    Timer.periodic(Duration(milliseconds: 900), (timer) {
      if (this.mounted) {
        setState(() {
          formatJam = DateFormat('kk').format(DateTime.now());

          formatMenit = formatMenit = DateFormat(' mm').format(DateTime.now());
        });
      }
    });

    initializeDateFormatting();

    formatHari = new DateFormat.EEEE('id');

    formatTanggal = DateFormat.MMMMd('id');

    formatTahun = DateFormat.y('id');

    // TODO: implement initState

    //_getImageSliderList();

    GetHelper.getBanner().then((datanya) {
      setState(() {
        datanya.forEach((element) {
          list.add(new ImageSliderModel("${element['images']}"));
        });
      });
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showImageWidget = true;
      });
    });

    //print("TOTAL DATA LIST " + _getImageSliderList().length.toString());

    // Get data hadir,telat,tidak hadir

  WidgetsBinding.instance.addPostFrameCallback((_) {
    var provider = Provider.of<Parent>(context, listen: false).getParentInf();
    parentID = provider.id;
    getdata(parentID);
    
  });
    _linearcontroller = BehaviorSubject();


    super.initState();
  }

  getdata(id) async {
    GetHelper.fetchReport(DateFormat.MMMM().format(DateTime.now()),id).then((value) {
      report = value;

      _linearcontroller.add(value);

      return value;
    });
  }

  cekPerm() async {
    var statusLoc = await Permission.location.status;

    var statusCam = await Permission.location.status;

    if (statusLoc.isUndetermined || statusCam.isUndetermined) {
      return requestPerm();

      // We didn't ask for permission yet.

    }

    if (statusLoc.isDenied || statusCam.isDenied) {
      return requestPerm();
    }

    if (statusLoc.isPermanentlyDenied || statusCam.isPermanentlyDenied) {
      return openAppSettings();
    }
  }

  requestPerm() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();

    print(statuses[Permission.location]);
  }

  // getLocation() async {

  //   if (await Permission.contacts.request().isGranted) {

  //     // Either the permission was already granted before or the user just granted it.

  //   }

  //   // You can request multiple permissions at once.

  //   Map<Permission, PermissionStatus> statuses = await [

  //     Permission.location,

  //     Permission.storage,

  //   ].request();

  //   print(statuses[Permission.location]);

  // }

  removeValuesSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Remove String

    prefs.remove("username");

    //Remove bool

    prefs.remove("password");
  }

  List<ImageSliderModel> getBanner() {
    return list;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    getParentInfo = Provider.of<Parent>(context).getParentInf();

    parentName = getParentInfo.name;

    parentEmail = getParentInfo.email;

    parentID = getParentInfo.id;

    parentCreated_At = getParentInfo.created_at;

    parentImagesProf = getParentInfo.image_profile;

    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 238, 242, 1),

      // appBar: _appBar(),

      body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('dev_assets/home_bg.png'),
                  fit: BoxFit.fill,
                  opacity: 0.7),
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  Color.fromRGBO(237, 238, 242, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: _bodyItem()),
    );
  }

  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget _bodyItem() {
    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();

    var dateTime = new DateTime.now();

    // String formatHari = DateFormat('EEEEE').format(now);

    // String formatTanggal = DateFormat('d MMMM').format(now);

    // String formatTahun = DateFormat('yyyy').format(now);

    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        children: [
          NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();

              return;
            },
            child: SingleChildScrollView(
              child: Container(
                // height: height,

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hi Welcome",
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color.fromRGBO(152, 152, 152, 1)),
                              ),
                              Container(
                                width: width / 2,
                                child: Text(
                                  capitalize(parentName),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontFamily: "Lato",
                                    color: Color.fromRGBO(92, 92, 92, 1),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Image(
                            height: 35,
                            image: AssetImage('assets/images/logo-intek.png'),
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Color.fromRGBO(170, 207, 215, 1),
                              ),
                              width: width,
                              height: 85,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width: width / 1.65,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(27, 104, 125, 1),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(7),
                                          bottomLeft: Radius.circular(7))),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        formatJam ??
                                            DateFormat('kk')
                                                .format(DateTime.now()),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            fontFamily: "Lato",
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 60.0),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: BlinkText(
                                          ":",
                                          beginColor: Colors.white,
                                          endColor:
                                              Color.fromRGBO(27, 104, 125, 1),
                                          textAlign: TextAlign.center,
                                          duration: Duration(milliseconds: 500),
                                          style: TextStyle(
                                              fontSize: 40,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        formatMenit ??
                                            DateFormat(' mm')
                                                .format(DateTime.now()),
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                            fontFamily: "Lato",
                                            color:
                                                Colors.white.withOpacity(0.95),
                                            fontWeight: FontWeight.w100,
                                            fontSize: 60.0),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 4,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(14, 69, 84, 1),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(7),
                                          bottomRight: Radius.circular(7))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 2),
                                          child: Text(
                                            formatHari.format(dateTime),
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(
                                                letterSpacing: 0.5,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19.0),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 0),
                                          child: Text(
                                            formatTanggal.format(dateTime),
                                            textAlign: TextAlign.end,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white,
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        Text(
                                          formatTahun.format(dateTime),
                                          textAlign: TextAlign.end,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                              fontSize: 17.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Text(
                        "Monthly Performance Data",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color.fromRGBO(37, 87, 100, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        width: width,
                        height: 75,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(14, 69, 84, 1),
                            borderRadius: BorderRadius.circular(7)),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Container(
                                width: width / 4,
                                height: height,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                135, 162, 170, 1)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ATTEND",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, bottom: 3),
                                      child: StreamBuilder<Report>(
                                        stream: _linearcontroller.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.hasData) {
                                              return Row(
                                                children: [
                                                  Countup(
                                                    begin: 0,
                                                    end: snapshot.data.att
                                                        .toDouble(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ),
                                                  Text(
                                                    (snapshot.data.att == 0) ? " Day":" Days",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              );
                                            }
                                          }

                                          return Row(
                                            children: [
                                              Countup(
                                                  begin: 0,
                                                  end: 0,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(
                                                " Day",
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    StreamBuilder<Report>(
                                        stream: _linearcontroller.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.hasData) {
                                              return LinearPercentIndicator(
                                                animation: true,
                                                animationDuration: 1000,
                                                alignment:
                                                    MainAxisAlignment.start,
                                                padding: EdgeInsets.fromLTRB(
                                                    1, 0, 0, 0),
                                                width: 70.0,
                                                lineHeight: 5.0,
                                                percent:
                                                    (snapshot.data.att /DateUtils.getDaysInMonth(int.tryParse(DateFormat.y().format(DateTime.now())), int.tryParse(DateFormat.M().format(DateTime.now()))) )
                                                        .toDouble(),
                                                backgroundColor: Color.fromRGBO(
                                                    198, 198, 198, 100),
                                                progressColor: Color.fromRGBO(
                                                    243, 146, 38, 1),
                                              );
                                            }
                                          }

                                          return LinearPercentIndicator(
                                            animation: true,
                                            animationDuration: 1000,
                                            alignment: MainAxisAlignment.start,
                                            padding:
                                                EdgeInsets.fromLTRB(1, 0, 0, 0),
                                            width: 70.0,
                                            lineHeight: 5.0,
                                            percent: 0.0,
                                            backgroundColor: Color.fromRGBO(
                                                198, 198, 198, 100),
                                            progressColor:
                                                Color.fromRGBO(243, 146, 38, 1),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                              child: Container(
                                width: width / 4,
                                height: height,
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 1,
                                            color: Color.fromRGBO(
                                                135, 162, 170, 1)))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "NOT ATTEND",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, bottom: 3),
                                      child: StreamBuilder<Report>(
                                        stream: _linearcontroller.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.hasData) {
                                              return Row(
                                                children: [
                                                  Countup(
                                                    begin: 0,
                                                    end: snapshot.data.notatt
                                                        .toDouble(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ),
                                                  Text(
                                                    (snapshot.data.notatt == 0) ? " Day":" Days",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              );
                                            }
                                          }

                                          return Row(
                                            children: [
                                              Countup(
                                                  begin: 0,
                                                  end: 0,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(
                                               
                                               " Day",
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    StreamBuilder<Report>(
                                        stream: _linearcontroller.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.hasData) {
                                              return LinearPercentIndicator(
                                                animation: true,
                                                animationDuration: 1000,
                                                alignment:
                                                    MainAxisAlignment.start,
                                                padding: EdgeInsets.fromLTRB(
                                                    1, 0, 0, 0),
                                                width: 70.0,
                                                lineHeight: 5.0,
                                                percent:
                                                    (snapshot.data.notatt /DateUtils.getDaysInMonth(int.tryParse(DateFormat.y().format(DateTime.now())), int.tryParse(DateFormat.M().format(DateTime.now()))) )
                                                        .toDouble(),
                                                backgroundColor: Color.fromRGBO(
                                                    198, 198, 198, 100),
                                                progressColor: Color.fromRGBO(
                                                    243, 146, 38, 1),
                                              );
                                            }
                                          }

                                          return LinearPercentIndicator(
                                            animation: true,
                                            animationDuration: 1000,
                                            alignment: MainAxisAlignment.start,
                                            padding:
                                                EdgeInsets.fromLTRB(1, 0, 0, 0),
                                            width: 70.0,
                                            lineHeight: 5.0,
                                            percent: 0.0,
                                            backgroundColor: Color.fromRGBO(
                                                198, 198, 198, 100),
                                            progressColor:
                                                Color.fromRGBO(243, 146, 38, 1),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 9, 0, 10),
                              child: Container(
                                width: width / 4.5,
                                height: height,
                                decoration: BoxDecoration(
                                    ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "LATE",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, bottom: 3),
                                      child: StreamBuilder<Report>(
                                        stream: _linearcontroller.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.hasData) {
                                              return Row(
                                                children: [
                                                  Countup(
                                                    begin: 0,
                                                    end: snapshot.data.late
                                                        .toDouble(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    duration:
                                                        Duration(seconds: 1),
                                                  ),
                                                  Text(
                                                   (snapshot.data.late == 0) ? " Day" : " Days",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                          return Row(
                                            children: [
                                              Countup(
                                                  begin: 0,
                                                  end: 0,
                                                  duration:
                                                      Duration(seconds: 1),
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              Text(
                                               " Day",
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    StreamBuilder<Report>(
                                        stream: _linearcontroller.stream,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.active) {
                                            if (snapshot.hasData) {
                                              return LinearPercentIndicator(
                                                animation: true,
                                                animationDuration: 1000,
                                                alignment:
                                                    MainAxisAlignment.start,
                                                padding: EdgeInsets.fromLTRB(
                                                    1, 0, 0, 0),
                                                width: 70.0,
                                                lineHeight: 5.0,
                                                percent:
                                                    (snapshot.data.late / DateUtils.getDaysInMonth(int.tryParse(DateFormat.y().format(DateTime.now())), int.tryParse(DateFormat.M().format(DateTime.now()))))
                                                        .toDouble(),
                                                backgroundColor: Color.fromRGBO(
                                                    198, 198, 198, 100),
                                                progressColor: Color.fromRGBO(
                                                    243, 146, 38, 1),
                                              );
                                            }
                                          }

                                          return LinearPercentIndicator(
                                            animation: true,
                                            animationDuration: 1000,
                                            alignment: MainAxisAlignment.start,
                                            padding:
                                                EdgeInsets.fromLTRB(1, 0, 0, 0),
                                            width: 70.0,
                                            lineHeight: 5.0,
                                            percent: 0.0,
                                            backgroundColor: Color.fromRGBO(
                                                198, 198, 198, 100),
                                            progressColor:
                                                Color.fromRGBO(243, 146, 38, 1),
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 100),
                        child: GridView.count(
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          children: List<GridItem>.generate(
                              _getGridItemList().length, (int index) {
                            return GridItem(_getGridItemList()[index]);
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 70,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.3,
                    child: FloatingActionButton(
                      backgroundColor: Color.fromRGBO(14, 69, 84, 1),
                      child: Image.asset(
                        'dev_assets/paytm/scan.png',
                        width: 25,
                        height: 25,
                      ),
                      elevation: 0.1,
                      onPressed: () {
                        Navigator.pushNamed(context, '/attendance');
                      },
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Material(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                            // splashColor: Colors.red,

                            // highlightColor: Colors.red,

                            splashRadius: 100,

                            onPressed: () {},

                            icon: SvgPicture.asset('dev_assets/paytm/home2.svg',
                                width: 28.0, height: 28.0),
                          ),
                        ),

                        SizedBox(
                          width: size.width * 0.20,
                        ),


                        Material(
                          color: Colors.transparent,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: IconButton(
                            splashRadius: 100,
                            onPressed: () async{

                              return await AwesomeDialog(
                                  context: context,
                                          dialogType: DialogType.WARNING,
                                          title: "Success: ",
                                          desc: "tes",
                                          body: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Warning",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15.0.sp),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15, right: 15),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Logout From Attendance App ? ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  13.0.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                    
                                                       
                                                        
                                                       
                                                      
                                                      ],
                                                    )),
                                                SizedBox(
                                                  height: 35,
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      DialogButton(
                                                          width: 100,
                                                          color: Colors.red,
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    14.0.sp),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                     DialogButton(
                                                          width: 100,
                                                          color: Colors.green,
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    14.0.sp),
                                                          ),
                                                          onPressed: () async {
                                                                 removeValuesSharedpref();

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                  (Route<dynamic> route) => false);
                                                          })
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )).show();
                        
                            },
                            icon: SvgPicture.asset(
                                'dev_assets/paytm/logout3.svg',
                                width: 30.0,
                                height: 30.0),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<GridModel> _getGridItemList() {
    List<GridModel> list = new List<GridModel>();

    list.add(new GridModel(
      "dev_assets/paytm/attendance2.png",
      '/attendance',
      Color.fromRGBO(14, 69, 84, 1),
    ));

    list.add(new GridModel(
      "dev_assets/paytm/report2.png",

      '/report',

      // '/report',

      Color.fromRGBO(39, 88, 102, 1),
    ));

    list.add(new GridModel(
      "dev_assets/paytm/leave2.png",

      // '/null',

      '/leave',

      Color.fromRGBO(62, 106, 118, 1),
    ));

    list.add(new GridModel(
      "dev_assets/paytm/finance3.png",
      '/finance',
      Color.fromRGBO(62, 106, 118, 1),
    ));

    return list;
  }

  // List<GridModel> _getGridItemList() {

  //   List<GridModel> list = new List<GridModel>();

  //   list.add(new GridModel(

  //     "dev_assets/paytm/attendance2.png",

  //     '/attendance',

  //     Color.fromRGBO(14, 69, 84, 1),

  //   ));

  //   list.add(new GridModel(

  //     "dev_assets/paytm/report2.png",

  //     '',

  //     Color.fromRGBO(39, 88, 102, 1),

  //   ));

  //   list.add(new GridModel(

  //     "dev_assets/paytm/leave2.png",

  //     '/leave',

  //     Color.fromRGBO(62, 106, 118, 1),

  //   ));

  //   list.add(new GridModel(

  //     "dev_assets/paytm/finance3.png",

  //     '/finance',

  //     Color.fromRGBO(62, 106, 118, 1),

  //   ));

  //   return list;

  // }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];

    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}

class GridItem extends StatelessWidget {
  GridModel gridModel;

  GridItem(this.gridModel);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: Ink.image(
        alignment: Alignment.center,
        image: AssetImage(gridModel.imagePath),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          // radius: 16,

          splashColor: Colors.white.withOpacity(0.3),

          onTap: () {
            print(gridModel.route);

            Navigator.pushNamed(context, gridModel.route);
          },
        ),
      ),
    );

    // return GestureDetector(

    //   behavior: HitTestBehavior.opaque,

    //   onTap: () {

    //     Navigator.pushNamed(context, gridModel.route);

    //   },

    //   child: Container(

    //     decoration: BoxDecoration(

    //       borderRadius: BorderRadius.circular(16),

    //       color: gridModel.bgColor,

    //     ),

    //     child: Center(

    //       child: Image.asset(

    //         gridModel.imagePath,

    //         width: height / 2.5,

    //         height: width / 2.5,

    //       ),

    //     ),

    //   ),

    // );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(0, 0); // Start

    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);

    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 10);

    path.arcToPoint(Offset(size.width * 0.60, 10),
        radius: Radius.circular(20.0), clockwise: false);

    path.quadraticBezierTo(size.width * 0.6, 0, size.width * 0.65, 0);

    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.lineTo(0, 20);

    // canvas.drawShadow(path, Colors.black, 5, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
