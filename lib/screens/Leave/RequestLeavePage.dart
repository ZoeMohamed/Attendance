import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:provider/provider.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/provider/parent.dart';
import 'package:schools_management/screens/DashboardMenu.dart';
import 'package:schools_management/screens/Leave/inicialLeavePage.dart';
import 'package:schools_management/widgets/custAlert.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:schools_management/widgets/loading_alert.dart';

class RequestLeavePage extends StatefulWidget {
  static const routeName = '/requestleave';
  final int sisa_cuti;
  RequestLeavePage({this.sisa_cuti});
  @override
  _RequestLeavePageState createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  DateFormat formatBulan;

  DateTimeRange dateRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 1)));

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController posisi = new TextEditingController();
  TextEditingController atasan = TextEditingController();
  TextEditingController pic = TextEditingController();
  TextEditingController nomor = TextEditingController();
  TextEditingController pekerjaan = TextEditingController();
  TextEditingController alasan = TextEditingController();

  ParentInf getParentInfo;
  String parentName;
  String parentDepartement;
  int parentCuti;
  int parentId;

  @override
  void initState() {
    formatBulan = DateFormat.MMMM('id');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getParentInfo = Provider.of<Parent>(context).getParentInf();
    parentName = getParentInfo.name;
    parentDepartement = getParentInfo.departement;
    parentCuti = getParentInfo.sisa_cuti;
    parentId = getParentInfo.id;

    TextEditingController nama = TextEditingController(text: parentName);
    TextEditingController jabatan =
        TextEditingController(text: parentDepartement);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    //TODO MPROF ID
    // var mprofId = "1";

    final start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;

    return Scaffold(
      backgroundColor: Color.fromRGBO(208, 210, 221, 1),
      // backgroundColor: Colors.red,
      appBar: CustomAppBar(
        title: "Request Leave",
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();

          return;
        },
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                  // width: width,
                  // height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          // image: AssetImage('dev_assets/1.png'),
                          image: AssetImage(
                            'dev_assets/home_bg.png',
                          ),
                          fit: BoxFit.fill,
                          opacity: 0.3),
                      color: Colors.white),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 8, 8, 8),
                                  child: Text(
                                    "Nama",
                                    style: TextStyle(
                                        color: Color.fromRGBO(14, 69, 84, 0.8),
                                        fontFamily: "Lato"),
                                  ),
                                ),
                                TextFormField(
                                  controller: nama,
                                  enabled: true, readOnly: true,
                                  // initialValue: 'Aldy Revigustian',
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(height: 0),

                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 15, 10, 15),
                                    // hintText: "Reason",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    filled: true,
                                    // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.text,

                                  minLines:
                                      1, //Normal textInputField will be displayed
                                  // maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Montserrat",
                                      color: Color.fromRGBO(14, 69, 84, 0.8)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width / 2.25,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Text(
                                          "Posisi",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.8),
                                              fontFamily: "Lato"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: posisi,
                                        // enabled: true, readOnly: true,
                                        // initialValue: 'Staff Programmer',
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),
                                          hintText: "Posisi",
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.3)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              15, 15, 10, 15),

                                          // hintText: "Reason",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          filled: true,
                                          // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                          fillColor: Colors.white,
                                        ),
                                        keyboardType: TextInputType.text,

                                        minLines:
                                            1, //Normal textInputField will be displayed

                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 13,
                                            color: Color.fromRGBO(
                                                14, 69, 84, 0.8)),
                                        validator: (value) {
                                          if (value.length < 1) {
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 2.25,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Text(
                                          "Jabatan",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.8),
                                              fontFamily: "Lato"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: jabatan,
                                        enabled: true, readOnly: true,
                                        // initialValue: 'Programmer',
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),

                                          contentPadding: EdgeInsets.fromLTRB(
                                              15, 15, 10, 15),

                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          filled: true,
                                          // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                          fillColor: Colors.white,
                                        ),
                                        keyboardType: TextInputType.text,

                                        minLines:
                                            1, //Normal textInputField will be displayed

                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Montserrat",
                                            color: Color.fromRGBO(
                                                14, 69, 84, 0.8)),
                                        validator: (value) {
                                          if (value.length < 1) {
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width / 2.25,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Text(
                                          "Atasan Langsung",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.8),
                                              fontFamily: "Lato"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: atasan,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),

                                          hintText: "Nama Atasan",
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.3)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              15, 15, 10, 15),

                                          // hintText: "Reason",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          filled: true,
                                          // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                          fillColor: Colors.white,
                                        ),
                                        keyboardType: TextInputType.text,

                                        minLines:
                                            1, //Normal textInputField will be displayed

                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Montserrat",
                                            color: Color.fromRGBO(
                                                14, 69, 84, 0.8)),
                                        validator: (value) {
                                          if (value.length < 1) {
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 2.25,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Text(
                                          "PIC Pengganti",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.8),
                                              fontFamily: "Lato"),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: pic,
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(height: 0),

                                          hintText: "Nama PIC Pengganti",
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Montserrat",
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.3)),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              15, 15, 10, 15),

                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(29),
                                          ),
                                          filled: true,
                                          // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                          fillColor: Colors.white,
                                        ),
                                        keyboardType: TextInputType.text,

                                        minLines:
                                            1, //Normal textInputField will be displayed

                                        style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: "Montserrat",
                                            color: Color.fromRGBO(
                                                14, 69, 84, 0.8)),
                                        validator: (value) {
                                          if (value.length < 1) {
                                            return '';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Text(
                                          "Cuti",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.8),
                                              fontFamily: "Lato"),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(29),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.5),
                                            )),
                                        child: FlatButton.icon(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 10, 10, 10),
                                          minWidth: width / 2.25,
                                          color: Colors.white,
                                          icon: Icon(
                                            // Icons.calendar_today,
                                            FluentIcons.calendar_ltr_28_filled,
                                            color:
                                                Color.fromRGBO(14, 69, 84, 1),
                                          ),
                                          height: 50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(29)),
                                          label: Text(
                                            DateFormat('dd ').format(start) +
                                                formatBulan.format(start) +
                                                DateFormat(' yyyy')
                                                    .format(start),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.8)),
                                          ),
                                          onPressed: pickDateRange,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 8),
                                        child: Text(
                                          "Masuk Kantor",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.8),
                                              fontFamily: "Lato"),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(29),
                                            border: Border.all(
                                              color: Color.fromRGBO(
                                                  14, 69, 84, 0.5),
                                            )),
                                        child: FlatButton.icon(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 10, 10, 10),
                                          minWidth: width / 2.25,
                                          color: Colors.white,
                                          icon: Icon(
                                            FluentIcons.calendar_ltr_28_filled,
                                            color:
                                                Color.fromRGBO(14, 69, 84, 1),
                                          ),
                                          height: 50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(29)),
                                          label: Text(
                                            DateFormat('dd ').format(end) +
                                                formatBulan.format(end) +
                                                DateFormat(' yyyy').format(end),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromRGBO(
                                                    14, 69, 84, 0.8)),
                                          ),
                                          onPressed: pickDateRange,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 10),
                            child: Text(
                              widget.sisa_cuti.toString() + " Hak Cuti Tahun",
                              style: TextStyle(
                                  color: Color.fromRGBO(14, 69, 84, 0.8),
                                  fontFamily: "Lato"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 8, 8, 8),
                                  child: Text(
                                    "Nomor Yang Dapat Di Hubungi",
                                    style: TextStyle(
                                        color: Color.fromRGBO(14, 69, 84, 0.8),
                                        fontFamily: "Lato"),
                                  ),
                                ),
                                TextFormField(
                                  controller: nomor,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(height: 0),

                                    hintText: "Nomor Yang Dapat Di Hubungi",
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Montserrat",
                                        color: Color.fromRGBO(14, 69, 84, 0.3)),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 15, 10, 15),
                                    // hintText: "Reason",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    filled: true,
                                    // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  minLines:
                                      1, //Normal textInputField will be displayed
                                  // maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Montserrat",
                                      color: Color.fromRGBO(14, 69, 84, 0.8)),
                                  validator: (value) {
                                    if (value.length < 1) {
                                      return '';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 8, 8, 8),
                                  child: Text(
                                    "Pekerjaan Yang Diserahkan",
                                    style: TextStyle(
                                        color: Color.fromRGBO(14, 69, 84, 0.8),
                                        fontFamily: "Lato"),
                                  ),
                                ),
                                TextFormField(
                                  controller: pekerjaan,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(height: 0),

                                    hintText: "Pekerjaan Yang Diserahkan",
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Montserrat",
                                        color: Color.fromRGBO(14, 69, 84, 0.3)),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 15, 10, 15),
                                    // hintText: "Reason",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    filled: true,
                                    // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.multiline,

                                  minLines:
                                      2, //Normal textInputField will be displayed
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Montserrat",
                                      color: Color.fromRGBO(14, 69, 84, 0.8)),
                                  validator: (value) {
                                    if (value.length < 1) {
                                      return '';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 8, 8, 8),
                                  child: Text(
                                    "Alasan",
                                    style: TextStyle(
                                        color: Color.fromRGBO(14, 69, 84, 0.8),
                                        fontFamily: "Lato"),
                                  ),
                                ),
                                TextFormField(
                                  controller: alasan,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(height: 0),

                                    hintText: "Tambah Alasan",
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontFamily: "Montserrat",
                                        color: Color.fromRGBO(14, 69, 84, 0.3)),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 15, 10, 15),
                                    // hintText: "Reason",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(14, 69, 84, 0.5)),
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                    filled: true,
                                    // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 50),
                                    fillColor: Colors.white,
                                  ),
                                  keyboardType: TextInputType.multiline,

                                  minLines:
                                      2, //Normal textInputField will be displayed
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: "Montserrat",
                                      color: Color.fromRGBO(14, 69, 84, 0.8)),
                                  validator: (value) {
                                    if (value.length < 1) {
                                      return '';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            // child: FlatButton(
                            //   onPressed: () {},
                            //   child: Text(
                            //     "Submit Request",
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontFamily: "Lato",
                            //         fontSize: 17,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            //   minWidth: width,
                            //   height: 50,
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(29)),
                            //   color: Color.fromRGBO(14, 69, 84, 1),
                            // ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: ElevatedButton(
                                  child: Text(
                                    "SUBMIT",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      showLoadingProgress(context);

                                      bool res = await GetHelper.sendCuti(
                                        parentId.toString(),
                                        parentName,
                                        posisi.text,
                                        parentDepartement,
                                        atasan.text,
                                        pic.text,
                                        DateFormat('yyy-MM-dd')
                                            .format(start)
                                            .toString(),
                                        DateFormat('yyy-MM-dd')
                                            .format(end)
                                            .toString(),
                                        nomor.text.toString(),
                                        pekerjaan.text,
                                        alasan.text,
                                      );
                                      // bool res = await GetHelper.sendCuti(
                                      //   parentId.toString(),
                                      //   parentName,
                                      //   posisi.text,
                                      //   parentDepartement,
                                      //   atasan.text,
                                      //   pic.text,
                                      //   nomor.text,
                                      // DateFormat('yyy-MM-dd')
                                      //     .format(start)
                                      //     .toString(),
                                      //   DateFormat('yyy-MM-dd')
                                      //       .format(end)
                                      //       .toString(),
                                      //   pekerjaan.text,
                                      //   alasan.text
                                      // );

                                      if (res == true) {
                                        showCustAlert(
                                            height: 280,
                                            context: context,
                                            title: "Success",
                                            buttonString: "OK",
                                            onSubmit: () {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DashboardMenu()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            },
                                            detailContent:
                                                "Success request leave",
                                            pathLottie: "success");
                                      }
                                      if (res == false) {
                                        showCustAlert(
                                            height: 280,
                                            context: context,
                                            title: "Failed",
                                            buttonString: "OK",
                                            onSubmit: () {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              InicialLeavePage()),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            },
                                            detailContent:
                                                "Failed request leave",
                                            pathLottie: "error");
                                      }
                                    }
                                    // log(nama.text);
                                    // log(posisi.text);
                                    // log(jabatan.text);
                                    // log(DateFormat('yyy-MM-dd').format(start));
                                    // log(DateFormat('yyy-MM-dd').format(end));
                                    // log(atasan.text);
                                    // log(pic.text);
                                    // log(nomor.text);
                                    // log(pekerjaan.text);
                                    // log(alasan.text);
                                    // log(mprof_id);

                                    // _login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF3e6a76),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 20),
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        initialDateRange: dateRange);

    if (newDateRange == null) return;
    setState(() => dateRange = newDateRange);
  }
}
