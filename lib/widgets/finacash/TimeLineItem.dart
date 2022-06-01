import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineItem extends StatelessWidget {
  final Movimentacoes mov;
  final bool isLast;
  final Color colorItem;

  const TimeLineItem({Key key, this.mov, this.isLast, this.colorItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(7)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: width * 0.04,
                        height: height * 0.019,
                        decoration: BoxDecoration(
                            color: colorItem, //Colors.red[900],
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: width * 0.02, bottom: width * 0.01),
                        child: Container(
                          width: width * 0.005,
                          height:
                              isLast != true ? height * 0.04 : height * 0.04,
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: width / 2,
                      child: Text(
                        mov.titleproject,
                        // "asdasdasdasdasdasdasdddddddddddddddddddddddddddddddddddddd"
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: "Lato",
                          color: Colors.black,
                          fontSize: width * 0.045,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width / 1.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width / 4,
                                  child: Text(
                                    mov.descricao,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        color: Colors.black,
                                        fontSize: width * 0.030,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.05),
                                  child: Text(
                                    mov.tipo == "r"
                                        ? "+ ${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}"
                                        : "- ${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Montserrat",
                                        fontSize: width * 0.030,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Text(
                              mov.data,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width * 0.030,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(right: width * 0.05),
            //   child: Text(
            //     mov.tipo == "r"
            //         ? "+ ${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}"
            //         : " ${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}",
            //     textAlign: TextAlign.end,
            //     style: TextStyle(
            //         color: Colors.black,
            //         fontSize: width * 0.030,
            //         fontWeight: FontWeight.bold),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
