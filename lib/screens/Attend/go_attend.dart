import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/screens/Attend/main_parent_page.dart';
import 'package:schools_management/screens/Attend/success_attend.dart';
import 'package:background_location/background_location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:schools_management/widgets/custAlert.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:schools_management/widgets/loading_alert.dart';

class GoAttend extends StatefulWidget {
  final double lat;
  final double long;
  final String name;
  final int user_id;

  GoAttend({this.lat, this.long, this.name, this.user_id});
  @override
  _GoAttendState createState() => _GoAttendState();
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

class _GoAttendState extends State<GoAttend> {
  var emergency;
  double latitude = 0;
  double longitude = 0;
  String altitude = "waiting...";
  String accuracy = "waiting...";
  String bearing = "waiting...";
  String speed = "waiting...";
  String time = "waiting...";
  String addressName = "No Address!!";
  String city = "";
  String name;
  int user_id;
  String img64 = "";
  String filePath = "";
  List imagesList = [];
  String tanggalnow;

  final now = new DateTime.now();

  //For alert UI

  //FOR AUTH LOCAL INIT
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool isAuthenticated = false;
  //END INIT AUTH LOCAL

  //FOR CAMERA VARIABLE LOCAL INIT
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  bool isCameraReady = false;
  bool showCapturedPhoto = false;
  var ImagePath;

  // To check if any type of biometric authentication
  // hardware is available.
  // Future<bool> _isBiometricAvailable() async {
  //   bool isAvailable = false;
  //   try {
  //     isAvailable = await auth.canCheckBiometrics;
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (!mounted) return isAvailable;
  //   String tanggalnow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //   if (isAvailable == true){
  //     print('Biometric is available!');
  //   }else{
  //     GetHelper.sendAttend(name, user_id, tanggalnow, latitude.toString(), longitude.toString(), addressName, filePath, img64, city);
  //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
  //             SuccessAttendScreen()), (Route<dynamic> route) => false);
  //   }

  //   return isAvailable;

  // }

  // // To retrieve the list of biometric types
  // // (if available).
  // Future<void> _getListOfBiometricTypes() async {
  //   List<BiometricType> listOfBiometrics;
  //   try {
  //     listOfBiometrics = await auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (!mounted) return;

  //   print(listOfBiometrics);
  // }

  // showLoadingProgress() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return LoadingAlert();
  //       });
  // }
  // // Process of authentication user using
  // // biometrics.
  // Future<void> _authenticateUser() async {

  //   try {
  //     isAuthenticated = await auth.authenticateWithBiometrics(
  //       localizedReason:
  //           "Please authenticate to attendance store",
  //       useErrorDialogs: true,
  //       stickyAuth: true,
  //     );
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (!mounted) return;

  //   isAuthenticated
  //       ? print('User is authenticated!')
  //       : print('User is not authenticated.');

  //   if (isAuthenticated) {
  //     setState(() {
  //       isAuthenticated = true;
  //     });
  //     String tanggalnow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //     showLoadingProgress();

  //     if (latitude != 0 && longitude != 0){
  //     var push = GetHelper.sendAttend(name, user_id, tanggalnow, latitude.toString(), longitude.toString(), addressName, filePath, img64, city);

  //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
  //                         SuccessAttendScreen()), (Route<dynamic> route) => false);
  //     }else{
  //       _latnotfound(context);
  //     }
  //   }else{
  //     String tanggalnow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  //     showLoadingProgress();
  //     if (latitude != 0 && longitude != 0){
  //     var push = GetHelper.sendAttend(name, user_id, tanggalnow, latitude.toString(), longitude.toString(), addressName, filePath, img64, city);

