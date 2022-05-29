import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/provider/parent.dart';

import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../DashboardMenu.dart';

class LeavePage extends StatefulWidget {
  // static const routeName = '/leave';
  final int id;
  LeavePage({this.id});
  @override
  _LeavePageState createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  DateFormat formatTanggal;
  DateFormat formatBulan;

  Future listLeave;

  ParentInf getParentInfo;
  String parentImagesProf;
  String parentName;
  int parentId;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  icons(icon) {
    if (icon == 0) {
      return FluentIcons.clock_24_filled;
    }
    if (icon == 1) {
      return FluentIcons.checkmark_circle_24_filled;
    }
    if (icon == 2) {
      return FluentIcons.dismiss_circle_24_filled;
    }
  }

  iconsColors(icon) {
    if (icon == 0) {
      return Colors.grey[300];
    }
    if (icon == 1) {
      return Colors.green[300];
    }
    if (icon == 2) {
      return Colors.red[300];
    }
  }

  status(status) {
    if (status == 0) {
      return "Waiting for approval";
    }
    if (status == 1) {
      return "Approved";
    }
    if (status == 2) {
      return "Decline";
    }
  }

  @override
  void initState() {
    formatBulan = DateFormat.MMM('id');

    listLeave = GetHelper().fetchLeave(widget.id);
    super.initState();
  }

  Future<void> _refreshLeave(BuildContext context) async {
    return fetchandrefresh();
  }

