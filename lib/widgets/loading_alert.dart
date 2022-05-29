import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// class LoadingAlert extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//       insetPadding: EdgeInsets.symmetric(horizontal: 150, vertical: 150),
//       content: Container(
//           alignment: Alignment.center,
//           height: 50,
//           width: 50,
//           child: Center(
//             child: CircularProgressIndicator(
//               valueColor: new AlwaysStoppedAnimation<Color>(
//                   Color.fromRGBO(7, 101, 122, 1)),
//             ),
//           )),
//     );
//   }
// }

showLoadingProgress(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => Center(
              // Aligns the container to center
              child: Container(
            // A simplified version of dialog.
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            width: 100.0,
            height: 70.0,
            child: SpinKitWave(
              color: Color(0xFF3e6a76).withOpacity(0.5),
              size: 25.0,
            ),
          )));
}
