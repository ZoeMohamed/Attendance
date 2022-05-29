import 'dart:async';


import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:flutter/material.dart';
import 'package:date_utils/date_utils.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/provider/parent.dart';

import 'package:schools_management/widgets/custAlert.dart';

import 'package:flutter_calendar_carousel/classes/event_list.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:sizer/sizer.dart';

import 'package:intl/intl.dart' show DateFormat;

import 'package:rxdart/rxdart.dart';

import 'package:schools_management/helper/get_helper.dart';

import 'package:schools_management/models/report.dart';

import 'package:schools_management/screens/Report/AnnualReportPage.dart';

import 'package:schools_management/widgets/custom_app_bar.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:table_calendar/table_calendar.dart';

import 'package:intl/intl.dart' show DateFormat;

import 'package:shimmer/shimmer.dart';

class ReportPage extends StatefulWidget {
  final int id;
  ReportPage({this.id});
  static const routeName = '/report';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  ParentInf getParentInfo;
  String parentImagesProf;
  String parentName;
  int parentId;
  String _currentMonth;

  DateTime _targetDateTime = DateTime.now();

  String _mnth = DateFormat.MMMM().format(DateTime.now());

  CalendarCarousel _calendarCarouselNoHeader;

  Future<Report> fetchreport;

  StreamController<Report> _chartController;

  bool _buttonVisibility = true;
  DateTime lastClicked;

  bool _buttonVisibility2 = true;
  DateTime lastClicked2;

  var report = Report();

  String getcurntyear() {
    DateTime year = DateTime.now();

    String year_string = DateFormat.y().format(year);

    return year_string;
  }

  getdata() async {
    GetHelper.fetchReport(_mnth,widget.id).then((value) {
      _chartController.add(value);

      return value;
    });
  }

  void dispose() {
    _chartController.close();
    super.dispose();
  }

