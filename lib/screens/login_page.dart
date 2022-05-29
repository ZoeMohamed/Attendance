/* login page */
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/animation/FadeAnimation.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:schools_management/screens/DashboardMenu.dart';
import 'package:schools_management/widgets/custAlert.dart';
import 'package:schools_management/widgets/loading_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PermissionStatus _status;

  bool _isObscure = true;

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // the key for the form
  TextEditingController user =
      new TextEditingController(); // the controller for the usename that user will put in the text field
  TextEditingController pass =
      new TextEditingController(); // the controller for the password that user will put in the text field

  int selectedRadio = 1; // variable for radiobutton
  String usern = "";
  String passwd = "";
  bool sharedpref = false;
  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;
  bool state = false;

  @override
  void initState() {
    cekPerm();
    checkSFstring();
    getconnect();
    if (sharedpref == true) {
      Provider.of<Parent>(context, listen: false)
          .loginParentAndGetInf(usern, passwd)
          .then((state) {
        // pass username and password that user entered

        if (state) {
          setState(() {
            state = true;
          });
          // if the function returned true
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Login()),
            ModalRoute.withName('/login'),
          );

          // Navigator.of(context).pushNamed(
          //     MainParentPage.routeName); // go to the Main page for parent
        } else {
          setState(() {
            state = false;
          });

          // showAlert('Error',
          //     'You Entered Wrong Email or password/ Phone not connected Internet'); // otherwise show an Alert
          showCustAlert(
              height: 290,
              context: context,
              title: "Error",
              buttonString: "OK",
              onSubmit: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Login();
                    },
                  ),
                );
              },
              detailContent:
                  "You Entered Wrong Email or password / Phone not connected to Internet",
              pathLottie: "error");
        }
      });
    }
    //call alert

    // alertinfo(context);
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

// control the radiobutton using this function
  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

