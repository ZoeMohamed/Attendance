import 'package:flutter/material.dart';

class GridModel {
  String _imagePath;
  Color _bgColor;
  String _route;
  int user_id;

  GridModel(this._imagePath, this._route, this._bgColor,{this.user_id});

  String get imagePath => _imagePath;

  set imagePath(String value) {
    _imagePath = value;
  }

  String get route => _route;

  set route(String value) {
    _route = value;
  }

  Color get bgColor => _bgColor;

  set bgColor(Color value) {
    _bgColor = value;
  }
}