  void initState() {
    _currentMonth = DateFormat.yMMM().format(DateTime.now());

    fetchreport = GetHelper.fetchReport(_mnth, widget.id);

    // GetHelper.fetchReport(_mnth).then((value) {
    //   setState(() {
    //     report = value;
    //   });
    // });

    _chartController = BehaviorSubject();

    getdata();
    // gethelper();

    // Future.delayed(const Duration(milliseconds: 500), () {

    //   setState(() {

    //     GetHelper.fetchReport(_mnth).then((value) {

    //       report = value;

    //       print(report.att);

    //     });

    //   });

    // });

    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calendar Carousel

    ;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CalendarCarousel _calendarCarouselNoHeader = CalendarCarousel(
        height: 0,
        targetDateTime: _targetDateTime,
        minSelectedDate: DateTime(int.parse(getcurntyear()), 1),
        maxSelectedDate: DateTime(int.parse(getcurntyear()), 12),
        onCalendarChanged: (DateTime date) {
          this.setState(() {
            _targetDateTime = date;

            _currentMonth = DateFormat.yMMM().format(_targetDateTime);

            _mnth = DateFormat.MMMM().format(_targetDateTime);
          });
        },
      );
      // Add Your Code here.
    });

    //your code goes here

    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    return Container(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Report",
        ),
        body: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // padding: EdgeInsets.only(bottom: 6.0.h),
                    height: 42.0.h,
                    child: StreamBuilder<Report>(
                        stream: _chartController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return showCustAlert(
                                height: 290,
                                context: context,
                                title: "Error",
                                buttonString: "OK",
                                onSubmit: () {
                                  Navigator.pop(context);
                                },
                                detailContent:
                                    "Chart Data Cannot Loaded There an error when Fectching data from API",
                                pathLottie: "error");
                          } else if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              report = snapshot.data;

                              return SfCircularChart(annotations: <
                                  CircularChartAnnotation>[
                                CircularChartAnnotation(
                                    widget: Container(
                                        child: PhysicalModel(
                                            child: Container(),
                                            shape: BoxShape.circle,
                                            elevation: 10,
                                            shadowColor: Colors.black,
                                            color: const Color.fromRGBO(
                                                230, 230, 230, 1)))),
                                CircularChartAnnotation(
                                    widget: Container(
                                  margin: EdgeInsets.only(top: 16.0.h),
                                  child: Column(
                                    children: [
                                      Text(
                                          ((report.att /
                                                          DateUtils.getDaysInMonth(
                                                              int.tryParse(
                                                                  DateFormat.y()
                                                                      .format(
                                                                          _targetDateTime)),
                                                              int.tryParse(
                                                                  DateFormat.M()
                                                                      .format(
                                                                          _targetDateTime)))) *
                                                      100)
                                                  .round()
                                                  .toString() +
                                              "%",
                                          style: TextStyle(
                                            fontSize: 35.0.sp,
                                            color: Color.fromRGBO(
                                              0,
                                              0,
                                              0,
                                              0.8,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 1.0.h,
                                      ),
                                      Text("Come On Time",
                                          style: TextStyle(
                                              fontSize: 11.0.sp,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.8)))
                                    ],
                                  ),
                                ))
                              ], series: <CircularSeries>[
                                DoughnutSeries<ChartData, String>(
                                    pointColorMapper: (ChartData data, _) =>
                                        data.color,
                                    dataSource: [
                                      ChartData('att', report.att.toDouble(),
                                          Color.fromRGBO(38, 199, 193, 1)),
                                      ChartData('late', report.late.toDouble(),
                                          Color.fromRGBO(255, 233, 38, 0.7)),
                                      ChartData(
                                          'notatt',
                                          report.notatt.toDouble(),
                                          Color.fromRGBO(207, 45, 43, 1)),
                                    ],
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    innerRadius: '80%',

                                    // Radius of doughnut

                                    radius: '80%')
                              ]);
                            }
                          }

                          return Container(
                            height: 290,
                            child: SpinKitWave(
                              color: Color(0xFF3e6a76).withOpacity(0.5),
                              size: 25.0,
                            ),
                          );
                        }),
                  ),
                  // Container(
                  //   child: IndicatorsWidget(),
                  //   color: Colors.red,
                  // ),
                  Container(
                    child: IndicatorsWidget(),
                  ),
                  Container(
                    height: 52.0.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.9.h),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset.zero,
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: Colors.white),

                        // height: height / 2.7,

                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.9.w, vertical: 0.1.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  top: 3.8.h,
                                  bottom: 1.9.h,
                                  left: 4.5.w,
                                  right: 4.5.w,
                                ),
                                child: new Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        FluentIcons.chevron_left_20_filled,
                                        size: 24,
                                      ),
                                      onPressed: (_buttonVisibility != true)
                                          ? null
                                          : () {
                                              setState(() {
                                                if (_mnth != "January") {
                                                  
                                                  _targetDateTime = DateTime(
                                                      _targetDateTime.year,
                                                      _targetDateTime.month -
                                                          1);

                                                  _currentMonth =
                                                      DateFormat.yMMM().format(
                                                          _targetDateTime);

                                                  _mnth = DateFormat.MMMM()
                                                      .format(_targetDateTime);

                                                  fetchreport =
                                                      GetHelper.fetchReport(
                                                          _mnth, widget.id);

                                                  GetHelper.fetchReport(
                                                          _mnth, widget.id)
                                                      .then((value) {
                                                    _chartController.add(value);

                                                    return value;
                                                  });

                                                  lastClicked = DateTime.now();
                                                  _buttonVisibility = false;
                                                  // change this seconds with `hours:1`

                                                  if (this.mounted) {
                                                    new Timer(
                                                        Duration(seconds: 1),
                                                        () => setState(() =>
                                                            _buttonVisibility =
                                                                true));
                                                  }
                                                }
                                              });
                                            },
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: Text(
                                        _currentMonth,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    )),
                                    IconButton(
                                      icon: Icon(
                                        FluentIcons.chevron_right_20_filled,
                                        size: 24,
                                      ),
                                      onPressed: (_buttonVisibility2 != true)
                                          ? null
                                          : () {
                                              setState(() {
                                                if (_mnth != "December") {
                                                  _targetDateTime = DateTime(
                                                      _targetDateTime.year,
                                                      _targetDateTime.month +
                                                          1);

                                                  _currentMonth =
                                                      DateFormat.yMMM().format(
                                                          _targetDateTime);

                                                  _mnth = DateFormat.MMMM()
                                                      .format(_targetDateTime);

                                                  fetchreport =
                                                      GetHelper.fetchReport(
                                                          _mnth, widget.id);

                                                  GetHelper.fetchReport(
                                                          _mnth, widget.id)
                                                      .then((value) {
                                                    _chartController.add(value);

                                                    return value;
                                                  });

                                                  lastClicked2 = DateTime.now();
                                                  _buttonVisibility2 = false;
                                                  // change this seconds with `hours:1`

                                                  if (this.mounted) {
                                                    new Timer(
                                                        Duration(seconds: 1),
                                                        () => setState(() =>
                                                            _buttonVisibility2 =
                                                                true));
                                                  }
                                                }
                                              });
                                            },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.0.w),
                                child: Column(
                                  children: [
                                    Container(
                                      child: _calendarCarouselNoHeader,
                                    ),
                                    FutureBuilder<Report>(
                                        future: fetchreport,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Column(
                                              children: [
                                                SizedBox(height: 10.0.h),
                                                Center(
                                                  child: SpinKitWave(
                                                    color: Color(0xFF3e6a76)
                                                        .withOpacity(0.5),
                                                    size: 25.0,
                                                  ),
                                                ),
                                              ],
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshot.hasData) {
                                              report = snapshot.data;
                                              return Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0.7.h),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              2.0.w,
                                                              1.5.h,
                                                              2.0.w,
                                                              1.5.h),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        199,
                                                                        199,
                                                                        199,
                                                                        0.5),
                                                                offset:
                                                                    Offset.zero,
                                                                blurRadius: 10,
                                                                spreadRadius: 0)
                                                          ]),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 4.9.w,
                                                            height: 2.1.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      38,
                                                                      199,
                                                                      193,
                                                                      1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 3.3.w,
                                                          ),
                                                          Text(
                                                            "You have attended for ${(report.att == null) ? "No data" : snapshot.data.att} days",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontSize:
                                                                    10.0.sp),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 3.2.h),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              2.0.w,
                                                              1.5.h,
                                                              2.0.w,
                                                              1.5.h),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        199,
                                                                        199,
                                                                        199,
                                                                        0.5),
                                                                offset:
                                                                    Offset.zero,
                                                                blurRadius: 10,
                                                                spreadRadius: 0)
                                                          ]),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 4.9.w,
                                                            height: 2.1.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      233,
                                                                      38,
                                                                      0.7),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 3.3.w,
                                                          ),
                                                          Text(
                                                            "You come late for ${(snapshot.data.late == 0)
                                                            
                                                            ? "${snapshot.data.late} day":"${snapshot.data.late} days"
                                                            
                                                            }",

                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontSize:
                                                                    10.0.sp),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.2.h,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              2.0.w,
                                                              1.5.h,
                                                              2.0.w,
                                                              1.5.h),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        199,
                                                                        199,
                                                                        199,
                                                                        0.5),
                                                                offset:
                                                                    Offset.zero,
                                                                blurRadius: 10,
                                                                spreadRadius: 0)
                                                          ]),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 4.9.w,
                                                            height: 2.1.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color
                                                                  .fromRGBO(
                                                                      207,
                                                                      45,
                                                                      43,
                                                                      1),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 3.3.w,
                                                          ),
                                                          Text(
                                                            "You are not present for ${(snapshot.data.notatt == 0)
                                                            
                                                            ? "${snapshot.data.notatt} day":"${snapshot.data.notatt} days"
                                                            
                                                            }",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontSize:
                                                                    10.0.sp),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3.2.h,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return showCustAlert(
                                                  height: 290,
                                                  context: context,
                                                  title: "Error",
                                                  buttonString: "OK",
                                                  onSubmit: () {
                                                    Navigator.pop(context);
                                                  },
                                                  detailContent:
                                                      "Chart Data Cannot Loaded There an error when Fectching data from API",
                                                  pathLottie: "error");
                                            }
                                          }

                                          return Container();
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}


