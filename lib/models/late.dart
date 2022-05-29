import 'package:flutter/material.dart';
class Late {
  String name;
  String keterangan;
  AssetImage userPict;
  String waktu;

  Late({this.name, this.keterangan, this.userPict, this.waktu});

  Late.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    keterangan = json['keterangan'];
    userPict = json['userPict'];
    waktu = json['waktu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['keterangan'] = this.keterangan;
    data['userPict'] = this.userPict;
    data['waktu'] = this.waktu;
    return data;
  }
}