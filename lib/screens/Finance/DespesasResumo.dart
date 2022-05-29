import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:schools_management/widgets/finacash/TimeLineItem.dart';
import 'package:flutter/material.dart';

class DespesasResumo extends StatefulWidget {
  @override
  _DespesasResumoState createState() => _DespesasResumoState();
}

class _DespesasResumoState extends State<DespesasResumo> {
  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();

  Future _allMovPorTipo() async {
    movimentacoesHelper.getAllMovimentacoesPorTipo("d").then((list) {
      setState(() {
        listmovimentacoes = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allMovPorTipo();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 104, 125, 1),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("dev_assets/paytm/In Cash.png"),
                fit: BoxFit.fill,
                opacity: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: width * 0.2, bottom: width * 0.05),
              child: Text(
                "OUT CASH",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Lato",
                    color: Colors.white, //Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.08),
              ),
            ),
            Container(
              width: width / 1.15,
              child: SizedBox(
                width: width,
                height: height * 0.70,
                child: Container(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowGlow();

                      return;
                    },
                    child: RefreshIndicator(
                        onRefresh: _allMovPorTipo,
                        color: Color.fromRGBO(14, 69, 84, 1),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: listmovimentacoes.length,
                          itemBuilder: (context, index) {
                            List movReverse =
                                listmovimentacoes.reversed.toList();
                            Movimentacoes mov = movReverse[index];

                            if (movReverse[index] == movReverse.last) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TimeLineItem(
                                  mov: mov,
                                  colorItem: Color.fromRGBO(242, 85, 85, 1),
                                  isLast: true,
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: TimeLineItem(
                                  mov: mov,
                                  colorItem: Color.fromRGBO(242, 85, 85, 1),
                                  isLast: false,
                                ),
                              );
                            }
                          },
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
