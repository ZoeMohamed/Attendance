import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/models/report.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:schools_management/screens/Leave/HistoryLeavePage.dart';
import 'package:schools_management/screens/Leave/HistoryLeavePage.dart';
import 'package:schools_management/screens/Leave/LeavePage.dart';
import 'package:schools_management/screens/Leave/RequestLeavePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schools_management/screens/Report/ReportPage.dart';

class InicialLeavePage extends StatefulWidget {
  static const routeName = '/leave';
  final List<BarItem> barItems = [
    BarItem(
      text: "Leave History",
      // iconData: Icons.remove_circle_outline,
      color: Color.fromRGBO(14, 69, 84, 1),
      // svgActive: 'Icons.',
      active: FluentIcons.history_20_filled,
      nonActive: FluentIcons.history_20_regular,
    ),
    BarItem(
      text: "Leave",
      iconData: Icons.home,
      color: Color.fromRGBO(14, 69, 84, 1),
      // svgActive: 'Icons.',
      active: FluentIcons.home_20_filled,
      nonActive: FluentIcons.home_20_regular,
    ),
    BarItem(
      text: "Leave Add",
      iconData: Icons.add_circle_outline,
      color: Color.fromRGBO(14, 69, 84, 1),
      active: FluentIcons.calendar_person_20_filled,
      nonActive: FluentIcons.calendar_person_20_regular,
    ),
    /*BarItem(
      text: "Search",
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    */
  ];

  @override
  _InicialLeavePageState createState() => _InicialLeavePageState();
}

class _InicialLeavePageState extends State<InicialLeavePage> {
  ParentInf getParentInfo;
  String parentImagesProf;
  String parentName;
  int parentId;
  int parentCuti;

  int selectedBarIndex = 1;

  @override
  Widget build(BuildContext context) {
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentId = getParentInfo.id;
    parentCuti = getParentInfo.sisa_cuti;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //systemNavigationBarColor: Colors.lightBlue[700], // navigation bar color
        //statusBarColor: Colors.lightBlue[700],
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light // status bar color
        ));

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    List<Widget> telas = [
      HistoryLeavePage(
        id: parentId,
      ),
      LeavePage(id: parentId),
      RequestLeavePage(sisa_cuti: parentCuti),
      ReportPage(id:parentId)
    ];

    //_allMov();
    //print("\nMes atual: " + DateTime.now().month.toString());
    return Scaffold(
      body: telas[selectedBarIndex],
      bottomNavigationBar: AnimatedBottomBar(
        barItems: widget.barItems,
        animationDuration: const Duration(milliseconds: 150),
        barStyle: BarStyle(fontSize: width * 0.045, iconSize: width * 0.07),
        onBarTap: (index) {
          setState(() {
            selectedBarIndex = index;
          });
        },
      ),
    );
  }
}

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final Function onBarTap;
  final BarStyle barStyle;

  AnimatedBottomBar(
      {this.barItems,
      this.animationDuration = const Duration(milliseconds: 500),
      this.onBarTap,
      this.barStyle});

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with TickerProviderStateMixin {
  int selectedBarIndex = 1;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.white,
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: width * 0.04, //32.0,
          top: width * 0.04, //16.0,
          left: width * 0.04, // 16.0,
          right: width * 0.04, // 16.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: _buildBarItems(context, width),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems(BuildContext contex, double largura) {
    List<Widget> _barItems = List();
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      _barItems.add(InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = i;
            widget.onBarTap(selectedBarIndex);
          });
        },
        child: AnimatedContainer(
          padding: EdgeInsets.symmetric(
              horizontal: largura * 0.04, vertical: largura * 0.015),
          duration: widget.animationDuration,
          decoration: BoxDecoration(
              color: isSelected
                  ? Colors.transparent
                  // ? Color.fromRGBO(14, 69, 84, 1)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Icon(
              //   item.iconData,
              //   // color: isSelected ? item.color : Colors.black,
              //   color: isSelected ? Colors.white : item.color,
              //   size: widget.barStyle.iconSize,
              // ),
              isSelected
                  // ? SvgPicture.asset(
                  //     item.svgActive,
                  //     width: 23,
                  //     height: 23,
                  //     // color: isSelected ? Colors.white : item.color,
                  //   )
                  ? Icon(
                      item.active,
                      color: item.color,
                    )
                  : Icon(
                      item.nonActive,
                      color: item.color,
                    ),

              // SvgPicture.asset(
              //   item.svg,
              //   width: 23,
              //   height: 23,
              //   color: isSelected ? Colors.white : item.color,
              // ),
              SizedBox(
                width: largura * 0.01,
              ),
              // AnimatedSize(
              //   duration: widget.animationDuration,
              //   curve: Curves.easeInOut,
              //   vsync: this,
              //   child: Text(
              //     isSelected ? item.text : "",
              //     style: TextStyle(
              //         color: item.color,
              //         fontWeight: widget.barStyle.fontWeight,
              //         fontSize: widget.barStyle.fontSize),
              //   ),
              // )
            ],
          ),
        ),
      ));
    }
    return _barItems;
  }
}

class BarStyle {
  final double fontSize, iconSize;
  final FontWeight fontWeight;

  BarStyle(
      {this.fontSize = 16.0,
      this.iconSize = 32,
      this.fontWeight = FontWeight.w600});
}

class BarItem {
  String text;
  IconData active;
  IconData nonActive;
  IconData iconData;
  Color color;

  BarItem({this.text, this.iconData, this.color, this.active, this.nonActive});
}
