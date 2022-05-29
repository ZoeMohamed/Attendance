import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schools_management/config/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  const CustomAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title,
          style: TextStyle(
              fontFamily: "Lato",
              color: Color.fromRGBO(14, 69, 84, 1),
              fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,

      elevation: 0.0,
      // iconTheme: IconThemeData(color: Color.fromRGBO(14, 69, 84, 1)),
      leading: IconButton(
        splashRadius: 20,
        color: Color.fromRGBO(14, 69, 84, 1),
        icon: const Icon(Icons.arrow_back_ios_new),
        iconSize: 20.0,
        onPressed: () {
          // Navigator.pushReplacementNamed(context, '/app-menu');
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        // IconButton(
        //   icon: const Icon(Icons.notifications_none),
        //   iconSize: 28.0,
        //   onPressed: () {},
        // ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Image.asset(
            "assets/images/SII.png",
            width: 20,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
