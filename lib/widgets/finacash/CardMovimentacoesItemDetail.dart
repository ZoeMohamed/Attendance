import 'dart:developer';

import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:schools_management/screens/Finance/HomePage.dart';
import 'package:schools_management/screens/Finance/DetailDana.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'CustomDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CardMovimentacoesItemDetail extends StatelessWidget {
  final Movimentacoes mov;
  final bool lastItem;
  final TextEditingController nominal = new TextEditingController();

  String _formatNumber(String s) =>
      NumberFormat('##,###,000').format(int.parse(s));
  String get _currency =>
      NumberFormat.simpleCurrency(locale: "id").currencySymbol;
  CardMovimentacoesItemDetail({Key key, this.mov, this.lastItem = false})
      : super(key: key);

  _dialogConfimacao(BuildContext context, double width) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            height: 200,
                            // width: width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                // color: Color.fromRGBO(27, 102, 123, 0.8),
                                image: DecorationImage(
                                    // image: AssetImage(
                                    //     'dev_assets/paytm/gstbanner.png'),
                                    image: NetworkImage(mov.buktifoto),
                                    fit: BoxFit.cover)
                                // image: DecorationImage(
                                //   fit: BoxFit.cover,
                                //   image:
                                //       AssetImage('dev_assets/paytm/report2.png'),
                                )),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, right: 20),
                              child: InkResponse(
                                radius: 15,
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 13,
                                  ),
                                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.4),
                                  maxRadius: 15.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(15),
                          )),
                      // height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 30,
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(27, 102, 123, 0.1),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "dev_assets/paytm/calendar.svg",
                                          width: 30,
                                          height: 30,
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.only(
                                        //       left: 10, right: 5),
                                        //   child: Container(
                                        //     height: 40,
                                        //     width: 0,
                                        //     color: Colors.transparent,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Date of Budget',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 14, 69, 84),
                                                    fontFamily: "Lato",
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              mov.data,
                                              style: TextStyle(
                                                  fontFamily: "Lato",
                                                  fontSize: 13,
                                                  color: Color.fromARGB(
                                                      255, 14, 69, 84),
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(27, 102, 123, 0.1),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "dev_assets/paytm/money.svg",
                                          width: 30,
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 10),
                                          child: Container(
                                            height: 40,
                                            width: 0.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Item Price',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 14, 69, 84),
                                                  fontFamily: "Lato",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                'Rp. ' +
                                                    NumberFormat.currency(
                                                            locale: 'id',
                                                            symbol: '')
                                                        .format(mov.valor),
                                                style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontSize: 13,
                                                    color: Color.fromARGB(
                                                        255, 14, 69, 84),
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(27, 102, 123, 0.1),
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "dev_assets/paytm/detail.svg",
                                          width: 30,
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 10),
                                          child: Container(
                                            height: 40,
                                            width: 0.5,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Details of Item',
                                                style: TextStyle(
                                                    fontFamily: "Lato",
                                                    color: Color.fromARGB(
                                                        255, 14, 69, 84),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(mov.descricao,
                                                  // "sdkasdksal;dkasl;dkasl;dkaslkdasl;kdsal;sdkasdksal;dkasl;dkasl;dkaslkdasl;kdsal;sdkasdksal;dkasl;dkasl;dkaslkdasl;kdsal;sdkasdksal;dkasl;dkasl;dkaslkdasl;kdsal;sdkasdksal;dkasl;dkasl;dkaslkdasl;kdsal;",
                                                  // overflow:
                                                  //     TextOverflow.ellipsis,
                                                  maxLines: null,
                                                  style: TextStyle(
                                                      fontFamily: "Lato",
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                          255, 14, 69, 84),
                                                      fontWeight:
                                                          FontWeight.w300)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),

                                // SizedBox(
                                //   height: 40,
                                // ),
                              ],
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            // FlatButton.icon(onPressed: null, icon: Icon(Icons.edit), label: )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _dialogEdit(BuildContext context, double width, Movimentacoes movimentacao) {
    print(movimentacao.toString());
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            mov: movimentacao,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(height * 0.009),
          width: width,
          height: height * 0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _dialogConfimacao(context, width);
                },
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        print(mov.buktifoto);
                        _dialogConfimacao(context, width);
                      },
                      child: Container(
                        width: 18.0.w,
                        height: 9.0.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: Offset(0, 0),
                                blurRadius: 2,
                                spreadRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: (mov.buktifoto ==
                                "https://budget.intek.co.id/noimage.png")
                            ? Icon(
                                FluentIcons.image_off_24_filled,
                                size: 12.0.w,
                                color: Colors.black.withOpacity(0.5),
                              )
                            : CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: width,
                                  height: height,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                    
                                imageUrl: mov.buktifoto,
                              ),
                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left:4.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.4,
                            padding: EdgeInsets.only(left: 0.3.w),
                            child: Text(
                              toBeginningOfSentenceCase(mov.descricao),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.bold,
                                color: mov.tipo == "r"
                                    ? Colors.green
                                    : Color.fromRGBO(14, 69, 84, 1),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 1.4.h,
                          ),
                          Container(
                            width: width * 0.4,
                            child: Text(
                              mov.data,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  color: Color.fromRGBO(14, 69, 84, 1),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10.0.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: GestureDetector(
                  onTap: () {
                    _dialogEdit(context, width, mov);
                    log(mov.descricao);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 22.0.w,
                        child: AutoSizeText(
                          (mov.nameUser != null) ? mov.nameUser : "NoName",
                          maxLines: 1,
                          minFontSize: 10,
                          style: TextStyle(
                              fontFamily: "Lato",
                              color: Color.fromRGBO(14, 69, 84, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      SizedBox(
                        height: 1.4.h,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20.0.w,
                            child: AutoSizeText(
                              mov.tipo == "r"
                                  ? "${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}"
                                  : "${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}",
                              minFontSize: 10,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: "Lato",
                                color: mov.tipo == "r"
                                    ? Colors.green
                                    : Colors.red[700],
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            width: 1.5.w,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        lastItem == true
            ? Container(
                child: Text("d"),
                color: Colors.black,
                height: 110,
              )
            : Container(
              
            )
      ],
    );
  }
}
