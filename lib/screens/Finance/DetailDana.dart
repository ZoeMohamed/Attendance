import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:intl/intl.dart';
import 'package:schools_management/widgets/finacash/CardMovimentacoesItemDetail.dart';
import 'package:schools_management/widgets/finacash/CustomDialogDetail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schools_management/helper/get_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DetailDana extends StatefulWidget {
  final List<Movimentacoes> mov;
  DetailDana({this.mov});
  _DetailDana createState() => _DetailDana();
}

class _DetailDana extends State<DetailDana> {
  static final String trackmoneyEndPoint =
      'https://budget.intek.co.id/api/finance/updateData';
  String saldoAtual = "0";
  double moneyIN = 0.0;
  double moneyRe = 0.0;
  var total;
  bool statusnya = false;
  bool proccess = false;
  String messagenya = 'PleaseWait..';
  ParentInf getParentInfo;
  bool delete = false;
  bool _enabled = true;

  // Order by mechnaism

  byHighestPrice() {
    String query =
        "SELECT * FROM $movimentacaoTABLE WHERE $idParentColumn = ${widget.mov.first.id} ORDER BY $valorColumn DESC";
    return query;
  }

  byLatestDate() {
    String query =
        "SELECT * FROM $movimentacaoTABLE WHERE $idParentColumn = ${widget.mov.first.id} ORDER BY $dataColumn DESC";
    return query;
  }

  byOldestDate() {
    String query =
        "SELECT * FROM $movimentacaoTABLE WHERE $idParentColumn = ${widget.mov.first.id} ORDER BY $dataColumn";
    return query;
  }

  byLowestPrice() {
    String query =
        "SELECT * FROM $movimentacaoTABLE WHERE $idParentColumn = ${widget.mov.first.id} ORDER BY $valorColumn";
    return query;
  }

