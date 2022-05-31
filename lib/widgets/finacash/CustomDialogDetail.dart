import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:schools_management/helper/Movimentacoes_helper.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:sizer/sizer.dart';
import 'package:schools_management/screens/Finance/DetailDana.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/provider/parent.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../custAlert.dart';

class Item {
  const Item(this.name, this.icon, this.harga);
  final String name;
  final Icon icon;
  final String harga;
}

class CustomDialogDetail extends StatefulWidget {
  final Movimentacoes mov;
  final data;
  final role;
  const CustomDialogDetail({Key key, this.mov, this.data, this.role})
      : super(key: key);

  @override
  _CustomDialogDetailState createState() => _CustomDialogDetailState();
}

class _CustomDialogDetailState extends State<CustomDialogDetail> {
  var formatter = new DateFormat('dd-MM-yyyy');
  bool edit;
  ParentInf getParentInfo;
  //IMAGE PICKER

  static final String uploadEndPoint =
      'https://la-att.intek.co.id/images/upload/struk';

  static final String trackmoneyEndPoint =
      'https://budget.intek.co.id/api/finance/updateData';
  Future<File> file;
  String status = '';
  String base64Image = '';
  String dataencodeimage = '';
  File tmpFile;
  bool statusnya = false;
  bool proccess = false;
  String pathimage;
  String errMessage = 'Error Uploading Image';
  String url_foto = '';
  String messagenya = 'PleaseWait..';
  //----END IMAGE PICKER
  int _groupValueRadio = 2;
  Color _colorContainer = Color.fromARGB(
    220,
    22,
    100,
    121,
  );
  Color _colorTextButtom = Colors.white;
  TextEditingController _controllerValor = TextEditingController();
  TextEditingController _controllerDesc = TextEditingController();
  TextEditingController _controllerProjtitle = TextEditingController();
  MovimentacoesHelper _movHelper = MovimentacoesHelper();
  Movimentacoes mov = Movimentacoes();
  int dataID = 1;

  String _formatNumber(String s) {
    print(NumberFormat('##,###,000').format(int.parse(s)));
    return NumberFormat('##,###,000').format(int.parse(s));
  }

  String get _currency =>
      NumberFormat.simpleCurrency(locale: "id").currencySymbol + ".";

  //Rupiah

  List<Movimentacoes> ret;
  bool isSwitched = false;
  Item selectedUser;
  //List<CatalogModel> list = new List();
  List<Item> users = <Item>[
    // const Item(
    //     'Kopi',
    //     Icon(
    //       Icons.flag,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Bensin',
    //     Icon(
    //       Icons.flag,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'ReactNative',
    //     Icon(
    //       Icons.format_indent_decrease,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'iOS',
    //     Icon(
    //       Icons.mobile_screen_share,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Flutter',
    //     Icon(
    //       Icons.flag,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'ReactNative',
    //     Icon(
    //       Icons.format_indent_decrease,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'iOS',
    //     Icon(
    //       Icons.mobile_screen_share,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
    // const Item(
    //     'Android',
    //     Icon(
    //       Icons.android,
    //       color: const Color(0xFF167F67),
    //     )),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ret = widget.data;
    dataID = ret.first.id;
    edit = false;
    // if (widget.data != null) {
    //   print(ret.toString());

    //   edit = true;
    //   if (widget.data.tipo == "d") {
    //     _groupValueRadio = 2;
    //     _colorContainer = Colors.red[300];
    //     _colorTextButtom = Colors.red[300];
    //   }

    //   _controllerValor.text = widget.data.valor.toString().replaceAll("-", "");
    //   selectedUser.name = widget.data.descricao;
    //   _controllerProjtitle.text = widget.data.titleproject;
    //   dataID = widget.data.id;
    // } else {
    //   edit = false;
    // }
    //print(mov.id);

    GetHelper.getCatalog().then((datanya) {
      setState(() {
        //statusnya = true;
        proccess = false;
        datanya.forEach((element) {
          print("${element['catalog']}");
          users.add(
            Item(
                "${element['catalog']}",
                Icon(
                  Icons.circle,
                  color: const Color(0xFF167F67),
                  size: 4,
                ),
                "${element['harga']}"),
          );
          //users.add(new CatalogModel("${element['catalog']}"));
        });
      });
    });
    setState(() {
      statusnya = true;
      proccess = true;
    });

    print("DATANYA " + ret.first.id.toString());
    print(" edit -> $edit");
  }

