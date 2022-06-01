import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:schools_management/screens/DashboardMenu.dart';
import 'package:schools_management/screens/Finance/InicialPage.dart';
import 'package:schools_management/screens/Report/ReportPage.dart';
import 'package:schools_management/screens/Leave/inicialLeavePage.dart';
import 'package:schools_management/screens/login_page.dart';
import 'package:schools_management/screens/Attend/bottom_nav_screen.dart';
import 'package:schools_management/screens/Attend/main_parent_page.dart';
import 'package:sizer/sizer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    MaterialColor colorCustom = MaterialColor(0xFF3e6a76, color);
    return MultiProvider(
        // The providers that we are gonna use at the app
        providers: [
          ChangeNotifierProvider(
            create: (context) => Parent(), // parentProvier
          ),
        ],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return OrientationBuilder(builder: (context, orientation) {
              SizerUtil().init(constraints, orientation);
              return MaterialApp(
                title: 'Attendance Intek',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: colorCustom,
                  accentColor: Colors.transparent,
                ),
                home: Login(),
                // home: SuccessAttendScreen(),
                //
                // home: LoginScreen3(), // homepage
                routes: {
                  // route names to mainParentPage and mainTeacherPage
                  BottomNavScreen.routeName: (ctx) => BottomNavScreen(),
                  MainParentPage.routeName: (ctx) => MainParentPage(),
                  InicialPage.routeName: (ctx) => InicialPage(),
                  DashboardMenu.routeName: (ctx) => DashboardMenu(),
                  // LeavePage.routeName: (ctx) => LeavePage(),
                  InicialLeavePage.routeName: (ctx) => InicialLeavePage(),
                  ReportPage.routeName: (ctx) => ReportPage(
                        id: Provider.of<Parent>(context).getParentInf().id,
                      )
                },
              );
            });
          },
        ));
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(62, 106, 118, .1),
  100: Color.fromRGBO(62, 106, 118, .2),
  200: Color.fromRGBO(62, 106, 118, .3),
  300: Color.fromRGBO(62, 106, 118, .4),
  400: Color.fromRGBO(62, 106, 118, .5),
  500: Color.fromRGBO(62, 106, 118, .6),
  600: Color.fromRGBO(62, 106, 118, .7),
  700: Color.fromRGBO(62, 106, 118, .8),
  800: Color.fromRGBO(62, 106, 118, .9),
  900: Color.fromRGBO(62, 106, 118, 1),
};
