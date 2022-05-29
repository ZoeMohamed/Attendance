import 'package:schools_management/widgets/finacash/AnimatedBottomNavBar.dart';
import 'package:schools_management/screens/Finance/DespesasResumo.dart';
import 'package:schools_management/screens/Finance/HomePage.dart';
import 'package:schools_management/screens/Finance/ReceitasResumo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InicialPage extends StatefulWidget {
  static const routeName = '/finance';
  final List<BarItem> barItems = [
    BarItem(
      text: "Money OUT",
      iconData: Icons.remove_circle_outline,
      color: Color.fromRGBO(14, 69, 84, 1),
      svgActive: 'dev_assets/paytm/money-out-active.svg',
      svgNonActive: 'dev_assets/paytm/money-out-nonactive.svg',
    ),
    BarItem(
      text: "Home",
      iconData: Icons.home,
      color: Color.fromRGBO(14, 69, 84, 1),
      svgActive: 'dev_assets/paytm/home2.svg',
      svgNonActive: 'dev_assets/paytm/home-nonactive.svg',
    ),
    BarItem(
      text: "Money IN",
      iconData: Icons.add_circle_outline,
      color: Color.fromRGBO(14, 69, 84, 1),
      svgActive: 'dev_assets/paytm/money-in-active.svg',
      svgNonActive: 'dev_assets/paytm/money-in-nonactive.svg',
    ),
    /*BarItem(
      text: "Search",
      iconData: Icons.search,
      color: Colors.yellow.shade900,
    ),
    */
  ];

  @override
  _InicialPageState createState() => _InicialPageState();
}

class _InicialPageState extends State<InicialPage> {
  int selectedBarIndex = 1;

  @override
  Widget build(BuildContext context) {
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

    List<Widget> telas = [DespesasResumo(), HomePage(), ReceitasResumo()];

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
