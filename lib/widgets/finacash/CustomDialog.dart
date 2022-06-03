import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:schools_management/constant.dart';
import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:schools_management/screens/Finance/HomePage.dart';
import 'package:schools_management/screens/Finance/InicialPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:schools_management/screens/Finance/DetailDana.dart';

class CustomDialog extends StatefulWidget {
  final Movimentacoes mov;
  final data;
  const CustomDialog({Key key, this.mov, this.data}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  var formatter = new DateFormat('dd-MM-yyyy');
  bool edit;

  //INITIAL Variable
  static final String trackmoneyEndPoint =
      'https://budget.intek.co.id/api/finance/updateData';

  static final String uploadEndpoint = LINKAPI + 'images/upload/struk';
  //INITIAL VARIABLe

  String status = '';
  String base64Image = '';
  String dataencodeimage = '';
  bool statusnya = false;
  var check;
  bool proccess = false;
  String pathimage;
  String errMessage = 'Error Uploading Image';
  String url_foto = '';
  String messagenya = 'PleaseWait..';
  ParentInf getParentInfo;
  Future<File> file;
  File tmpFile;
  int dataID = 1;
  int _groupValueRadio = 1;
  int statusKesalahan = 1;
  Color _colorContainer = Colors.green[400];
  Color _colorTextButtom = Colors.green;
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();
  TextEditingController _controllerProjtitle = TextEditingController();
  MovimentacoesHelper _movHelper = MovimentacoesHelper();
  String _formatNumber(String s) =>
      NumberFormat('##,###,000').format(int.parse(s));
  String get _currency =>
      NumberFormat.simpleCurrency(locale: "id").currencySymbol + " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.mov != null) {
      print(widget.mov.toString());

      edit = true;
      if (_groupValueRadio == 2) {
        _groupValueRadio = 2;
        _colorContainer = Colors.red[300];
        _colorTextButtom = Colors.red[300];
      }

      _controllerValor.text = widget.mov.valor.toString().replaceAll("-", "");
      _controllerDesc.text = widget.mov.descricao;
      _controllerProjtitle.text = widget.mov.titleproject;
    } else {
      edit = false;
    }
    print(" edit -> $edit");
  }

  //Image picker
  chooseImage() {
    setState(() {
      check = 1;
      log(check.toString());
      file = ImagePicker.pickImage(source: ImageSource.camera);
      file.then((value) => log(value.toString()));
      log("tes aja");
    });
    setStatus('Image Set From Camera');
  }

  chooseImageGallery() {
    setState(() {
      check = 2;
      log(check.toString());
      file = ImagePicker.pickImage(source: ImageSource.gallery);
      file.then((value) => log(value.toString()));
    });
    setStatus('Image Set From Gallery');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Widget showImage() {
    log('show image dijalankan');
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          final path = tmpFile.path;

          print(" DATA BASE64NYA " + base64Image);

          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(base64Image),
              width: 100,
              scale: 2,
            ),
          );
        } else {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        }
      },
    );
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

  sendMoney() async {
    log(url_foto);
  }

  postHttp() async {
    if (check == 1 || check == 2) {
      try {
        var data = {
          'image': base64Image,
          'name': tmpFile.path.split('/').last.toString()
        };

        var response = await http.post(
          uploadEndpoint,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: json.encode(data),
        );
        if (response.statusCode == 200) {
          // if every things are right then return true
          var message = jsonDecode(response.body);
          print(message['data']);
          setState(() {
            url_foto = message["data"];
            log(url_foto);
          });
          setStatus(
              response.statusCode == 200 ? message["status"] : errMessage);
          print(message["data"]);
        }
        print("RESPONSE STATUS UPLOAD IMAGE => " +
            response.statusCode.toString());
      } catch (e) {
        //setStatus(e);

        print(e);
        return Alert(
          context: context,
          type: AlertType.error,
          title: "Error: ",
          desc: e,
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(
                    color: Color.fromRGBO(24, 98, 118, 1), fontSize: 18),
              ),
              //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ],
        ).show();
      }
    }
  }

  sendDataBudgetAPI(
      int user_id,
      int jumlah,
      int idKasbon,
      int teamID,
      String description,
      images,
      jumlahAsli,
      statusKesalahan,
      id_money_edit,
      String uniqTime) async {
    if (proccess == false) {
      showLoadingProgress();
    }
    try {
      var data = {
        'user_id': user_id,
        'id_kasbon': idKasbon,
        'team_id': teamID,
        'jumlah': jumlah,
        'description': description,
        'picture': images,
        'type': "d",
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
            statusnya = false;
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
                  style: TextStyle(
                      color: Color.fromRGBO(24, 98, 118, 1), fontSize: 18),
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
            statusnya = true;
            messagenya = message["message"];
          });
          return Alert(
            context: context,
            type: AlertType.success,
            title: "Success: ",
            desc: message["message"],
            buttons: [
              DialogButton(
                child: Text(
                  "Close",
                  style: TextStyle(
                      color: Color.fromRGBO(24, 98, 118, 1), fontSize: 18),
                ),
                //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailDana(
                              mov: [widget.mov],
                            )),
                  );
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
              style: TextStyle(
                  color: Color.fromRGBO(24, 98, 118, 1), fontSize: 18),
            ),
            //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailDana(
                          mov: [widget.mov],
                        )),
              );
            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Edit Value",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(24, 98, 118, 1)),
          // style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(24, 98, 118, 1)),
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              TextField(
                  controller: _controllerDesc,
                  // maxLength: 300,
                  style:
                      TextStyle(fontSize: width * 0.05, color: Colors.black54),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  textAlign: TextAlign.start,
                  decoration: new InputDecoration(
                    //hintText: "descrição",

                    labelText: "Description",
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(24, 98, 118, 0.8),
                        fontWeight: FontWeight.bold),
                    //hintStyle: TextStyle(color: Colors.grey[400]),
                    contentPadding: EdgeInsets.only(
                        left: width * 0.04,
                        top: width * 0.041,
                        bottom: width * 0.041,
                        right: width * 0.04),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.8),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.8),
                        width: 1.0,
                      ),
                    ),
                  )),
              SizedBox(
                height: 5.0.h,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      controller: _controllerValor,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 12,
                      style: TextStyle(
                          fontSize: width * 0.05, color: Colors.black54),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.done,
                      decoration: new InputDecoration(
                        prefixText: _currency,
                        counterStyle: TextStyle(color: Colors.black54),
                        labelText: "Nominal",
                        prefixStyle: TextStyle(color: Colors.black54),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(24, 98, 118, 0.8),
                          fontWeight: FontWeight.bold,
                        ),
                        contentPadding: EdgeInsets.only(
                            left: width * 0.04,
                            top: width * 0.041,
                            bottom: width * 0.041,
                            right: width * 0.024),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.8),
                            width: 1.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.8),
                            width: 1.0,
                          ),
                        ),
                      ),
                      onChanged: (string) {
                        string = '${_formatNumber(string.replaceAll(',', ''))}';
                        _controllerValor.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 21,
              ),
              Center(
                child: Container(
                    child: (check == 1 || check == 2)
                        ? showImage()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                imageUrl: widget.mov.buktifoto.isNotEmpty
                                    ? widget.mov.buktifoto
                                    : "https://images.unsplash.com/photo-1645032227564-fa2d5a1d109e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=464&q=80"),
                          )),
              ),
              Padding(
                padding: EdgeInsets.only(top: width * 0.09),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            bottom: width * 0.02,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.red,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(-1, 1),
                                  blurRadius: 1,
                                  spreadRadius: 1)
                            ]),
                        child: Center(
                          child: Text(
                            "CANCEL",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.03),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_controllerValor.text.isNotEmpty &&
                            _controllerDesc.text.isNotEmpty) {
                          Movimentacoes mov = Movimentacoes();
                          String valor;
                          if (_controllerValor.text.contains(",")) {
                            valor = _controllerValor.text
                                .replaceAll(RegExp(","), "");
                            print("Valor di if");
                          } else if (_controllerValor.text.contains(".")) {
                            valor = _controllerValor.text.split(".")[0];
                            print("valor nya" + valor.toString());
                          } else {
                            valor = _controllerValor.text;
                            print("Valor di else");
                          }
                          var formatnya = DateFormat("yyyy-MM-dd hh:mm:ss");

                          DateTime datenya =
                              DateTime.parse(DateTime.now().toString());
                          var datetime2 = formatnya.format(datenya);

                          mov.data =
                              formatter.format(DateTime.parse(datetime2));
                          mov.descricao = _controllerDesc.text;
                          mov.titleproject = widget.mov.titleproject;
                          mov.idparent = widget.mov.idparent;
                          mov.userID = getParentInfo.id;
                          mov.teamID = getParentInfo.team_id;
                          mov.saldoAwal = widget.mov.valor;
                          mov.nameUser = getParentInfo.name;
                          // if (_groupValueRadio == 1) {
                          //   mov.valor = double.parse(valor);
                          //   mov.tipo = "r";
                          //   if (widget.mov != null) {
                          //     mov.id = widget.mov.id;
                          //   }

                          // }
                          // if (_groupValueRadio == 2) {

                          // }

                          mov.valor = double.parse(valor);

                          log(mov.valor.toString());

                          mov.tipo = "d";
                          if (widget.mov != null) {
                            mov.id = widget.mov.id;
                          }

                          //Edit image

                          //Post Image baru ke API
                          await postHttp();
                          // Display image
                          mov.buktifoto = (check == 1 || check == 2)
                              ? url_foto
                              : widget.mov.buktifoto;

                          //Edit image

                          print("DATANYA YG MAU DI UPDATE " + mov.toString());

                          await sendDataBudgetAPI(
                              getParentInfo.id,
                              int.parse(valor),
                              widget.mov.idparent,
                              getParentInfo.team_id,
                              _controllerDesc.text,
                              widget.mov.buktifoto,
                              widget.mov.valor,
                              statusKesalahan,
                              widget.mov.id,
                              widget.mov.uniqTime);

                          if (statusnya == true) {
                            _movHelper
                                .getAllMovimentacoes()
                                .then((value) => log(value.toString()));
                            log(widget.mov.buktifoto);
                            _movHelper.updateMovimentacao(mov);
                          }
                          // setState(() {
                          //   proccess = true;
                          // });
                          print("Data save di IF");
                          //Navigator.of(context).pushNamedAndRemoveUntil('/finance', );

                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => DetailDana(
                          //             mov: [widget.mov],
                          //           )),
                          // );

                          // Balikin nilai ke semula
                          check = null;
                          //Balilkin nilai ke semula

                          Navigator.pop(context);
                          //initState();
                        }
                      },
                      child: Container(
                        width: 80,
                        padding: EdgeInsets.only(
                            top: width * 0.02,
                            bottom: width * 0.02,
                            left: width * 0.03,
                            right: width * 0.03),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Color.fromRGBO(14, 69, 84, 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(-1, 1),
                                  blurRadius: 1,
                                  spreadRadius: 1)
                            ]),
                        child: Center(
                          child: Text(
                            edit == false ? "CONFIRM" : "EDIT",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.03),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