  //IMAGE PICKER

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('Image Set From Camera');
  }

  chooseImageGallery() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('Image Set From Gallery');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() async {
    setStatus('Please Wait...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload();
    // setState(() {
    //   base64Image = base64Image;
    // });
    // print(tmpFile);
    // print(fileName);
    // print(base64Image);
  }

  upload() async {
    try {
      // if you do not understand these data go to (insert_complant.php)
      var data = {
        'image': base64Image,
        'name': tmpFile.path.split('/').last.toString()
      };
      var response = await http.post(
        uploadEndPoint,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        // if every things are right then return true
        var message = jsonDecode(response.body);
        setState(() {
          url_foto = message["data"];
        });
        setStatus(response.statusCode == 200 ? message["status"] : errMessage);
        print(message["data"]);
      }
    } catch (e) {
      setStatus(e);
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
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {});
            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
        ],
      ).show();
    }
  }

  sendDataBudget(
      String message, String number, int user_id, String type_budget) async {
    try {
      // if you do not understand these data go to (insert_complant.php)
      var data = {
        'message': message,
        'number': number,
        'userID': user_id,
        'type': type_budget
      };
      var response = await http.post(
        uploadEndPoint,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        // if every things are right then return true
        var message = jsonDecode(response.body);

        // setStatus(response.statusCode == 200 ? message["status"] : errMessage);
        print(message["data"]);
      }
    } catch (e) {
      setStatus(e);
      print(e);
    }
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

  sendDataBudgetAPI(int user_id, int jumlah, int idKasbon, int teamID,
      String description, int id, String timestampUniq) async {
    if (proccess == false) {
      showLoadingProgress();
    }
    if (isSwitched == true) {
      try {
        // Img.Image image = Img.decodeImage(snapshot.data.readAsBytesSync());
        // // Img.Image smallerImg =
        // //     Img.copyResize(image, width: );
        // final encodenya = Img.encodeJpg(image, quality: 10);
        // base64Image = base64Encode(encodenya);
        // if you do not understand these data go to (insert_complant.php)
        var data = {
          'image': base64Image,
          'name': tmpFile.path.split('/').last.toString()
        };

        var response = await http.post(
          uploadEndPoint,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: json.encode(data),
        );
        if (response.statusCode == 200) {
          // if every things are right then return true
          var message = jsonDecode(response.body);
          setState(() {
            url_foto = message["data"];
          });
          setStatus(
              response.statusCode == 200 ? message["status"] : errMessage);
          print(message["data"]);
        }
        print("RESPONSE STATUS UPLOAD IMAGE => " +
            response.statusCode.toString());
      } catch (e) {
        //setStatus(e);
        log("ini errornya--------");
        print(e.toString() + "ini error");
        log("ini errornya--------");

        return Alert(
          context: context,
          type: AlertType.error,
          title: "Error: ",
          desc: e.toString(),
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              color: Color.fromRGBO(0, 179, 134, 1.0),
            ),
          ],
        ).show();
      }
    }

    try {
      // if you do not understand these data go to (insert_complant.php)

      var data = {
        'user_id': user_id,
        'id_kasbon': idKasbon,
        'team_id': teamID,
        'jumlah': jumlah,
        'description': description,
        'picture': (url_foto == "" && isSwitched == false)
            ? "https://budget.intek.co.id/noimage.png"
            : url_foto,
        'id_on_sqlite': id,
        'timestampUniq': timestampUniq
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
      //print("DATANYA DARI API " + response.body);
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {});
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
          var jumlah_baru = _formatNumber(jumlah.toString());
          return showCustAlert(
              height: 280,
              context: context,
              title: "Success",
              // buttonString: "OK",

              onSubmit: () {
                Navigator.pop(context);
                setState(() {});
              },
              detailContent:
                  "Data Money Out Saved" + "\nSpent -Rp.${jumlah_baru}",
              pathLottie: "warning");
          // return AwesomeDialog(
          //     context: context,
          //     dialogType: DialogType.SUCCES,
          //     title: "Success: ",
          //     desc: message["message"],
          //     body: Center(
          //       child: Column(
          //         children: [
          //           Text(
          //             "Success",
          //             style: TextStyle(
          //                 fontWeight: FontWeight.w600, fontSize: 25.0.sp),
          //           ),
          //           SizedBox(
          //             height: 25,
          //           ),
          //           Text(
          //             "Data Money Out Saved ",
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //                 fontWeight: FontWeight.w500, fontSize: 20.0.sp),
          //           ),
          //           SizedBox(
          //             height: 35,
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(left: 20, right: 20),
          //             child: Text(
          //               "Spent -Rp.${jumlah_baru}",
          //               textAlign: TextAlign.center,
          //               style: TextStyle(
          //                   color: Colors.red,
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 20.0.sp),
          //             ),
          //           ),
          //           SizedBox(
          //             height: 35,
          //           ),
          //           DialogButton(
          //               color: Colors.green,
          //               child: Text(
          //                 "Close",
          //                 style: TextStyle(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 15.0.sp),
          //               ),
          //               onPressed: () {
          //                 Navigator.pop(context);
          //                 setState(() {});
          //               })
          //         ],
          //       ),
          //     )).show();
        }
      }
      print("RESPONSE STATUS POST DATA KASBON => " + response.body.toString());
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
              setState(() {});
              Navigator.of(context).pop();
            },
            color: Color.fromRGBO(0, 179, 134, 1.0),
          ),
        ],
      ).show();
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data &&
            isSwitched == true) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());

          final path = tmpFile.path;

          // Img.Image image = Img.decodeImage(snapshot.data.readAsBytesSync());
          // // Img.Image smallerImg =
          // //     Img.copyResize(image, width: );
          // final encodenya = Img.encodeJpg(image, quality: 10);
          // base64Image = base64Encode(encodenya);
          print(" DATA BASE64NYA " + base64Image);
          // print("DISINI ENCODENYA " + base64Encode(encodenya));
          // var image = decodeImage(File(smallerImg).readAsBytesSync());

          // imageResized = await FlutterNativeImage.compressImage(photo.path,
          // quality: 100, targetWidth: 120, targetHeight: 120);
          // Image.memory(
          //   base64Decode(compressImg),
          //   width: 100,
          //   scale: 2,
          // );
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(base64Image),
              width: 100,
              scale: 2,
            ),
          );
          // return
          //     // final _byteImage = Base64Decoder().convert(base64Image);

          //     Flexible(
          //   child: Image.memory(base64Decode(base64Image)),
          // );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          if (isSwitched == true) {
            return Text(
              'Require Upload Images ...',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 8.0.sp,
                  fontWeight: FontWeight.bold),
            );
          } else {
            return const Text(
              'No Upload Image Require',
              textAlign: TextAlign.center,
            );
          }
        }
      },
    );
  }

  //----END IMAGE PICKER
  @override
  Widget build(BuildContext context) {
    String convertToIdr(int number, int decimalDigit) {
      NumberFormat currencyFormatter = NumberFormat.currency(
        locale: 'id',
        symbol: 'Rp ',
        decimalDigits: decimalDigit,
      );
      print(currencyFormatter.format(number));
      return currencyFormatter.format(number);
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          (widget.role == 5) ? "ADD TRANSACTION(HRGA)" : "ADD TRANSACTION",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color.fromRGBO(24, 98, 118, 0.8),
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: height * 0.01,
              ),
              (widget.role == 5)
                  ? Center(
                      child: DropdownButtonFormField<Item>(
                      dropdownColor: Colors.white,
                      icon: Icon(
                        FluentIcons.caret_down_16_filled,
                        color: Color.fromRGBO(24, 98, 118, 0.8),
                      ),
                      style: TextStyle(
                          fontSize: 15.0.sp,
                          color: Color.fromRGBO(24, 98, 118, 0.8),
                          fontWeight: FontWeight.bold),
                      value: selectedUser,
                      onChanged: (Item Value) {
                        setState(() {
                          selectedUser = Value;
                          // if (Value.harga == "50000") {
                          //   _controllerValor.text = "50,000";
                          // } else {
                          //   _controllerValor.text = "15,000";
                          // }

                          log(_formatNumber(Value.harga));

                          _controllerValor.text = _formatNumber(Value.harga);
                        });
                      },
                      items: users.map((Item user) {
                        return DropdownMenuItem<Item>(
                          value: user,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FluentIcons.circle_small_20_filled,
                                size: 4.0.w,
                                color: Colors.lightGreenAccent,
                              ),
                              SizedBox(
                                width: 3.0.w,
                              ),
                              Text(
                                user.name,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: width * 0.04,
                            top: width * 0.041,
                            bottom: width * 0.041,
                            right: width * 0.024),
                        alignLabelWithHint: true,
                        labelText: "Pilih Kategori",
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(24, 98, 118, 0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                        //hintStyle: TextStyle(color: Colors.grey[400]),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.8),
                            width: 1,
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
                    ))
                  : TextField(
                      controller: _controllerDesc,
                      // maxLength: 300,
                      style: TextStyle(
                          fontSize: width * 0.05, color: Colors.black54),
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      textAlign: TextAlign.start,
                      decoration: new InputDecoration(
                        //hintText: "descrição",

                        labelText: "Description",
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(24, 98, 118, 0.8),
                            fontWeight: FontWeight.normal),
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
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 12,
                      style: TextStyle(
                          fontSize: width * 0.05, color: Colors.black54),
                      keyboardType: TextInputType.number,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      textInputAction: TextInputAction.done,
                      decoration: new InputDecoration(
                        prefixText: _currency,
                        counterStyle:
                            TextStyle(color: Color.fromRGBO(24, 98, 118, 0.8)),
                        labelText: "Nominal",
                        prefixStyle:
                            TextStyle(color: Color.fromRGBO(24, 98, 118, 0.8)),
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                            color: Color.fromRGBO(24, 98, 118, 0.8),
                            fontWeight: FontWeight.normal),
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                        child: Text(
                      "Use Image?",
                      style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                    )),
                    Center(
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        activeTrackColor: Color.fromRGBO(14, 69, 84, 0.5),
                        activeColor: Color.fromRGBO(14, 69, 84, 1),
                      ),
                    ),
                    (isSwitched == true)
                        ? Container(
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.0.w,
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: chooseImage,
                                        color: Colors.grey.withOpacity(0.8),
                                        icon:
                                            Icon(FluentIcons.camera_28_filled),
                                      ),
                                      Text("Photo",
                                          style: TextStyle(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              fontSize: 11.0.sp))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 12.5.w,
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: chooseImageGallery,
                                          color: Colors.grey.withOpacity(0.8),
                                          icon: Icon(
                                              FluentIcons.image_48_filled)),
                                      Text(
                                        "Gallery",
                                        style: TextStyle(
                                            color: Colors.grey.withOpacity(0.8),
                                            fontSize: 11.0.sp),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                    SizedBox(height: 3.0.h),
                    (isSwitched == true) ? showImage() : SizedBox(height: 0),
                    Text(
                      status,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 11.0.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: (isSwitched == true) ? 1.0.h : 2.0.h, left: 0.7.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        if (_controllerValor.text.isNotEmpty) {
                          Movimentacoes mov = Movimentacoes();
                          String valor;
                          if (_controllerValor.text.contains(",")) {
                            valor = _controllerValor.text
                                .replaceAll(RegExp(","), "");
                          } else {
                            valor = _controllerValor.text;
                          }
                          var formatnya = DateFormat("yyyy-MM-dd hh:mm:ss");

                          DateTime datenya =
                              DateTime.parse(DateTime.now().toString());
                          var datetime2 = formatnya.format(datenya);
                          var timestampUniq = new DateTime.now()
                              .microsecondsSinceEpoch
                              .toString();
                          mov.data =
                              formatter.format(DateTime.parse(datetime2));
                          mov.descricao = (widget.role == 5)
                              ? selectedUser.name
                              : _controllerDesc.text;

                          // mov.titleproject = _controllerProjtitle.text;
                          mov.titleproject = ret.first.titleproject;
                          mov.buktifoto = url_foto;
                          mov.idparent = dataID;
                          mov.uniqTime = timestampUniq;
                          mov.userID = getParentInfo.id;

                          //print(tmpFile.path);
                          if (_groupValueRadio == 1) {
                            mov.valor = double.parse(valor);
                            mov.tipo = "r";
                            if (widget.mov != null) {
                              mov.id = widget.mov.id;
                            }
                            edit == false
                                ? _movHelper.saveMovimentacao(mov)
                                : _movHelper.updateMovimentacao(mov);
                          }
                          if (_groupValueRadio == 2) {
                            mov.valor = double.parse("-" + valor);
                            mov.tipo = "d";
                            if (widget.mov != null) {
                              mov.id = widget.mov.id;
                            }
                            print("DIDALAM CUSTOM DIALOG DETAIL => " +
                                mov.toString());
                            await sendDataBudgetAPI(
                                getParentInfo.id,
                                int.parse(valor),
                                dataID,
                                getParentInfo.team_id,
                                (widget.role == 5)
                                    ? selectedUser.name
                                    : _controllerDesc.text,
                                mov.id,
                                timestampUniq);
                            if (messagenya != "Balance not Enough") {
                              // edit == false
                              //     ? _movHelper.addDatafromDetail(mov)
                              //     : _movHelper.updateMovimentacao(mov);
                              // Alert(
                              //   context: context,
                              //   type: AlertType.success,
                              //   title: "Success: ",
                              //   desc: "Success Save Data",
                              // ).show();
                              setState(() {
                                proccess = true;
                              });
                              print("Data save di IF");
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailDana(
                                          mov: [ret.first],
                                        )),
                              );
                              setState(() {});
                            } else {
                              print("INI MASUK ELSE");
                              setState(() {
                                proccess = true;
                              });
                              Navigator.of(context).pop();
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => DetailDana(
                              //             mov: [ret.first],
                              //           )),
                              // );
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(
                              //   builder: (context) => Screen2(),
                              // ))
                              //     .then((value) {
                              //   // you can do what you need here
                              //   // setState etc.
                              // });
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => DetailDana(
                                  mov: [ret.first],
                                ),
                              ))
                                  .then((value) {
                                // you can do what you need here
                                // setState etc.
                                setState(() {});
                              });
                              setState(() {});
                            }
                            //Navigator.pop(context);
                            print(ret);
                          }
                          //Navigator.of(context).pop();
                          // sendDataBudget(
                          //     "Berikut Budget Yang Dikeluarkan dari project ${mov.titleproject}, \nuntuk membeli *${mov.descricao} dengan Harga : Rp. ${mov.valor}",
                          //     "62859141490060",
                          //     mov.userID,
                          //     mov.tipo);

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
              ),
            ],
          ),
        ));
  }
}

// helper
class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.simpleCurrency(locale: "id_ID");

    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}
