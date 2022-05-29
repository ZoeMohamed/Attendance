import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:schools_management/screens/DashboardMenu.dart';
import 'package:schools_management/widgets/custAlert.dart';

class SuccessAttendScreen extends StatefulWidget {
  @override
  _SuccessAttendScreentate createState() => _SuccessAttendScreentate();
}

class _SuccessAttendScreentate extends State<SuccessAttendScreen> {
  @override
  // void initState() {
  //   _onAlertButtonsPressed(context);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Success Attend",
            style: TextStyle(
                fontFamily: "Lato",
                color: Color.fromRGBO(14, 69, 84, 1),
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,

        elevation: 0.0,
        // iconTheme: IconThemeData(color: Color.fromRGBO(14, 69, 84, 1)),
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back_ios_new),
          iconSize: 20.0,
          onPressed: () {
            // Navigator.pushReplacementNamed(context, '/app-menu');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return DashboardMenu();
                },
              ),
            );
          },
        ),
        actions: <Widget>[
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
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Lottie.asset("assets/success.json",
                  width: 120, height: 120, frameRate: FrameRate(60)),
              SizedBox(height: 40),
              Text(
                'Thank you for attendance\ntoday',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 20,
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Center(
                  child: RaisedButton.icon(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                icon: Icon(
                  FluentIcons.home_16_filled,
                  size: 20,
                ), // <-- Icon you want.
                textColor: Colors.white,
                color: Color.fromRGBO(14, 69, 84, 1),
                label: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 15),
                ), // <-- Your text.

                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return DashboardMenu();
                    },
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  _onAlertButtonsPressed(context) {
    // Alert(
    //   context: context,
    //   type: AlertType.warning,
    //   title: "Thank You :)",
    //   desc: "If you any question please contact Team IT",
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "Go Home",
    //         style: TextStyle(color: Colors.white, fontSize: 18),
    //       ),
    //       onPressed: () => Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //           builder: (BuildContext context) {
    //             return DashboardMenu();
    //           },
    //         ),
    //       ),
    //       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    //       //                   BottomNavScreen()), (Route<dynamic> route) => false),
    //       color: Color.fromRGBO(0, 179, 134, 1.0),
    //     ),
    //   ],
    // ).show();

    showCustAlert(
        height: 290,
        context: context,
        title: "Thank You :)",
        detailContent: "If you any question please contact Team IT",
        buttonString: "Go Home",
        onSubmit: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DashboardMenu();
              },
            ),
          );
        },
        pathLottie: "warning");
  }
}
