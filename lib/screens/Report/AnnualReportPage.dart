import 'package:flutter/material.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
// import 'package:schools_management/widgets/covid/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class AnnualReportPage extends StatefulWidget {
  static const routeName = '/annualreport';
  @override
  _AnnualReportPageState createState() => _AnnualReportPageState();
}

class _AnnualReportPageState extends State<AnnualReportPage> {
  CalendarController calendarController;
  void initState() {
    // TODO: implement initState
    super.initState();

    calendarController = CalendarController();
    if (DateTime.now().month != false) {
      //saldoAtual = "1259";
    }

    // var formatter = new DateFormat('yyyy-MM');
    // var bulannya = formatter.format(dataAtual);
  }

  List<String> _locations = ['2022', '2021', '2020', '2019']; // Option 2
  String _selectedLocation; // Option 2
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: "Annual Report",
        ),
        body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                // image: AssetImage('dev_assets/1.png'),
                image: AssetImage('dev_assets/home_bg.png'),
                fit: BoxFit.fill,
                opacity: 0.3),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Annual Attendance\nDetails",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: Offset.zero,
                                        blurRadius: 2,
                                        spreadRadius: 1)
                                  ]),
                              child: DropdownButtonFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    // fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat"),
                                icon: Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.black,
                                ),
                                elevation: 0,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 17),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                value: _selectedLocation,
                                hint: Text('2022'),
                                items: _locations.map((location) {
                                  return DropdownMenuItem(
                                    child: new Text(location),
                                    value: location,
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocation = newValue;
                                  });
                                },
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset.zero,
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],
                            color: Colors.white),
                        height: 120,
                        width: width / 2.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromRGBO(
                                          51, 197, 126, 1)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "On Time",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              "89%",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset.zero,
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],
                            color: Colors.white),
                        height: 120,
                        width: width / 2.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromRGBO(
                                          238, 156, 48, 1)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Late",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              "6%",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset.zero,
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],
                            color: Colors.white),
                        height: 120,
                        width: width / 2.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(5, 101, 119, 1)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Permit",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              "3%",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  offset: Offset.zero,
                                  blurRadius: 2,
                                  spreadRadius: 1)
                            ],
                            color: Colors.white),
                        height: 120,
                        width: width / 2.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(217, 62, 57, 1)),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "No Present",
                                  style: TextStyle(
                                      fontFamily: "Montserrat", fontSize: 12),
                                ),
                              ],
                            ),
                            Text(
                              "1%",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              offset: Offset.zero,
                              blurRadius: 2,
                              spreadRadius: 1)
                        ]),
                    child: Column(
                      children: [
                        TableCalendar(
                          calendarController: calendarController,
                          locale: "en_US",
                          headerStyle: HeaderStyle(
                              headerPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              // formatButtonTextStyle: TextStyle(color: Colors.red),
                              formatButtonShowsNext: false,
                              formatButtonVisible: false,
                              centerHeaderTitle: true,
                              titleTextStyle: TextStyle(
                                  fontFamily: "Lato",
                                  color: Color.fromRGBO(14, 69, 84, 1),
                                  fontSize: 16)),
                          calendarStyle:
                              CalendarStyle(outsideDaysVisible: false),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.transparent),
                            weekendStyle: TextStyle(color: Colors.transparent),
                          ),
                          rowHeight: 0,
                          initialCalendarFormat: CalendarFormat.month,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