  //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
  //                         MainParentPage()), (Route<dynamic> route) => false);
  //     }else{
  //       _latnotfound(context);
  //     }
  //     // Navigator.of(context).push(
  //     //   MaterialPageRoute(
  //     //     builder: (context) => MainParentPage(),
  //     //   ),
  //     // );
  //   }
  // }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras[1];
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void initState() {
    latitude = widget.lat;
    longitude = widget.long;
    name = widget.name;
    user_id = widget.user_id;
    BackgroundLocation.getPermissions(
      onGranted: () {
        BackgroundLocation.startLocationService();
        BackgroundLocation.getLocationUpdates((location) {
          setState(() {
            this.latitude = location.latitude.toDouble();
            this.longitude = location.longitude.toDouble();
            this.accuracy = location.accuracy.toString();
            this.altitude = location.altitude.toString();
            this.bearing = location.bearing.toString();
            this.speed = location.speed.toString();
            this.time =
                DateTime.fromMillisecondsSinceEpoch(location.time.toInt())
                    .toString();
          });

          print("""\n
          Latitude:  $latitude
          Longitude: $longitude
          Altitude: $altitude
          Accuracy: $accuracy
          Bearing:  $bearing
          Speed: $speed
          Time: $time
          """);
        });

        getCurrentLocation();
        getRoadname();
        // Start location service here or do something else
      },
      onDenied: () {
        SystemNavigator.pop();
        print("Permission Denied dan exit program");
        // Show a message asking the user to reconsider or do something else
      },
    );
    // print(_canCheckBiometrics);
    _initializeCamera();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null; //on pause camera is disposed, so we need to call again "issue is only for android"
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: _appBar(),
      appBar: CustomAppBar(
        title: "Attendance",
      ),
      body: Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: cameraPreview(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'dev_assets/paytm/guide2.png',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  "Center your face to the screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 120,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20),
                child: cameraControl(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cameraPreview() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Transform.scale(
              scale: _controller.value.aspectRatio / deviceRatio,
              child: new AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: new CameraPreview(_controller),
              ),
            );
          } else {
            return Center(
                child:
                    CircularProgressIndicator()); // Otherwise, display a loading indicator.
          }
        });
  }

  Widget cameraControl(context) {
    return Align(
      alignment: Alignment.center,
      child: FloatingActionButton(
        child: Icon(
          Icons.camera,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(7, 101, 122, 1),
        onPressed: () => {takePicture(), _onAlertButtonsPressed(context)},
      ),
    );
  }

  _onAlertButtonsPressed(context) {
    // Alert(
    //   context: context,
    //   type: AlertType.warning,
    //   title: "Thanks For Capture,Please Click Go Attend",
    //   desc: "If you any question please contact Team IT",
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "Go Attend",
    //         style: TextStyle(color: Colors.white, fontSize: 18),
    //       ),
    //       //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
    //       onPressed: () {},
    //       color: Color.fromRGBO(0, 179, 134, 1.0),
    //     ),
    //   ],
    // ).show();
    showCustAlert(
        height: 280,
        context: context,
        title: "Thanks For Capture",
        buttonString: "Go Attend",
        onSubmit: () {
          tanggalnow = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
          showLoadingProgress(context);

          if (latitude != 0 && longitude != 0) {
            var push = GetHelper.sendAttend(
                name,
                user_id,
                tanggalnow,
                latitude.toString(),
                longitude.toString(),
                addressName,
                filePath,
                img64,
                city);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SuccessAttendScreen()),
                (Route<dynamic> route) => false);
          } else {
            _latnotfound(context);
          }
        },
        detailContent: "If you any question please contact Team IT",
        pathLottie: "warning");
  }

  _onCamera(context) {
    // Alert(
    //   context: context,
    //   type: AlertType.error,
    //   title: "Error: ",
    //   desc: "select a camera first.",
    //   // buttons: [
    //   //   DialogButton(
    //   //     child: Text(
    //   //       "Go Attend",
    //   //       style: TextStyle(color: Colors.white, fontSize: 18),
    //   //     ),
    //   //     //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
    //   //     onPressed: () => _checking(),
    //   //     color: Color.fromRGBO(0, 179, 134, 1.0),
    //   //   ),

    //   // ],
    // ).show();
    showCustAlert(
        height: 280,
        context: context,
        title: "Error: ",
        buttonString: "Go Attend",
        onSubmit: () {
          Navigator.pop(context);
        },
        detailContent: "select a camera first.",
        pathLottie: "error");
  }

  _latnotfound(context) {
    // Alert(
    //   context: context,
    //   type: AlertType.warning,
    //   title: "Location Not Found",
    //   desc: "Please You Check Internet/Gps",
    //   buttons: [
    //     DialogButton(
    //       child: Text(
    //         "Refresh",
    //         style: TextStyle(color: Colors.white, fontSize: 18),
    //       ),
    //       //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
    //       onPressed: () =>
    //       color: Color.fromRGBO(0, 179, 134, 1.0),
    //     ),
    //   ],
    // ).show();
    showCustAlert(
        height: 280,
        context: context,
        title: "Location Not Found",
        buttonString: "Refresh",
        onSubmit: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MainParentPage(),
            ),
          );
        },
        detailContent: "Please You Check Internet/Gps",
        pathLottie: "warning");
  }

  getCurrentLocation() {
    if (latitude == 0) {
      _latnotfound(context);
    }
    BackgroundLocation().getCurrentLocation().then((location) {
      var lat = location.latitude.toDouble();
      var long = location.longitude.toDouble();
      setState(() {
        latitude = lat;
        longitude = long;
      });
      print("This is current Location LAT => " +
          lat.toString() +
          "LONG => " +
          long.toString());
    });
  }

  void getRoadname() async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    var first = addresses.first;
    setState(() {
      addressName = first.addressLine;
      city = first.subAdminArea;
    });
    print("${first.featureName} : ${first.addressLine}");
  }

  //MAKE VOID FOR AUTH CHECK LOCAL

  // void _checking() async{
  //   if (await _isBiometricAvailable()) {
  //       await _getListOfBiometricTypes();
  //       await _authenticateUser();
  //   }

  // }
  //END AUTH LOCAL VOID

  //TAKE CAPTURE

  Future<String> takePicture() async {
    if (!_controller.value.isInitialized) {
      _onCamera(context);
      return null;
    }

    Directory extDir;
    // if user disagrees to allow storage access the use app storage
    extDir = await getApplicationDocumentsDirectory();
    // final String dirPath = '${extDir.path}';
    final String tanggalnye = DateFormat('yyyy-MM-ddHH:mm:ss').format(now);
    final String dirPath = extDir.path.toString();

    await new Directory(dirPath).create(recursive: true);
    filePath = '$dirPath/${tanggalnye}.jpg';

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await _controller.takePicture(filePath);
      final bytes = await File(filePath).readAsBytes();
      img64 = base64Encode(bytes);
      print(img64.toString().substring(0, 100));
      print(filePath);
      setState(() {
        img64 = img64.toString();
        filePath = filePath.toString();
      });
    } on CameraException catch (e) {
      print('Exception -> $e');
      return null;
    }

    return filePath;
  }
}
