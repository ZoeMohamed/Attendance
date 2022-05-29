import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:schools_management/widgets/finacash/CardMovimentacoesItem.dart';
import 'package:schools_management/widgets/finacash/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schools_management/widgets/loading_alert.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String saldoAtual = "0";
  var total;
  var width;
  var height;
  bool recDesp = false;
  var datas;

  String parentName;
  String parentEmail;
  String parentCreated_At;
  String parentImagesProf;
  int parentTeamID;
  int parentID;
  int userID;
  int teamID;
  bool proccess = true;

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  MovimentacoesHelper movHelper = MovimentacoesHelper();
  TextEditingController _valorController = TextEditingController();
  CalendarController calendarController;
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();
  List<Movimentacoes> listdataall = List();
  List<Movimentacoes> ultimaTarefaRemovida = List();
  ParentInf getParentInfo;
  var dataAtual = new DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  var formatterCalendar = new DateFormat('MM-yyyy');
  var formatterCalendar2 = new DateFormat('yyyy-MM');
  var datatanggal = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

  String dataFormatada;
  String dataFormatada2 = DateFormat('yyyy-MM').format(DateTime.now());
  String dataFirst;
  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _addValor() {
    String valor = _valorController.text;
    setState(() {
      saldoAtual = valor;
    });
  }

  _saldoTamanho(String conteudo) {
    if (conteudo.length > 8) {
      return width * 0.050;
    } else {
      return width * 0.070;
    }
  }

  _salvar() {
    dataFormatada = formatter.format(dataAtual);
    Movimentacoes mov = Movimentacoes();
    mov.valor = 20.50;
    mov.tipo = "r";
    mov.data = "10-03-2020"; //dataFormatada;
    mov.descricao = "CashBack";
    MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
    movimentacoesHelper.saveMovimentacao(mov);
    mov.toString();
  }

  _allMov() {
    movimentacoesHelper.getAllMovimentacoes().then((list) {
      setState(() {
        //listmovimentacoes = list;
        listdataall = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  Future getBudget(int teamID, String date) async {
    return await GetHelper.getBudget(teamID, date);
  }

  Future getBudgetSingle(int teamID, String date, int userId) async {
    return await GetHelper.getBudgetSingleUser(teamID, date, userId);
  }

  Future getBudgetnya(int teamID, String date) async {
    //var datenya = formatterCalendar2.format(dataAtual);
    // var datenya = date;
    print("DATE NYA DI GET BUDGET " + date);
    GetHelper.getBudget(teamID, date).then((datanya) {
      datanya.forEach((element) {
        print("DATANYA NIH DI GET BUDGET " + element.toString());
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
        mov.saldoAwal = double.parse(element['saldoAwalColumn'].toString());
        mov.status = element["statusColumn"];
        MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
        //listmovimentacoes.add(mov);

        movimentacoesHelper.getMovimentacoes(element["idColumn"]).then((item) {
          if (item == null) {
            movimentacoesHelper.saveMovimentacao(mov);
            //print(item.toString());
          } else {
            print("Data Already and Update");
            movimentacoesHelper.updateMovimentacao(mov);
            // refreshData();
            //print(item.toString());
          }
        });

        if (listmovimentacoes.isNotEmpty) {
          setState(() {
            listdataall = listmovimentacoes;
            _refreshdata();

            // total =
            //     listdataall.map((item) => item.valor).reduce((a, b) => a + b);
          });
          // total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
          // saldoAtual = format(total).toString();
        } else {
          total = 0;
          saldoAtual = total.toString();
        }
        setState(() {
          proccess = false;
        });
      });
    });
    // GetHelper.getBudget(teamID, datenya).then((datanya) {
    //   setState(() {
    //     datanya.forEach((element) {
    //       Movimentacoes mov = Movimentacoes();
    //       mov.id = element['idColumn'];
    //       mov.valor = double.parse(element['valorColumn']);
    //       mov.tipo = element['tipoColumn'];
    //       mov.data = element['dataColumn']; //dataFormatada;
    //       mov.descricao = element['descricaoColumn'];
    //       mov.titleproject = element['projectTitleColumn'];
    //       mov.idparent = element['idParentColumn'];
    //       mov.userID = element['userIdColumn'];
    //       mov.teamID = element['teamIDColumn'];
    //       MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
    //       //listmovimentacoes.add(mov);

    //       movimentacoesHelper
    //           .getMovimentacoes(element["idColumn"])
    //           .then((item) {
    //         if (item == null) {
    //           movimentacoesHelper.saveMovimentacao(mov);
    //           //print(item.toString());
    //         } else {
    //           print("Data Already and Update");
    //           movimentacoesHelper.updateMovimentacao(mov);
    //           // refreshData();
    //           //print(item.toString());
    //         }
    //       });
    //     });

    //     if (listmovimentacoes.isNotEmpty) {
    //       setState(() {
    //         listdataall = listmovimentacoes;
    //         // total =
    //         //     listdataall.map((item) => item.valor).reduce((a, b) => a + b);
    //       });
    //       // total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
    //       // saldoAtual = format(total).toString();
    //     } else {
    //       total = 0;
    //       saldoAtual = total.toString();
    //     }
    //     setState(() {
    //       proccess = false;
    //     });
    //   });
    // });
  }

  Future getBudgetnyaSingle(int teamID, String date, int userId) async {
    //var datenya = formatterCalendar2.format(dataAtual);
    // var datenya = date;
    print("DATE NYA DI GET BUDGET " + date);
    GetHelper.getBudgetSingleUser(teamID, date, userId).then((datanya) {
      datanya.forEach((element) {
        print("DATANYA NIH DI GET BUDGET " + element.toString());
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
        mov.saldoAwal = double.parse(element['saldoAwalColumn'].toString());
        mov.status = element["statusColumn"];
        MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();

        movimentacoesHelper.getMovimentacoes(element["idColumn"]).then((item) {
          if (item == null) {
            movimentacoesHelper.saveMovimentacao(mov);
            //print(item.toString());
          } else {
            print("Data Already and Update");
            movimentacoesHelper.updateMovimentacao(mov);
          }
        });

        if (listmovimentacoes.isNotEmpty) {
          setState(() {
            listdataall = listmovimentacoes;
          });
        } else {
          total = 0;
          saldoAtual = total.toString();
        }
        setState(() {
          proccess = false;
        });
      });
    });
  }

  _allMovMes(String data, String team_id) async {
    print("ALL MOV DATE CHECK " + data);
    movimentacoesHelper.getAllMovimentacoesPorMes(data, team_id).then((list2) {
      print("DATA NYA di AllMov " + list2.toString());
      if (list2.isNotEmpty) {
        setState(() {
          listdataall = list2;
          total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
        });
        total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
        saldoAtual = format(total).toString();
        //print("LOG IN ALLMOVMES " + listdataall.toString());
      } else {
        total = 0;
        saldoAtual = total.toString();
        //print("LOG IN ALLMOVMES ELSE" + listdataall.toString());
      }
    });

    movimentacoesHelper
        .getAllMovimentacoesPorMesLEX(data, team_id)
        .then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
          print("LOG NYA GETALLMOVLEX DI IF");
        });
      } else {
        setState(() {
          listmovimentacoes.clear();
          print("LOG NYA GETALLMOVLEX DI ELSE");
        });
      }

      //print("TOTAL: $total");
      print("All MovMES: $listmovimentacoes");
    });
    setState(() {
      proccess = false;
    });
  }

  _allMovMesPull(String data, String team_id) async {
    movimentacoesHelper.getAllMovimentacoesPorMes(data, team_id).then((list2) {
      print("DATA NYA di AllMov " + list2.toString());
      if (list2.isNotEmpty) {
        setState(() {
          listdataall = list2;
          total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
        });
        total = listdataall.map((item) => item.valor).reduce((a, b) => a + b);
        saldoAtual = format(total).toString();
        print("LOG IN ALLMOVMES " + listdataall.toString());
      } else {
        total = 0;
        saldoAtual = total.toString();
        print("LOG IN ALLMOVMES ELSE" + listdataall.toString());
      }
    });

    movimentacoesHelper
        .getAllMovimentacoesPorMesLEX(data, team_id)
        .then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
          print("LOG NYA GETALLMOVLEX DI IF");
        });
      } else {
        setState(() {
          listmovimentacoes.clear();
          print("LOG NYA GETALLMOVLEX DI ELSE");
        });
      }

      //print("TOTAL: $total");
      print("All MovMES: $listmovimentacoes");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    calendarController = CalendarController();
    if (DateTime.now().month != false) {
      //saldoAtual = "1259";
    }
    //_salvar();

    dataFormatada = formatterCalendar.format(dataAtual);
    _refreshdata();
    // var formatter = new DateFormat('yyyy-MM');
    // var bulannya = formatter.format(dataAtual);
  }

  didChangeDependencies() {
    super.didChangeDependencies();

    //_refreshdata();
    print("DI INIT AFTER REFRESH GET");
  }

  // Future _refreshToGetCount() async {
  //   getParentInfo = Provider.of<Parent>(context, listen: false).getParentInf();
  //   parentName = getParentInfo.name;
  //   parentEmail = getParentInfo.email;
  //   parentID = getParentInfo.id;
  //   parentCreated_At = getParentInfo.created_at;
  //   parentImagesProf = getParentInfo.image_profile;
  //   parentTeamID = getParentInfo.team_id;
  //   getBudget(parentTeamID, dataAtual.toString());
  //   _allMovMes(dataFormatada, parentTeamID.toString());
  //   //_allMovMes(dataFormatada, parentID.toString());
  //   print("DATANTA DARI REFRESHTOGET" + parentTeamID.toString());
  // }
  // showLoadingProgress() {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return LoadingAlert();
  //       });
  // }

  Future _refreshdata() async {
    getParentInfo = Provider.of<Parent>(context, listen: false).getParentInf();
    parentName = getParentInfo.name;
    parentEmail = getParentInfo.email;
    parentID = getParentInfo.id;
    parentCreated_At = getParentInfo.created_at;
    parentImagesProf = getParentInfo.image_profile;
    parentTeamID = getParentInfo.team_id;
    if (parentTeamID != 5) {
      //teamid tidak sama dengan 5 ,5 itu type HRGA
      await getBudgetnya(parentTeamID, dataFormatada2);
    } else {
      await getBudgetnyaSingle(parentTeamID, dataFormatada2, parentID);
    }

    await _allMovMesPull(dataFormatada, parentTeamID.toString());
    setState(() {
      proccess = false;
    });
    //_allMovMes(dataFormatada, parentID.toString());
    print("DATANTA DARI REFRESHTOGET ==== >>> " + dataFormatada.toString());
  }

  // Future refreshData() async {
  //   //dataFormatada = formatterCalendar.format(dataAtual);
  //   await getBudget(parentTeamID, dataFormatada);
  //   await _allMovMes(dataFormatada, parentTeamID.toString());
  //   //

  //   print("DATANTA DARI REFRESHTOGET" + dataAtual.toString());
  // }

  _dialogAddRecDesp(data) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            data: data,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    bool initawal = false;
    getParentInfo = Provider.of<Parent>(context, listen: false).getParentInf();
    parentName = getParentInfo.name;
    parentEmail = getParentInfo.email;
    parentID = getParentInfo.id;
    parentCreated_At = getParentInfo.created_at;
    parentImagesProf = getParentInfo.image_profile;
    parentTeamID = getParentInfo.team_id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Finance",
      ),
      key: _scafoldKey,
      body: SingleChildScrollView(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        //physics: ClampingScrollPhysics(),
        //height: height,
        //width: width,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Color.fromRGBO(170, 207, 215, 1),
                    ),
                    width: width,
                    height: 130,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Container(
                    width: width,
                    height: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Color.fromRGBO(14, 69, 84, 1)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Budget Remaining (IDR)",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Montserrat",
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  // saldoAtual,
                                  // 'Rp. 500.000.000.000',
                                  'Rp. ' +
                                      NumberFormat.currency(
                                              locale: 'id', symbol: '')
                                          .format(int.parse(saldoAtual)),
                                  // 'Rp. ' +
                                  //     NumberFormat.currency(
                                  //             locale: 'id', symbol: '')
                                  //         .format(
                                  //             int.parse("5000000000000000000")),
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    // overflow: TextOverflow.ellipsis,
                                    color: (int.parse(saldoAtual).isNegative ==
                                            true)
                                        ? Colors.red
                                        : Colors.white, //Colors.indigo[400],
                                    fontWeight: FontWeight.bold,

                                    fontFamily: "Montserrat",
                                    fontSize: _saldoTamanho(saldoAtual),
                                    //width * 0.1 //_saldoTamanho(saldoAtual)
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            TableCalendar(
              calendarController: calendarController,
              locale: "en_US",
              headerStyle: HeaderStyle(
                  headerPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  // formatButtonTextStyle: TextStyle(color: Colors.red),
                  formatButtonShowsNext: false,
                  formatButtonVisible: false,
                  centerHeaderTitle: true,
                  titleTextStyle: TextStyle(
                      fontFamily: "Lato",
                      color: Color.fromRGBO(14, 69, 84, 1),
                      fontSize: 16)),
              calendarStyle: CalendarStyle(outsideDaysVisible: false),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.transparent),
                weekendStyle: TextStyle(color: Colors.transparent),
              ),
              rowHeight: 0,
              initialCalendarFormat: CalendarFormat.month,
              onVisibleDaysChanged: (dateFirst, dateLast, CalendarFormat cf) {
                print("DATE FIRSTNYA " + dateFirst.toString());

                dataFormatada = formatterCalendar.format(dateFirst);
                dataFormatada2 = formatterCalendar2.format(dateFirst);
                setState(() {
                  datatanggal = dateFirst.toString();
                  dataFirst = dateFirst.toString();
                  dataFormatada = dataFormatada;
                  dataFormatada2 = dataFormatada2;
                });

                //_allMovMes(dataFormatada, parentTeamID.toString());
                _refreshdata();
                print("DATA FORMATADA CALENDAR $dataFormatada");
                print("DATA FORMATADA CALENDAR 2 $dataFormatada2");
                //print("Data Inicial: $dateFirst ....... Data Final: $dateLast");
              },
            ),
            Padding(
                padding:
                    EdgeInsets.only(left: width * 0.07, right: width * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "History Budget",
                      style: TextStyle(
                          color: Color.fromRGBO(14, 69, 84, 1),
                          fontSize: width * 0.04,
                          fontFamily: "Lato"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.0),
                      child: Icon(
                        Icons.sort,
                        size: width * 0.07,
                        color: Color.fromRGBO(14, 69, 84, 1),
                      ),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.04, right: width * 0.04, top: 0),
              child: RefreshIndicator(
                  color: Color.fromRGBO(14, 69, 84, 1),
                  onRefresh: _refreshdata,
                  child: SizedBox(
                      width: width,
                      height: height * 0.47,
                      child: FutureBuilder(
                          future: (parentTeamID != 5)
                              ? getBudget(parentTeamID, dataFormatada2)
                              : getBudget(parentTeamID, dataFormatada2),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData ||
                                snapshots.data.length == 0 &&
                                    proccess == true) {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.grey[100],
                                  enabled: proccess,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    width: double.infinity,
                                                    height: 12.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7))),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                                ),
                                                Container(
                                                    width: double.infinity,
                                                    height: 12.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7))),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                                ),
                                                Container(
                                                    width: 40.0,
                                                    height: 12.0,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7))),
                                              ],
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
                            return ListView.builder(
                              itemCount: listmovimentacoes.length,
                              itemBuilder: (context, index) {
                                Movimentacoes mov = listmovimentacoes[index];
                                Movimentacoes ultMov = listmovimentacoes[index];

                                return Dismissible(
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    //_dialogConfimacao(context, width, mov,index);

                                    setState(() {
                                      listmovimentacoes.removeAt(index);
                                    });
                                    movHelper.deleteMovimentacao(mov);
                                    final snackBar = SnackBar(
                                      content: Container(
                                        padding: EdgeInsets.only(
                                            bottom: width * 0.025),
                                        alignment: Alignment.bottomLeft,
                                        height: height * 0.05,
                                        child: Text(
                                          "Undo Action",
                                          style: TextStyle(
                                              color: Colors.white,
                                              //fontWeight: FontWeight.bold,
                                              fontSize: width * 0.05),
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
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
                                    _scafoldKey.currentState
                                        .showSnackBar(snackBar);
                                  },
                                  key: ValueKey(mov.id),
                                  background: Container(
                                    padding: EdgeInsets.only(
                                        right: 10, top: width * 0.04),
                                    alignment: Alignment.topRight,
                                    color: Colors.red,
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                      size: width * 0.07,
                                    ),
                                  ),
                                  child: CardMovimentacoesItem(
                                    mov: mov,
                                    lastItem: listmovimentacoes[index] ==
                                            listmovimentacoes.last
                                        ? true
                                        : false,
                                  ),
                                );
                              },
                            );
                          }))),
            ),
          ],
        ),
      ),
    );
  }
}