// we will use CircularProgressIndicator while logging in
  // showLoadingProgress() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return LoadingAlert();
  //       });
  // }

  // login function
  saveSFstring(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);

    print(
        "Data username dan password sudah di simpan yaitu => ${prefs.getString('username')}");
  }

  checkSFstring() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool username = prefs.containsKey('username');
    bool password = prefs.containsKey('password');

    if (username == true && password == true) {
      showLoadingProgress(context);
      setState(() {
        usern = prefs.getString('username');
        passwd = prefs.getString('password');
        sharedpref = true;
      });
      if (state == true) {
        showLoadingProgress(context);
      }
      Provider.of<Parent>(context, listen: false)
          .loginParentAndGetInf(usern.toString(), passwd.toString())
          .then((state) {
        // pass username and password that user entered

        if (state) {
          // if the function returned true
          //Navigator.of(context).pushNamed(DashboardMenu.routeName);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return DashboardMenu();
              },
            ),
          );
          //Navigator.of(context).pushNamed(BottomNavScreen.routeName); // go to the Main page for parent
        } else {
          Navigator.pop(context);
          setState(() {
            sharedpref = false;
          });
          // otherwise show an Alert
        }
      });
      print(
          "Data username dan password sudah ada di sharedpreference yaitu => ${usern.toString()}");
    } else {
      print("No Data sharedpreference bro");
    }
  }

  _login() async {
    getconnect();

    if (isInternetOn == true) {
      saveSFstring(user.text, pass.text);
      setState(() {
        state = true;
      });
      if (_formKey.currentState.validate()) {
        // check if all the conditionsthe we put on validators are right
        if (state) {
          showLoadingProgress(context); // show CircularProgressIndicator
        }
        if (selectedRadio == 1) {
          // if the radio button on parent then login using parent provider

          if (sharedpref == false) {
            Provider.of<Parent>(context, listen: false)
                .loginParentAndGetInf(user.text, pass.text)
                .then((state) {
              // pass username and password that user entered

              if (state) {
                setState(() {
                  state = false;
                });
                // if the function returned true
                // Navigator.of(context)
                //     .pushReplacementNamed(DashboardMenu.routeName);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DashboardMenu()),
                  ModalRoute.withName('/app-menu'),
                );
                //Navigator.of(context).pushNamed(BottomNavScreen.routeName); // go to the Main page for parent
              } else {
                setState(() {
                  state = false;
                });
                showCustAlert(
                    height: 280,
                    context: context,
                    title: "Error",
                    buttonString: "OK",
                    onSubmit: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Login();
                          },
                        ),
                      );
                    },
                    detailContent: "You Entered Wrong Email or password",
                    pathLottie: "error");
                // showAlert('Error',
                //     'You Entered Wrong Email or password'); // otherwise show an Alert
              }
            });
          }
        }
      }
    }
  }

  void getconnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
      showCustAlert(
          height: 280,
          context: context,
          title: "Connection Lose",
          buttonString: "EXIT",
          onSubmit: () {
            SystemNavigator.pop();
          },
          detailContent: "Please check your phone connection,thanks",
          pathLottie: "error");
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF1a5261),
    ));

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
            // image: AssetImage("assets/images/full_kecil.png"),

            image: AssetImage("assets/images/full.png"),
            fit: BoxFit.fill,
          )),
          child: Column(
            children: [
              Container(
                height: height / 4,
              ),
              FadeAnimation(
                0,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Container(
                          height: height / 10,
                          child: Image(
                            image: AssetImage('assets/images/logo-intek.png'),
                          )),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                  ],
                ),
              ),
              FadeAnimation(
                0.5,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: width / 1.3,
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFe9f1f3),
                                        borderRadius: BorderRadius.circular(29),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Color.fromRGBO(14, 69, 84, 1),
                                        ),
                                        controller: user,
                                        decoration: InputDecoration(
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  62, 106, 118, 1)),
                                          icon: Icon(
                                            FluentIcons.mail_20_filled,
                                            color:
                                                Color.fromRGBO(14, 69, 84, 0.8),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // validator: (value) {
                                        //   if (value.length < 10) {
                                        //     return 'Please enter a valid email address.';
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: width * 0.8,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFe9f1f3),
                                        borderRadius: BorderRadius.circular(29),
                                      ),
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Color.fromRGBO(14, 69, 84, 1),
                                          // fontFamily: "Montserrat",
                                        ),
                                        controller: pass,
                                        obscureText: _isObscure,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(top: 15),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isObscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Color.fromRGBO(
                                                  62, 106, 118, 1),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                          ),
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  62, 106, 118, 1)),
                                          icon: Icon(
                                            FluentIcons.lock_closed_20_filled,
                                            color:
                                                Color.fromRGBO(14, 69, 84, 0.8),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        // validator: (value) {
                                        //   if (value.length < 1) {
                                        //     return 'Please enter a password.';
                                        //   } else {
                                        //     return null;
                                        //   }
                                        // },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          // Center(
                          //   child: ElevatedButton(
                          //     child: Text(
                          //       "LOGIN",
                          //       style: TextStyle(
                          //           fontFamily: "Montserrat",
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 20,
                          //           color: Colors.white),
                          //       textAlign: TextAlign.center,
                          //     ),
                          //     style: ElevatedButton.styleFrom(
                          //         shadowColor: Color.fromRGBO(14, 69, 84, 1),
                          //         onPrimary: Color(0xFF114B5B).withOpacity(0.8),
                          //         primary: Color(0xFF114B5B).withOpacity(0.8),
                          //         onSurface: Color(0xFF114B5B).withOpacity(0.8),
                          //         elevation: 5,
                          //         minimumSize: Size(width, 50),
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(5))),
                          //     onPressed: () {
                          //       _login();
                          //       // LicenceProvider()
                          //       //     .login(context, value.licence);
                          //     },
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            width: width * 0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(29),
                              child: ElevatedButton(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                onPressed: () {
                                  _login();
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF3e6a76),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 20),
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
