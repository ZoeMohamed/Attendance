import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/main.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class HistoryLeavePage extends StatefulWidget {
  // static const routeName = '/leave';
  final int id;
  HistoryLeavePage({this.id});
  @override
  _HistoryLeavePageState createState() => _HistoryLeavePageState();
}

class _HistoryLeavePageState extends State<HistoryLeavePage> {
  Future listLeave;
  DateFormat formatTanggal;
  DateFormat formatBulan;

  Future<void> _refreshLeave(BuildContext context) async {
    return fetchandrefresh();
  }

  void fetchandrefresh() {
    listLeave = GetHelper().fetchLeave(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    listLeave = GetHelper().fetchLeave(widget.id);
    formatBulan = DateFormat.MMM('id');

    super.initState();
  }

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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(237, 238, 242, 1),
      appBar: CustomAppBar(
        title: "Leave History",
      ),
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: Colors.white),
        child: FutureBuilder(
            future: listLeave,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // return Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                //   child: Shimmer.fromColors(
                //     baseColor: Colors.grey[300],
                //     highlightColor: Colors.grey[100],
                //     enabled: true,
                //     child: ListView.builder(
                //       itemBuilder: (context, index) => Padding(
                //         padding: const EdgeInsets.only(bottom: 20.0),
                //         child: Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Container(
                //               width: 48.0,
                //               height: 48.0,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   borderRadius: BorderRadius.circular(7)),
                //             ),
                //             const Padding(
                //               padding: EdgeInsets.symmetric(horizontal: 8.0),
                //             ),
                //             Expanded(
                //               child: Padding(
                //                 padding:
                //                     const EdgeInsets.symmetric(vertical: 5),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: <Widget>[
                //                     Container(
                //                       decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius:
                //                               BorderRadius.circular(7)),
                //                       width: double.infinity,
                //                       height: 8.0,
                //                     ),
                //                     const Padding(
                //                       padding:
                //                           EdgeInsets.symmetric(vertical: 2.0),
                //                     ),
                //                     Container(
                //                       decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius:
                //                               BorderRadius.circular(7)),
                //                       width: double.infinity,
                //                       height: 8.0,
                //                     ),
                //                     const Padding(
                //                       padding:
                //                           EdgeInsets.symmetric(vertical: 2.0),
                //                     ),
                //                     Container(
                //                       width: 40.0,
                //                       height: 8.0,
                //                       decoration: BoxDecoration(
                //                           color: Colors.white,
                //                           borderRadius:
                //                               BorderRadius.circular(7)),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             )
                //           ],
                //         ),
                //       ),
                //       itemCount: 9,
                //     ),
                //   ),
                // );
                return SpinKitWave(
                  color: Color(0xFF3e6a76).withOpacity(0.5),
                  size: 25.0,
                );
                // return Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(7),
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //           color: Color.fromRGBO(
                //               190, 190, 190, 0.25),
                //           blurRadius: 10,
                //           spreadRadius: 3,
                //           offset: Offset.zero)
                //     ],
                //   ),
                //   height: height / 8,
                //   child: SpinKitWave(
                //     color: Color(0xFF3e6a76).withOpacity(0.5),
                //     size: 25.0,
                //   ),
                // );
                // Shimmer.fromColors(
                //   baseColor: Colors.grey[300],
                //   highlightColor: Colors.grey[100],
                //   enabled: true,
                //   child: Column(
                //     children: [
                //       Container(
                //         width: width,
                //         height: 90,
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius:
                //                 BorderRadius.circular(7)),
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       Container(
                //         width: width,
                //         height: 90,
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius:
                //                 BorderRadius.circular(7)),
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       Container(
                //         width: width,
                //         height: 90,
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             borderRadius:
                //                 BorderRadius.circular(7)),
                //       ),
                //     ],
                //   ),
                //   // child: ListView.builder(
                //   //   shrinkWrap: true,
                //   //   primary: false,
                //   //   itemBuilder: (context, index) => Padding(
                //   //     padding: const EdgeInsets.only(bottom: 10.0),
                //   //     child: Row(
                //   //       crossAxisAlignment: CrossAxisAlignment.start,
                //   //       children: [
                //   //         Container(
                //   //           width: width / 1.2,
                //   //           height: 48.0,
                //   //           decoration: BoxDecoration(
                //   //               color: Colors.white,
                //   //               borderRadius: BorderRadius.circular(7)),
                //   //         ),
                //   //       ],
                //   //     ),
                //   //   ),
                //   //   itemCount: 3,
                //   // ),
                // );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return snapshot.data.isEmpty
                      ? Center()
                      : NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowGlow();

                            return;
                          },
                          child: RefreshIndicator(
                            onRefresh: () {
                              return _refreshLeave(context);
                            },
                            child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                // shrinkWrap: true,
                                // primary: false,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      // color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 15, 0),
                                                child: Icon(
                                                  // FluentIcons
                                                  //     .checkmark_circle_32_filled,
                                                  icons(snapshot
                                                      .data[index].status),
                                                  size: 50,
                                                  color: iconsColors(snapshot
                                                      .data[index].status),
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
                                                      width: width / 1.6,
                                                      child: RichText(
                                                        text: new TextSpan(
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                            // letterSpacing: 0.0,
                                                            color:
                                                                Color.fromRGBO(
                                                                    14,
                                                                    69,
                                                                    84,
                                                                    1),
                                                          ),
                                                          children: <TextSpan>[
                                                            new TextSpan(
                                                                text:
                                                                    'PIC Pengganti : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            14,
                                                                            69,
                                                                            84,
                                                                            0.8))),
                                                            new TextSpan(
                                                              text: snapshot
                                                                  .data[index]
                                                                  .replacement_pic,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                      width: width / 1.6,
                                                      child: RichText(
                                                        text: new TextSpan(
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                            // letterSpacing: 0.0,
                                                            color:
                                                                Color.fromRGBO(
                                                                    14,
                                                                    69,
                                                                    84,
                                                                    1),
                                                          ),
                                                          children: <TextSpan>[
                                                            new TextSpan(
                                                                text:
                                                                    'Pekerjaan : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            14,
                                                                            69,
                                                                            84,
                                                                            0.8))),
                                                            new TextSpan(
                                                              text: snapshot
                                                                  .data[index]
                                                                  .submitted_job,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Container(
                                                      width: width / 1.6,
                                                      child: RichText(
                                                        text: new TextSpan(
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 13,
                                                            // letterSpacing: 0.0,
                                                            color:
                                                                Color.fromRGBO(
                                                                    14,
                                                                    69,
                                                                    84,
                                                                    1),
                                                          ),
                                                          children: <TextSpan>[
                                                            new TextSpan(
                                                                text:
                                                                    'Alasan : ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            14,
                                                                            69,
                                                                            84,
                                                                            0.8))),
                                                            new TextSpan(
                                                              text: snapshot
                                                                  .data[index]
                                                                  .reason,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Cuti : ",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13,
                                                          // letterSpacing: 0.0,
                                                          color: Color.fromRGBO(
                                                              14, 69, 84, 0.8),
                                                        ),
                                                      ),
                                                      Text(
                                                        (snapshot.data[index]
                                                                    .days_off_date !=
                                                                null)
                                                            ? DateFormat('dd ').format(DateTime.parse(snapshot
                                                                    .data[index]
                                                                    .days_off_date)) +
                                                                formatBulan.format(DateTime.parse(snapshot
                                                                    .data[index]
                                                                    .days_off_date)) +
                                                                DateFormat(' yyyy').format(
                                                                    DateTime.parse(snapshot
                                                                        .data[index]
                                                                        .days_off_date))
                                                            : "Loading...",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13,
                                                          // letterSpacing: 0.0,
                                                          color: Color.fromRGBO(
                                                              14, 69, 84, 1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                        child: Text(
                                                          "-",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Text(
                                                        (snapshot.data[index]
                                                                    .back_to_office !=
                                                                null)
                                                            ? DateFormat('dd ').format(DateTime.parse(snapshot
                                                                    .data[index]
                                                                    .back_to_office)) +
                                                                formatBulan.format(DateTime.parse(snapshot
                                                                    .data[index]
                                                                    .back_to_office)) +
                                                                DateFormat(' yyyy').format(
                                                                    DateTime.parse(snapshot
                                                                        .data[index]
                                                                        .back_to_office))
                                                            : "Loading...",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13,
                                                          // letterSpacing: 0.0,
                                                          color: Color.fromRGBO(
                                                              14, 69, 84, 1),
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
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13,
                                                          // letterSpacing: 0.0,
                                                          color: Color.fromRGBO(
                                                              14, 69, 84, 0.8),
                                                        ),
                                                      ),
                                                      Text(
                                                        status(snapshot
                                                            .data[index]
                                                            .status),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13,
                                                          // letterSpacing: 0.0,
                                                          color: Color.fromRGBO(
                                                              14, 69, 84, 1),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Divider(
                                              thickness: 1,
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        );
                } else {
                  return Center(
                      child: Text(
                    "No Leave History Available",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      // letterSpacing: 0.0,
                      color: Color.fromRGBO(14, 69, 84, 0.5),
                    ),
                  ));
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            }),
      ),
    );
  }
}
