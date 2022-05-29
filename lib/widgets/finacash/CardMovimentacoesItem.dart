import 'package:auto_size_text/auto_size_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:schools_management/screens/Finance/DetailDana.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CustomDialog.dart';
import 'package:schools_management/helper/Movimentacoes_helper.dart';

import 'package:sizer/sizer.dart';

class CardMovimentacoesItem extends StatelessWidget {
  final Movimentacoes mov;
  final bool lastItem;

  const CardMovimentacoesItem({Key key, this.mov, this.lastItem = false})
      : super(key: key);

  _dialogConfimacao(BuildContext context, double width) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                "Move",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.lightBlue[700]),
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.050)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text("${mov.descricao}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.045,
                            color: mov.tipo.toString() == "r"
                                ? Colors.green[600]
                                : Colors.red[600])),
                    Text("Rp.${mov.valor}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mov.tipo.toString() == "r"
                                ? Colors.green[600]
                                : Colors.red[600])),
                    SizedBox(
                      height: 40,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 2,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            MovimentacoesHelper movHelper =
                                MovimentacoesHelper();
                            movHelper.deleteMovimentacao(mov);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: width * 0.02,
                                bottom: width * 0.02,
                                left: width * 0.03,
                                right: width * 0.03),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red[700],
                            ),
                            child: Center(
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.04),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
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

  Widget getSaldoAwal(
    int id,
  ) {}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            //_dialogEdit(context, width, mov);
            (mov.status != 1)
                ? Alert(
                    context: context,
                    type: AlertType.error,
                    title: "Budget Not Active/Lunas",
                    desc:
                        "Silahkan anda slide ke kiri untuk menghapus data budget ini dikarenakan status budget sudah tidak aktif..",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Color.fromRGBO(0, 179, 134, 1.0),
                      ),
                    ],
                  ).show()
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailDana(
                              mov: [mov],
                            )),
                  );
            //_dialogConfimacao(context, width);
          },
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            width: width,
            height: height * 0.12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: mov.tipo == "r" ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(width * 0.035),
                            child: mov.tipo == "r"
                                ? Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                    size: width * 0.06,
                                  )
                                : Icon(Icons.arrow_upward,
                                    color: Colors.white, size: width * 0.06)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: width * 0.03, top: 10),
                        child: Column(
                          children: [
                            Container(
                              width: width * 0.4,
                              child: Text(
                                (mov.titleproject != null)
                                    ? toBeginningOfSentenceCase(
                                        mov.titleproject)
                                    : "No Title Project",
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: "Montserrat"),
                              ),
                            ),
                            Container(
                              width: width * 0.4,
                              child: Text(
                                toBeginningOfSentenceCase(mov.descricao),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.040,
                                    fontFamily: "Lato"),
                              ),
                            ),
                            SizedBox(height:0.8.h,),
                            Container(
                              width: width * 0.4,
                              child: AutoSizeText(
                                
                                mov.tipo == "r"
                                    ? "${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}"
                                    : " ${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}",
                                maxFontSize:12,
                                style: TextStyle(
                                    color: mov.tipo == "r"
                                        ? (mov.valor.isNegative)
                                            ? Color.fromRGBO(166, 10, 10, 1)
                                            : Color.fromRGBO(13, 166, 10, 1)
                                        : Colors.red[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: width * 0.035,
                                    
                                    fontFamily: "Montserrat"),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                // getSaldoAwal(mov.id),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // (getSaldoAwal(mov.id) == null)
                      //     ? Text(
                      //         "0",
                      //         style: TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: width * 0.028,
                      //         ),
                      //       )
                      //     : getSaldoAwal(mov.id),

                      Text(
                        (mov.status != 1)
                            ? "NotActive/Lunas"
                            : NumberFormat.currency(locale: 'id', symbol: 'Rp.')
                                .format(mov.saldoAwal),
                        style: TextStyle(
                            color: (mov.status != 1)
                                ? Colors.purple
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.028,
                            fontFamily: "Montserrat"),
                      ),
                      SizedBox(
                        width: height * 0.022,
                        height: 8,
                      ),
                      Text(
                        mov.data,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.028,
                            fontFamily: "Montserrat"),
                      ),
                    ],
                  ),
                )

                // Text(
                //   mov.tipo == "r"
                //       ? "${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}"
                //       : " ${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(mov.valor)}",
                //   style: TextStyle(
                //     color: mov.tipo == "r" ? Colors.green : Colors.red[700],
                //     fontWeight: FontWeight.bold,
                //     fontSize: width * 0.044,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        lastItem == true
            ? Container(
                height: 0,
              )
            : Container()
      ],
    );
  }
}
