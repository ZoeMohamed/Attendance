/* the ListTile that we will show every Group information in */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupTile extends StatelessWidget {
  final String name;
  final String subject;
  final String time;
  final Function function;

  GroupTile({this.name = "", this.subject = "", this.time = "", this.function});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            leading: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
              child: SvgPicture.asset(
                'dev_assets/paytm/Peoples.svg',
                width: 30,
                height: 30,
                color: Colors.grey,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w800,
                    fontSize: 15),
              ),
            ),
            subtitle: Text(
              '$time',
              style: TextStyle(
                  color: Colors.black38,
                  fontFamily: "Montserrat",
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            trailing: FlatButton(
              child: Text(
                '$subject'.toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold),
              ),
              minWidth: 110,
              color: Color.fromRGBO(50, 97, 109, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              onPressed: function,
            ),
            onTap: function),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Divider(
            thickness: 1.3,
          ),
        )
      ],
    );
  }
}