  byId() {
    String query =
        "SELECT * FROM $movimentacaoTABLE WHERE $idParentColumn = ${widget.mov.first.id} ORDER BY $idColumn";
    return query;
  }
  // Order by mechnaism

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  MovimentacoesHelper movHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allTransactionbyID(String id) {
    // if (proccess == true) {
    //   showLoadingProgress();
    // }
    movimentacoesHelper.getDetailBudget(id, byId()).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
          //total =listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
          total = listmovimentacoes
              .map((item) => item.valor)
              .reduce((a, b) => a + b);
        });
        total =
            listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
        var datatotal = widget.mov.first.valor - (total).abs();
        saldoAtual = datatotal.toString();
        setState(() {
          proccess = false;
        });
      } else {
        setState(() {
          listmovimentacoes.clear();
          total = widget.mov.first.valor;
          saldoAtual = total.toString();
          proccess = false;
        });
      }
    });
  }

  _dialogAddRecDesp(data) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogDetail(
            data: data,
            role: getParentInfo.team_id,
          );
        });
  }

  getdetailBudget(int budgetID) async {
    setState(() {
      _enabled = true;
    });
    GetHelper.getDetailBudget(budgetID).then((datanya) {
      datanya.forEach((element) {
        Movimentacoes mov = Movimentacoes();
        mov.id = element['idColumn'];
        mov.valor = double.parse(element['valorColumn'].toString());
        mov.tipo = element['tipoColumn'];
        mov.data = element['dataColumn']; //dataFormatada;
        mov.descricao = element['descricaoColumn'];
        mov.titleproject = element['projectTitleColumn'];
        mov.idparent = element['idParentColumn'];
        mov.userID = element['userIdColumn'];
        mov.teamID = element['teamIDColumn'];
        mov.buktifoto = element['buktiColumn'];
        mov.nameUser = element['nameUserColumn'];
        mov.uniqTime = element['timestampUniq'].toString();
        MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
        print("DATANYA DETAIL BUDGET " + element.toString());
        //listmovimentacoes.add(mov);

        movimentacoesHelper.getMovimentacoes(element["idColumn"]).then((item) {
          if (item == null && element['statusColumn'] == 0) {
            movimentacoesHelper.saveMovimentacao(mov);
            print("IF NYA NIh");
            print(mov);
          } else if (element['statusColumn'] == 3) {
            movimentacoesHelper.deleteMovimentacao(mov);
            print("Di delete karena budget hidden/di delet");
          } else {
            print("Data Already and Update");
            // saya turn off karena jadi double update
            // movimentacoesHelper.updateMovimentacao(mov);
          }

          //print("DATA DI GET DETAIL BUDGET NEH BRO " + item.toString());
        });

        if (listmovimentacoes.isNotEmpty) {
          setState(() {
            listmovimentacoes = listmovimentacoes;
            _enabled = false;
            // total =
            //     listdataall.map((item) => item.valor).reduce((a, b) => a + b);
          });
          // total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
          //saldoAtual = format(total).toString();
        } else {
          total = 0;
          saldoAtual = total.toString();
          setState(() {
            _enabled = false;
          });
        }
      });
    });
  }

  Future datahasil(int budgetID) async {
    //_refreshdata();
    print("DARI SINI");
    return GetHelper.getDetailBudget(budgetID);
  }

  Future _refreshdata() async {
    setState(() {
      listmovimentacoes.clear();
    });
    // if (proccess == false) {
    //   showLoadingProgress();
    // }
    //await movimentacoesHelper.getDetailBudgetAwal(widget.mov.first.id);
    await getdetailBudget(widget.mov.first.id);
    await _allTransactionbyID(widget.mov.first.id.toString());

    movimentacoesHelper.getDetailBudgetAwal(widget.mov.first.id).then((item) {
      setState(() {
        moneyIN = item;
      });
    });

    movimentacoesHelper
        .getDetailBudgetCount(widget.mov.first.id)
        .then((datanya) {
      setState(() {
        moneyRe = datanya;
      });
    });

    setState(() {
      proccess = false;
    });

    print("Sampe SINI" + proccess.toString());
  }

  showLoadingProgress() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
                alignment: Alignment.center,
                height: 100,
                width: 100,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )),
          );
        });
  }

  alertBeforeDelete(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Are you sure ??",
      desc:
          "Hati-hati saat mendelete item semua trasaction ,kami catat ,walaupunanda mendelete nya \nsaldo akan di tambahkan dengan saldo sebelumnya..",
      buttons: [
        DialogButton(
          child: Text(
            "Batal",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            setState(() {
              delete = false;
            });
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Delete",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () {
            setState(() {
              delete = true;
            });
            Navigator.pop(context);
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  sendDataBudgetAPI(
      int user_id,
      int idKasbon,
      int teamID,
      String description,
      images,
      jumlahAsli,
      statusKesalahan,
      id_money_edit,
      Movimentacoes mov,
      index,
      String uniqTime) async {
    if (proccess == false) {
      showLoadingProgress();
    }

    try {
      // if you do not understand these data go to (insert_complant.php)

      var data = {
        'user_id': user_id,
        'id_kasbon': idKasbon,
        'team_id': teamID,
        'description': description,
        'picture': images,
        'type': "remove",
        'jumlah': jumlahAsli,
        'jumlah_asli': jumlahAsli,
        'statusKesalahan': statusKesalahan,
        'id_money_edit': id_money_edit,
        'timestampUniq': uniqTime
      };

      print("DATANYA YG DI POST " + json.encode(data));
      var response = await http.post(
        trackmoneyEndPoint,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(data),
      );
      print("DATANYA DARI API " + response.body);
      if (response.statusCode == 200) {
        // if every things are right then return true
        var message = jsonDecode(response.body);
        // setState(() {
        //   messagenya = message["message"];
        // });

        // setStatus(response.statusCode == 200 ? message["status"] : errMessage);
        //print("DATANYA DARI API" + message);
        setState(() {
          statusnya = true;
          proccess = true;
        });
        if (message["status"] == false) {
          setState(() {
            messagenya = message["message"];
          });
          return Alert(
            context: context,
            type: AlertType.error,
            title: "Error: ",
            desc: message["message"],
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
            ],
          ).show();
        } else {
          setState(() {
            messagenya = message["message"];
            listmovimentacoes.removeAt(index);
          });

          movHelper.deleteMovimentacao(mov);

          return Alert(
            context: context,
            type: AlertType.success,
            title: "Success: ",
            desc: message["message"],
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
            ],
          ).show();
        }
      }
    } catch (e) {
      // setStatus(e);
      print(e);
      print("Error push data detail api");
      setState(() {
        statusnya = false;
        proccess = true;
      });
      return Alert(
        context: context,
        type: AlertType.error,
        title: "Error: ",
        desc: "Terjadi Kesalahan Pada Server",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
        ],
      ).show();
    }
  }

  @override
  void initState() {
    // total = widget.mov.first.valor.toString();
    // listmovimentacoes.clear();
    //getdetailBudget(widget.mov.first.id);

    _refreshdata();
    print(widget.mov);
    super.initState();
  }

  didChangeDependencies() {
    super.didChangeDependencies();

    _refreshdata();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    return Scaffold(
        // appBar: _appBar(),
        appBar: CustomAppBar(
          title: "Office Tebet - Off",
        ),
        floatingActionButton: buttonAdd(),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: new EdgeInsets.only(left: 0.0),
          decoration: new BoxDecoration(color: Colors.white),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 4.5.h,
              ),
              Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height: height * 0.200, //300,
                      color: Colors.white),
                  Positioned(
                    top: height / 15.9,
                    left: width / 14,
                    right: width / 14,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color.fromARGB(220, 124, 178, 192),
                      ),
                      width: double.infinity,
                      height: height / 8,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: width / 16.45,
                    right: width / 16.45,
                    child: Container(
                        width: double.infinity,
                        height: height * 0.18, //250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Color.fromARGB(
                                255, 14, 69, 84) //Colors.indigo[400],
                            )),
                  ),
                  Positioned(
                    left: width * 0.07, // 30,
                    right: width * 0.07, // 30,
                    child: Container(
                      height: height * 0.16, //150,
                      width: width * 0.1, // 70,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Column(
                            children: [
                              Column(children: [
                                SizedBox(
                                  height: height / 60,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(width);
                                    print(height);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: (listmovimentacoes.length > 0 &&
                                                (widget.mov.first.saldoAwal -
                                                            total)
                                                        .isNegative ==
                                                    true)
                                            ? width / 17
                                            : width / 17.14285),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Budget Remaining (IDR)",
                                      style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                          color: (listmovimentacoes.length >
                                                      0 &&
                                                  (widget.mov.first.saldoAwal -
                                                              total)
                                                          .isNegative ==
                                                      true)
                                              ? Colors.white
                                              : Colors.white,
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 1 / 80),
                                Container(
                                  width: width / 1.37,
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(right: 7),
                                  child: AutoSizeText(
                                    (listmovimentacoes.length > 0)
                                        ? 'Rp. ' +
                                            NumberFormat.currency(
                                                    locale: 'id', symbol: '')
                                                .format(
                                                    widget.mov.first.saldoAwal -
                                                        total) //moneyRe
                                        : 'Rp. ' +
                                            NumberFormat.currency(
                                                    locale: 'id', symbol: '')
                                                .format(
                                                    widget.mov.first.saldoAwal)
                                                .toString(),
                                    maxLines: 1,
                                    minFontSize: 12,
                                    style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                        color: (listmovimentacoes.length > 0 &&
                                                (widget.mov.first.saldoAwal -
                                                            total)
                                                        .isNegative ==
                                                    true)
                                            ? Colors.red
                                            : Colors.white,
                                        fontSize: width * 0.08,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0.w, right: 6.0.w, top: 2.5.h),
                child: Container(
                  height: 7.0.h,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(27, 102, 123, 0.1),
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(children: [
                    SizedBox(
                      height: 1.2.h,
                    ),
                    Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5.0.w,
                          ),
                          Container(
                            child: Icon(
                              FluentIcons.arrow_circle_down_20_filled,
                              color: Color.fromARGB(255, 13, 166, 10),
                              size: width * 0.07,
                            ),
                          ),
                          SizedBox(
                            width: 2.0.w,
                          ),
                          Container(
                            width: 29.2.w,
                            child: Column(
                              children: [
                                Container(
                                  width: 29.2.w,
                                  child: Text(
                                    "Money IN",
                                    style: TextStyle(
                                      fontSize: width * 0.028,
                                      color: Color.fromARGB(255, 13, 166, 10),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Container(
                                  width: 29.2.w,
                                  child: AutoSizeText(
                                    'Rp.' +
                                        NumberFormat.currency(
                                                locale: 'id', symbol: '')
                                            .format(widget.mov.first.saldoAwal)
                                            .toString(),
                                    minFontSize: 10,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 13, 166, 10),
                                      fontSize: width * 0.030,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   width: 0.6.w,
                          // ),
                          Row(
                            children: [
                              Container(
                                width: 29.2.w,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 29.2.w,
                                      child: Text("Money OUT",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: width * 0.028,
                                              color: Color.fromARGB(
                                                  255, 217, 18, 18))),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 2.0.w),
                                      width: 29.2.w,
                                      child: AutoSizeText(
                                          (listmovimentacoes.length > 0)
                                              ? 'Rp. ' +
                                                  "-" +
                                                  NumberFormat.currency(
                                                          locale: 'id',
                                                          symbol: '')
                                                      .format(double.parse(
                                                          total.toString()))
                                              : "Rp.0",
                                          minFontSize: 9,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: width * 0.028,
                                              color: Color.fromARGB(
                                                  255, 217, 18, 18)),
                                          textAlign: TextAlign.end),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 2.0.w,
                              ),
                              Container(
                                child: Icon(
                                  FluentIcons.arrow_circle_up_20_filled,
                                  size: width * 0.07,
                                  color: Color.fromARGB(255, 217, 18, 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 25,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 70.0.w,
                      ),
                      Expanded(
                          child: DropdownButtonFormField(
                        isDense: true,
                        icon: Icon(
                          FluentIcons.arrow_sort_16_filled,
                          size: 10,
                          color: Color.fromARGB(255, 14, 69, 84),
                        ),
                        isExpanded: true,
                        style: TextStyle(
                            color: Color.fromARGB(255, 14, 69, 84),
                            fontFamily: 'Monsterrat',
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                        elevation: 0,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 10, top: 0, right: 10, bottom: 15),
                          // enabledBorder: OutlineInputBorder(
                          //     borderSide: BorderSide()
                          //     // borderSide: BorderSide(color: Colors.transparent),
                          //     // borderRadius: BorderRadius.circular(7),
                          //     ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                        value: "By Latest Date",
                        hint: Text(
                          "Sort",
                          // style: GoogleFonts.rubik(
                          //     textStyle: TextStyle(
                          //         fontWeight: FontWeight.w400, fontSize: 7),
                          //     color: Colors.blue),
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Montserrat"),
                        ),
                        items: [
                          "By Latest Date",
                          "By Oldest Date",
                          "By Highest Price",
                          "By Lowest Price"
                        ].map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            switch (newValue) {
                              case "By Latest Date":
                                movimentacoesHelper
                                    .getDetailBudget(
                                        widget.mov.first.id.toString(),
                                        byLatestDate())
                                    .then((list) {
                                  log(list.toString());
                                  if (list.isNotEmpty) {
                                    setState(() {
                                      listmovimentacoes = list;
                                    });
                                  } else {
                                    setState(() {
                                      listmovimentacoes.clear();
                                      total = widget.mov.first.valor;
                                      saldoAtual = total.toString();
                                      proccess = false;
                                    });
                                  }
                                });
                                break;
                              case "By Highest Price":
                                movimentacoesHelper
                                    .getDetailBudget(
                                        widget.mov.first.id.toString(),
                                        byHighestPrice())
                                    .then((list) {
                                  log(list.toString());
                                  if (list.isNotEmpty) {
                                    setState(() {
                                      listmovimentacoes = list;
                                    });
                                  } else {
                                    setState(() {
                                      listmovimentacoes.clear();
                                      total = widget.mov.first.valor;
                                      saldoAtual = total.toString();
                                      proccess = false;
                                    });
                                  }
                                });
                                break;
                              case "By Oldest Date":
                                movimentacoesHelper
                                    .getDetailBudget(
                                        widget.mov.first.id.toString(),
                                        byOldestDate())
                                    .then((list) {
                                  log(list.toString());
                                  if (list.isNotEmpty) {
                                    setState(() {
                                      listmovimentacoes = list;
                                    });
                                  } else {
                                    setState(() {
                                      listmovimentacoes.clear();
                                      total = widget.mov.first.valor;
                                      saldoAtual = total.toString();
                                      proccess = false;
                                    });
                                  }
                                });
                                break;
                              case "By Lowest Price":
                                movimentacoesHelper
                                    .getDetailBudget(
                                        widget.mov.first.id.toString(),
                                        byLowestPrice())
                                    .then((list) {
                                  log(list.toString());
                                  if (list.isNotEmpty) {
                                    setState(() {
                                      listmovimentacoes = list;
                                    });
                                  } else {
                                    setState(() {
                                      listmovimentacoes.clear();
                                      total = widget.mov.first.valor;
                                      saldoAtual = total.toString();
                                      proccess = false;
                                    });
                                  }
                                });
                            }
                          });
                        },
                      ))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(color: Colors.white),

                // we will use future builder to show the data in a list view
                // we put the future variable
                // check if there is no show a message to user no data
                // else show a list view with tiles tha show our data
                child: RefreshIndicator(
                    onRefresh: _refreshdata,
                    child: FutureBuilder(
                      future: datahasil(widget.mov.first.id),
                      builder: (context, snapshots) {
                        if (!snapshots.hasData ||
                            snapshots.data.length == 0 && proccess == true) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              enabled: _enabled,
                              child: ListView.builder(
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 48.0,
                                        height: 48.0,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(7)),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                width: double.infinity,
                                                height: 8.0,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                                width: double.infinity,
                                                height: 8.0,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0),
                                              ),
                                              Container(
                                                width: 40.0,
                                                height: 8.0,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                itemCount: 4,
                              ),
                            ),
                          );
                        }

                        return NotificationListener<
                            OverscrollIndicatorNotification>(
                          onNotification: (overScroll) {
                            overScroll.disallowGlow();

                            return;
                          },
                          child: ListView.builder(
                            itemCount: listmovimentacoes.length,
                            itemBuilder: (context, index) {
                              Movimentacoes mov = listmovimentacoes[index];
                              Movimentacoes ultMov = listmovimentacoes[index];
                              return Column(
                                children: [
                                  (index != 0)
                                      ? SizedBox(
                                          height: 10,
                                        )
                                      : SizedBox(
                                          height: 0,
                                        ),
                                  Dismissible(
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss:
                                        (DismissDirection direction) async {
                                      return await AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.WARNING,
                                          title: "Success: ",
                                          desc: "tes",
                                          body: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Are You Sure ?",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15.0.sp),
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15, right: 15),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Hati-hati saat mendelete item",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  13.0.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "semua transaction kami catat,",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  13.0.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "walaupun anda mendelete nya ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  13.0.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "saldo tetap akan ditambahkan",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  13.0.sp),
                                                        ),
                                                        SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          "dengan saldo sebelumnya ",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize:
                                                                  13.0.sp),
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(
                                                  height: 35,
                                                ),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      DialogButton(
                                                          width: 100,
                                                          color: Colors.green,
                                                          child: Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    14.0.sp),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                      DialogButton(
                                                          width: 100,
                                                          color: Colors.red,
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    14.0.sp),
                                                          ),
                                                          onPressed: () async {
                                                            await sendDataBudgetAPI(
                                                                getParentInfo
                                                                    .id,
                                                                mov.idparent,
                                                                getParentInfo
                                                                    .team_id,
                                                                "deleted bro",
                                                                mov.buktifoto,
                                                                mov.valor,
                                                                3,
                                                                mov.id,
                                                                mov,
                                                                index,
                                                                mov.uniqTime);
                                                          })
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )).show();
                                    },
                                    onDismissed: (direction) {
                                      log("testing");
                                      final snackBar = SnackBar(
                                        content: Container(
                                          padding: EdgeInsets.only(
                                              bottom: width * 0.025),
                                          alignment: Alignment.bottomLeft,
                                          height: height * 0.02,
                                          child: Text(
                                            "Undo Action",
                                            style: TextStyle(
                                                color: Colors.white,
                                                //fontWeight: FontWeight.bold,
                                                fontSize: width * 0.05),
                                          ),
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.orange[800],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        action: SnackBarAction(
                                          label: "Undo",
                                          textColor: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              listmovimentacoes.insert(
                                                  index, ultMov);
                                            });

                                            movHelper.saveMovimentacao(ultMov);
                                          },
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    key: UniqueKey(),
                                    background: Container(
                                      margin: EdgeInsets.only(right: 6),
                                      padding: EdgeInsets.only(
                                          right: 15, top: 3.0.h),
                                      alignment: Alignment.topRight,
                                      color: Colors.red,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // Icon(
                                          //   FluentIcons.delete_16_filled,
                                          //   color: Colors.white,
                                          //   size: 12.0.w,
                                          // ),
                                          Shimmer.fromColors(
                                            baseColor: Colors.white,
                                            highlightColor: Colors.grey,
                                            direction: ShimmerDirection.rtl,
                                            child: Text(
                                              "Swipe to Delete",
                                              style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0.sp)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 3.9.w,
                                          ),
                                          Shimmer.fromColors(
                                            baseColor: Colors.white,
                                            direction: ShimmerDirection.rtl,
                                            highlightColor: Colors.red,
                                            child: Icon(
                                              FluentIcons.arrow_left_16_filled,
                                              color: Colors.white,
                                              size: 12.0.w,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    child: CardMovimentacoesItemDetail(
                                      mov: mov,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    )),
              )),
            ],
          ),
        ));
  }

  Widget buttonAdd() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Container(
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 14, 69, 84),
            onPressed: () {
              _dialogAddRecDesp(widget.mov);
            },
            tooltip: "Add Data",
            child: Icon(
              FluentIcons.add_16_filled,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
