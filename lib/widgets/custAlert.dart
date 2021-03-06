import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showCustAlert(
    {BuildContext context,
    String title,
    String detailContent,
    String pathLottie,
    double height = 350,
    String buttonString = "OK",
    Function onSubmit}) {
  Size size = MediaQuery.of(context).size;
  showLottie(String path) {
    if (path == "success") {
      return Container(
        height: 150,
        child: Lottie.asset("assets/success.json",
            repeat: false, width: 90, frameRate: FrameRate(60)),
      );
    }
    if (path == "warning") {
      return Container(
        height: 150,
        child: Lottie.asset("assets/warning.json",
            repeat: false, width: 200, frameRate: FrameRate(60)),
      );
    }
    if (path == "error") {
      return Container(
        height: 150,
        child: Lottie.asset("assets/error.json",
            repeat: false, width: 120, frameRate: FrameRate(60)),
      );
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            content: Container(
              width: double.maxFinite,
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 0),
                  Center(
                    child: showLottie(pathLottie),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '$detailContent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: onSubmit,
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 22),
                              decoration: BoxDecoration(
                                  color: Color(0xffF4F4F8),
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                buttonString,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

showCustAlertDouble(
    {BuildContext context,
    String title,
    String detailContent,
    String pathLottie,
    double height = 350,
    Function onSubmitOk,
    Function onSubmitCancel}) {
  Size size = MediaQuery.of(context).size;
  showLottie(String path) {
    if (path == "success") {
      return Container(
        height: 150,
        child: Lottie.asset("assets/success.json",
            repeat: false, width: 90, frameRate: FrameRate(60)),
      );
    }
    if (path == "warning") {
      return Container(
        height: 150,
        child: Lottie.asset("assets/warning.json",
            repeat: false, width: 200, frameRate: FrameRate(60)),
      );
    }
    if (path == "error") {
      return Container(
        height: 150,
        child: Lottie.asset("assets/error.json",
            repeat: false, width: 120, frameRate: FrameRate(60)),
      );
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            content: Container(
              width: double.maxFinite,
              height: height + 15,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 0),
                  Center(
                    child: showLottie(pathLottie),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '$detailContent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: onSubmitCancel,
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF4F4F8),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Text(
                                      "CANCEL",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.bottomCenter,
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: onSubmitOk,
                                  child: Container(
                                    width: double.maxFinite,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF4F4F8),
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    child: Text(
                                      "OK",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
