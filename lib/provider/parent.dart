/**the provider for parent */

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:schools_management/constant.dart';

//ParentClass
class ParentInf {
  final int id;
  final String email;
  final String name;
  final String created_at;
  final String image_profile;
  final int team_id;
  final String departement;
  final int sisa_cuti;
  ParentInf(
      {this.id,
      this.email,
      this.name,
      this.created_at,
      this.image_profile,
      this.team_id,
      this.departement,
      this.sisa_cuti});
}

// the class for the provider

class Parent with ChangeNotifier {
  ParentInf _inf; // we will put the data that we will get at this variable

  // we will get the _inf variable by calling this function
  ParentInf getParentInf() {
    return _inf;
  }

  // we will insert the data using this function
  void setParentInf(ParentInf inf) {
    _inf = inf;
    print(_inf);
    notifyListeners();
  }

  //we will use this function to login and get parent infromation by passing the username and password to it
  // we use it Future Boolean <so when we use it we check if the user logged properly return true other wise return false>
  Future<bool> loginParentAndGetInf(String user, String pass) async {
    var response;
    var datauser;
    try {
      // response = await http.post(LINKAPI"api/login", body: {
      response = await http.post(LINKAPIRIL + "api/login", body: {
        // response = await http.post(LINKAPI + "api/login", body: {
        "email": user
            .trim(), // we use trim method to avoid spaces that user may make when logging
        "password": pass
            .trim(), // we use trim method to avoid spaces that user may make when logging
      });
      if (response.statusCode == 200) {
        // if every things are right decode the response and insertInf then return true
        datauser = await json.decode(response.body);
        print(response.body);
        insertInf(datauser);
        return true;
      }
    } catch (e) {
      print(e); // else print the error then return false

    }

    return false;
  }

// i just used this function to make the code more organised and not so messed
  insertInf(dynamic datauser) {
    ParentInf parentInf = ParentInf(
        id: datauser['data']['id'],
        name: datauser['data']['name'],
        email: datauser['data']['email'],
        created_at: datauser['data']['created_at'],
        image_profile: datauser['image_profile'],
        team_id: datauser['data']['teamID'],
        departement: datauser['data']['departement'],
        sisa_cuti: datauser['data']['sisa cuti']);
    // after inserting then pass it to setParentInf to insert the data to our _inf variable
    setParentInf(parentInf);
  }

  logOut() {
    _inf =
        new ParentInf(); // we will empty the _inf variable cause the user logged out
    notifyListeners();
    print(_inf.id);
  }
}
