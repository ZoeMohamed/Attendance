import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:schools_management/constant.dart';
import 'package:schools_management/models/leave.dart';
import 'package:schools_management/models/report.dart';
import 'package:schools_management/screens/Attend/go_attend.dart';
import 'package:schools_management/widgets/custAlert.dart';

class GetHelper {
  static Future getListAttend() async {
    try {
      final response = await http.get(
        LINKAPI + "api/list/attend",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print(userData);
        return userData;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future getNotification() async {
    try {
      final response = await http.get(
        LINKAPI + "api/notification/office",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print(userData);
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future getBanner() async {
    try {
      final response = await http.get(
        "https://budget.intek.co.id/api/notification/banner",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        //print(userData);
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future getCatalog() async {
    try {
      final response = await http.get(
        "https://budget.intek.co.id/api/finance/ga/catalog",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        //print(userData);
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future getLastAttend() async {
    try {
      final response = await http.get(
        LINKAPI + "api/list/late",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print(userData);
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static getAlert(BuildContext context, int user_id, String name,
      double longitude, double latitude) async {
    try {
      final response = await http.get(
        LINKAPI + "api/getAlert/${user_id.toString()}",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print(userData['message']);
        if (userData['status'] == false) {
          // Alert(
          //   context: context,
          //   type: AlertType.warning,
          //   title: "Hi , ${name}",
          // desc: "${userData['message']}",
          //   buttons: [
          //     DialogButton(
          //       child: Text(
          //         "Go Attend",
          //         style: TextStyle(color: Colors.white, fontSize: 18),
          //       ),
          //       //onPressed:  () => GetHelper.sendAttend(name, user_id, "2020-09-28 17:03:01", latitude.toString(), longitude.toString()),
          //       onPressed: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => GoAttend(
          //                 lat: latitude,
          //                 long: longitude,
          //                 name: name,
          //                 user_id: user_id)),
          //       ),
          //       color: Color.fromRGBO(0, 179, 134, 1.0),
          //     ),
          //   ],
          // ).show();
          showCustAlert(
              height: 310,
              context: context,
              title: "Hi, ${name}",
              buttonString: "Go Attend",
              onSubmit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GoAttend(
                          lat: latitude,
                          long: longitude,
                          name: name,
                          user_id: user_id)),
                );
              },
              detailContent: "${userData['message']}",
              pathLottie: "warning");
        } else {
          // Alert(
          //   context: context,
          //   type: AlertType.info,
          //   title: "Hi , ${name}",
          //   desc: "${userData['message']}",
          // ).show();
          showCustAlert(
              height: 310,
              context: context,
              title: "Hi, ${name}",
              buttonString: "OK",
              onSubmit: () {
                Navigator.pop(
                  context,
                );
              },
              detailContent: "${userData['message']}",
              pathLottie: "warning");
        }
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkattendIN(int user_id) async {
    try {
      final response = await http.get(
        LINKAPI + "api/getstatusIN/${user_id.toString()}",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);

        print(userData);
        return true;
        // return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  Future sendAttend(
      String name,
      int userid,
      String datetime,
      String lat,
      String long,
      String address_name,
      String filePath,
      String img64,
      String city) async {
    try {
      // if you do not understand these data go to (insert_complant.php)
      var data = {
        'id': userid,
        'name': name,
        'date_time': datetime,
        'lat': lat,
        'long': long,
        'attend_by': 4,
        'address_name': address_name,
        'file_path': filePath,
        'img64': img64,
        'city': city
      };
      var response = await http.post(
        LINKAPI + "api/recive/data",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        // if every things are right then return true
        var message = jsonDecode(response.body);

        log(message.toString());
        return true;
      } else if (response.statusCode == 500) {
        var message = jsonDecode(response.body);
        log(message.toString());
      }
      // return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  //================= FINACASH  API ================

  // static Future getBudget(int userID, String date) async {
  //   try {
  //     // final response = await http.get(
  //     //   "http://192.168.2.161/kasbon-intek/public/api/finance/listBudget/${date}/${userID}",
  //     // );
  //     final response = await http.get(
  //         "http://192.168.1.113/kasbon-intek/public/api/finance/listBudget/2021-02-08/1");
  //     if (response.statusCode == 200) {
  //       // if every things are right
  //       var userData = await json.decode(response.body);
  //       print("DATANYA" + userData);
  //       return userData;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  static Future getBudget(int teamID, String date) async {
    try {
      final response = await http.get(
        "https://budget.intek.co.id/api/finance/listBudget/${date}/${teamID}",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print(userData);
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future getBudgetSingleUser(int teamID, String date, int userId) async {
    try {
      final response = await http.get(
        "https://budget.intek.co.id/api/finance/listBudgetSingle/${date}/${teamID}/${userId}",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print(userData);
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future getDetailBudget(int budgetID) async {
    try {
      final response = await http.get(
        "https://budget.intek.co.id/api/finance/detailBudget/${budgetID}",
      );
      if (response.statusCode == 200) {
        // if every things are right
        var userData = await json.decode(response.body);
        print("ID BUDGET NYA => " + budgetID.toString());
        return userData;
        // var list = (json.decode(response.body) as List)
        //   .map((data) => Late.fromJson(data))
        //   .toList();
        // return list;
      }
    } catch (e) {
      print(e);
    }
  }

  static Future sendRequestBudget(String pic, int user_id, String keperluan,
      double jumlah, int wilayah) async {
    try {
      // if you do not understand these data go to (insert_complant.php)
      var data = {
        'user_id': user_id,
        'pic': pic,
        'keperluan': keperluan,
        'jumlah': jumlah,
        'wilayah': wilayah
      };
      var response = await http.post(
        "https://budget.intek.co.id/api/finance/storeData",
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: json.encode(data),
      );
      if (response.statusCode == 200) {
        // if every things are right then return true
        var message = jsonDecode(response.body);

        print(message);
      }
    } catch (e) {
      print(e);
    }
  }

  //==================================CUTI API================================================

  static Future sendCuti(
    String id,
    String nama,
    String posisi,
    String jabatan,
    String atasan,
    String pic,
    String cuti,
    String masuk,
    String nomor,
    String pekerjaan,
    String alasan,
  ) async {
    try {
      // if you do not understand these data go to (insert_complant.php)
      var data = {
        'user_id': id,
        'name': nama,
        'position': posisi,
        'departement': jabatan,
        'supervisor': atasan,
        'replacement_pic': pic,
        'phone_number': nomor,
        'days_off_date': cuti,
        'back_to_office': masuk,
        'submitted_job': pekerjaan,
        'reason': alasan,
      };
      var response = await http.post(
        LINKAPI + "api/create_days_off",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
      );
      // var response = await http.post(
      //   "https://6268a04eaa65b5d23e77f552.mockapi.io/leave/",
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: json.encode(data),
      // );
      // if every things are right then return true
      // var message = jsonDecode(response.body);

      // log(message);

      if (response.statusCode == 200) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        return true;
      } else {
        // If the server did not return a 201 CREATED response,
        // then throw an exception.
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Leave>> fetchLeave(int id) async {
    final response = await http.post(
        Uri.parse(
          LINKAPI + 'api/days_off',
        ),
        body: {"user_id": id.toString()});

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return (jsonResponse.map((job) => new Leave.fromJson(job)).toList());

      // AdTemplate template = AdTemplate.fromJson(data[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
  }
  // Future<List<Leave>> fetchLeave() async {
  //   final response = await http
  //       .get(Uri.parse('https://6268a04eaa65b5d23e77f552.mockapi.io/leave/'));

  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse.map((job) => new Leave.fromJson(job)).toList();

  //     // AdTemplate template = AdTemplate.fromJson(data[0]);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //   }
  // }

  static Future cekCuti(String user, String pass) async {
    var response;
    var datauser;
    try {
      // response = await http.post(LINKAPI"api/login", body: {
      response = await http.post(LINKAPI + "api/login", body: {
        // response = await http.post(LINKAPI + "api/login", body: {
        "email": user
            .trim(), // we use trim method to avoid spaces that user may make when logging
        "password": pass
            .trim(), // we use trim method to avoid spaces that user may make when logging
      });
      if (response.statusCode == 200) {
        // if every things are right decode the response and insertInf then return true
        datauser = await json.decode(response.body)['data'];
        print(datauser);
        return true;
      }
    } catch (e) {
      print(e); // else print the error then return false

    }

    return false;
  }

  static Future<Report> fetchReport(String month, int id) async {
    final response = await http.post(
        Uri.parse(
          LINKAPI + 'api/chart',
        ),
        body: {"user_id": id.toString()});

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return Report.fromJson(jsonResponse[month]);

      // AdTemplate template = AdTemplate.fromJson(data[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
    }
    // final response = await http.get(
    //     Uri.parse('https://625eece2873d6798e2b059c4.mockapi.io/chart_api'));

    // // print(json.decode(response.body));

    // if (response.statusCode == 200) {
    //   var jsonResponse = json.decode(response.body);

    //   return Report.fromJson(jsonResponse[0][month]);

    //   // AdTemplate template = AdTemplate.fromJson(data[0]);

    // } else {
    //   print("gaje");
    //   // If the server did not return a 200 OK response,

    //   // then throw an exception.

    // }
  }
}