class PieData {
  double att;

  double notatt;

  double late;

  var report = Report();

  PieData({this.att, this.notatt, this.late});

  static List<Data> data = [
    Data(
        name: 'On Time',
        percent: 21,
        enable: true,
        color: const Color.fromRGBO(38, 199, 193, 1)),
    Data(
        name: 'Late',
        percent: 20,
        enable: false,
        color: const Color.fromRGBO(255, 233, 38, 0.7)),
    Data(
        name: 'Not Present',
        percent: 20,
        enable: false,
        color: Color.fromRGBO(207, 45, 43, 1)),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  final bool enable;

  Data({this.name, this.percent, this.enable, this.color});
}

class IndicatorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: PieData.data
            .map(
              (data) => Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: buildIndicator(
                    color: data.color,

                    text: data.name,

                    // isSquare: true,
                  )),
            )
            .toList(),
      );

  Widget buildIndicator({
    @required Color color,
    @required String text,
    bool isSquare = false,
    double size = 12,
    Color textColor = const Color.fromRGBO(14, 69, 84, 1),
  }) =>
      Row(
        children: <Widget>[
          SizedBox(
            width: 10.0.w,
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 2.5.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Lato",
              fontSize: 12.0.sp,
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      );
}

class ChartData {
  ChartData(this.x, this.y, this.color);

  final String x;

  final double y;

  final Color color;
}
