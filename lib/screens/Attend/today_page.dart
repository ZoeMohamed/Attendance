import 'package:flutter/material.dart';
import 'package:schools_management/helper/get_helper.dart';
import 'package:schools_management/widgets/custom_app_bar.dart';
import 'package:schools_management/widgets/group_tile.dart';
import 'package:shimmer/shimmer.dart';

class Today extends StatefulWidget {
  final String studentId;

  Today({this.studentId});

  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  var groups;
  bool _enabled = true;
  @override
  void initState() {
    groups = GetHelper
        .getListAttend(); // get the data using this function from GetHelper class we pass
    //the student id and name of php file that we use to get data then kind of input for data
    // if you do not understand go and have look at GetHelper class
    super.initState();
    print(groups);
  }

  Future refresh() {
    return GetHelper.getListAttend();
  }
  // goToTasksPage(String groupId) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => Tasks(
  //               groupId: groupId,
  //             )),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Attendance",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            // we will use future builder to show the data in a list view
            // we put the future variable
            // check if there is no show a message to user no data
            // else show a list view with tiles tha show our data
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();

                return;
              },
              child: RefreshIndicator(
                  color: Color.fromRGBO(50, 97, 109, 1),
                  onRefresh: refresh,
                  child: FutureBuilder(
                    future: groups,
                    builder: (context, snapshots) {
                      if (!snapshots.hasData || snapshots.data.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            enabled: _enabled,
                            child: ListView.builder(
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
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
                                                      BorderRadius.circular(7)),
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
                                                      BorderRadius.circular(7)),
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
                                                      BorderRadius.circular(7)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 9,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        itemCount: snapshots.data.length,
                        itemBuilder: (context, index) {
                          return GroupTile(
                              name: snapshots.data[index]['name'],
                              subject: snapshots.data[index]['keterangan'],
                              time: snapshots.data[index]['waktu'],
                              function: () => print("Clicked")
                              // goToTasksPage(snapshots.data[index]['id']),
                              );
                        },
                      );
                    },
                  )),
            ),
          )),
        ],
      ),
    );
  }
}