  void fetchandrefresh() {
    listLeave = GetHelper().fetchLeave(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentId = getParentInfo.id;

    parentImagesProf = getParentInfo.image_profile;

    print(widget.id);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    print(parentId);
    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 238, 242, 1),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Leave",
            style: TextStyle(
                fontFamily: "Lato",
                color: Color.fromRGBO(14, 69, 84, 1),
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,

        elevation: 0.0,
        // iconTheme: IconThemeData(color: Color.fromRGBO(14, 69, 84, 1)),
        leading: IconButton(
          splashRadius: 20,
          color: Color.fromRGBO(14, 69, 84, 1),
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20.0,
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/app-menu');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => DashboardMenu()),
              ModalRoute.withName('/app-menu'),
            );
          },
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.notifications_none),
          //   iconSize: 28.0,
          //   onPressed: () {},
          // ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Image.asset(
              "assets/images/SII.png",
              width: 20,
            ),
          )
        ],
      ),
      body: Container(
        width: width,
        // height: height,
        constraints: BoxConstraints.expand(width: width, height: height),
        decoration: BoxDecoration(
            image: DecorationImage(
                // image: AssetImage('dev_assets/1.png'),
                image: AssetImage(
                  'dev_assets/home_bg.png',
                ),
                fit: BoxFit.fill,
                opacity: 0.3),
            color: Colors.white),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();

            return;
          },
          child: RefreshIndicator(
            onRefresh: () {
              return _refreshLeave(context);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 40),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: (parentImagesProf == null
                                ? new AssetImage("dev_assets/paytm/orang.png")
                                : new NetworkImage(parentImagesProf)),
                            radius: 55,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              capitalize(parentName),
                              style: const TextStyle(
                                color: Color.fromRGBO(14, 69, 84, 1),
                                fontSize: 23.0,
                                fontFamily: "Lato",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Color.fromRGBO(190, 190, 190, 0.25),
                                      blurRadius: 10,
                                      spreadRadius: 3,
                                      offset: Offset.zero)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Container(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Center(
                                        child: Text(
                                          "Recent Leave Request",
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            // letterSpacing: 0.0,
                                            color:
                                                Color.fromRGBO(14, 69, 84, 0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FutureBuilder(
                                      future: listLeave,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container(
                                            height: height / 2.5,
                                            width: width,
                                            // color: Colors.white,
                                            // color: Colors.red,
                                            child: Center(
                                              child: SpinKitWave(
                                                color: Color(0xFF3e6a76)
                                                    .withOpacity(0.5),
                                                size: 25.0,
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasError) {
                                            return const Text('Error');
                                          } else if (snapshot.hasData) {
                                            return snapshot.data.isEmpty
                                                ? Center()
                                                : Column(
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemCount: snapshot
                                                                    .data ==
                                                                null
                                                            ? 0
                                                            : (snapshot.data
                                                                        .length >
                                                                    3
                                                                ? 3
                                                                : snapshot.data
                                                                    .length),
                                                        // itemCount: 1,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    bottom: 5),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            7),
                                                                color: Colors
                                                                    .white,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Color.fromRGBO(
                                                                          190,
                                                                          190,
                                                                          190,
                                                                          0.25),
                                                                      blurRadius:
                                                                          10,
                                                                      spreadRadius:
                                                                          3,
                                                                      offset: Offset
                                                                          .zero)
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        10),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              15,
                                                                              0,
                                                                              15,
                                                                              0),
                                                                          child:
                                                                              Icon(
                                                                            // FluentIcons
                                                                            //     .checkmark_circle_32_filled,
                                                                            icons(snapshot.data[index].status),
                                                                            size:
                                                                                50,
                                                                            color:
                                                                                iconsColors(snapshot.data[index].status),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Container(
                                                                                width: width / 1.8,
                                                                                child: RichText(
                                                                                  text: new TextSpan(
                                                                                    style: TextStyle(
                                                                                      fontFamily: "Montserrat",
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontSize: 13,
                                                                                      // letterSpacing: 0.0,
                                                                                      color: Color.fromRGBO(14, 69, 84, 1),
                                                                                    ),
                                                                                    children: <TextSpan>[
                                                                                      new TextSpan(text: 'PIC Pengganti : ', style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromRGBO(14, 69, 84, 0.8))),
                                                                                      new TextSpan(
                                                                                        text: snapshot.data[index].replacement_pic,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                            SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Container(
                                                                                width: width / 1.8,
                                                                                child: RichText(
                                                                                  text: new TextSpan(
                                                                                    style: TextStyle(
                                                                                      fontFamily: "Montserrat",
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontSize: 13,
                                                                                      // letterSpacing: 0.0,
                                                                                      color: Color.fromRGBO(14, 69, 84, 1),
                                                                                    ),
                                                                                    children: <TextSpan>[
                                                                                      new TextSpan(text: 'Pekerjaan : ', style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromRGBO(14, 69, 84, 0.8))),
                                                                                      new TextSpan(
                                                                                        text: snapshot.data[index].submitted_job,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                            SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Container(
                                                                                width: width / 1.8,
                                                                                child: RichText(
                                                                                  text: new TextSpan(
                                                                                    style: TextStyle(
                                                                                      fontFamily: "Montserrat",
                                                                                      fontWeight: FontWeight.normal,
                                                                                      fontSize: 13,
                                                                                      // letterSpacing: 0.0,
                                                                                      color: Color.fromRGBO(14, 69, 84, 1),
                                                                                    ),
                                                                                    children: <TextSpan>[
                                                                                      new TextSpan(text: 'Alasan : ', style: TextStyle(fontWeight: FontWeight.w600, color: Color.fromRGBO(14, 69, 84, 0.8))),
                                                                                      new TextSpan(
                                                                                        text: snapshot.data[index].reason,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                            SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Cuti : ",
                                                                                  style: TextStyle(
                                                                                    fontFamily: "Montserrat",
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 13,
                                                                                    // letterSpacing: 0.0,
                                                                                    color: Color.fromRGBO(14, 69, 84, 0.8),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  (snapshot.data[index].days_off_date != null) ? DateFormat('dd ').format(DateTime.parse(snapshot.data[index].days_off_date)) + formatBulan.format(DateTime.parse(snapshot.data[index].days_off_date)) + DateFormat(' yyyy').format(DateTime.parse(snapshot.data[index].days_off_date)) : "Loading...",
                                                                                  style: TextStyle(
                                                                                    fontFamily: "Montserrat",
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontSize: 13,
                                                                                    // letterSpacing: 0.0,
                                                                                    color: Color.fromRGBO(14, 69, 84, 1),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 20,
                                                                                  child: Text(
                                                                                    "-",
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  (snapshot.data[index].back_to_office != null) ? DateFormat('dd ').format(DateTime.parse(snapshot.data[index].back_to_office)) + formatBulan.format(DateTime.parse(snapshot.data[index].back_to_office)) + DateFormat(' yyyy').format(DateTime.parse(snapshot.data[index].back_to_office)) : "Loading...",
                                                                                  style: TextStyle(
                                                                                    fontFamily: "Montserrat",
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontSize: 13,
                                                                                    // letterSpacing: 0.0,
                                                                                    color: Color.fromRGBO(14, 69, 84, 1),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                Text(
                                                                                  "Status : ",
                                                                                  style: TextStyle(
                                                                                    fontFamily: "Montserrat",
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontSize: 13,
                                                                                    // letterSpacing: 0.0,
                                                                                    color: Color.fromRGBO(14, 69, 84, 0.8),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  status(snapshot.data[index].status),
                                                                                  style: TextStyle(
                                                                                    fontFamily: "Montserrat",
                                                                                    fontWeight: FontWeight.normal,
                                                                                    fontSize: 13,
                                                                                    // letterSpacing: 0.0,
                                                                                    color: Color.fromRGBO(14, 69, 84, 1),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            // child: Container(
                                                            //     decoration: BoxDecoration(
                                                            //       boxShadow: [
                                                            //         BoxShadow(
                                                            //           color: Colors.black,
                                                            //         )
                                                            //       ],
                                                            //       color: Colors.white,
                                                            //     ),
                                                            //     width: width,
                                                            //     height: 80,
                                                            //     child: Column(
                                                            //       mainAxisAlignment:
                                                            //           MainAxisAlignment.end,
                                                            //       children: [
                                                            //         Text(snapshot
                                                            //             .data[index].picPengganti),
                                                            // Row(
                                                            //   children: [
                                                            //     Text(snapshot
                                                            //         .data[index].cuti),
                                                            //     SizedBox(
                                                            //       width: 20,
                                                            //       child: Text(
                                                            //         "-",
                                                            //         textAlign:
                                                            //             TextAlign.center,
                                                            //       ),
                                                            //     ),
                                                            //     Text(snapshot
                                                            //         .data[index].masuk),
                                                            //   ],
                                                            // ),
                                                            //         Container(
                                                            //           width: width,
                                                            //           height: 1,
                                                            //           color: Colors.white,
                                                            //         )
                                                            //       ],
                                                            //     )),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      // decoration: BoxDecoration(
                                                      //   borderRadius:
                                                      //       BorderRadius.circular(7),
                                                      //   color: Colors.white,
                                                      //   boxShadow: [
                                                      //     BoxShadow(
                                                      //         color: Color.fromRGBO(
                                                      //             190, 190, 190, 0.25),
                                                      //         blurRadius: 10,
                                                      //         spreadRadius: 3,
                                                      //         offset: Offset.zero)
                                                      //   ],
                                                      // ),
                                                      height: height / 2.5,
                                                      child: Center(
                                                          child: Text(
                                                        'No Recent Leave History',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 10,
                                                          // letterSpacing: 0.0,
                                                          color: Color.fromRGBO(
                                                              14, 69, 84, 0.3),
                                                        ),
                                                      ))),
                                                ],
                                              ),
                                            );
                                          }
                                        } else {
                                          return Text(
                                              'State: ${snapshot.connectionState}');
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
