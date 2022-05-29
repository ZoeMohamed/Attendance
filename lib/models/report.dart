class Report {
  int att;
  int late;
  int notatt;

  Report({this.att, this.late, this.notatt});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(att: json['in'], late: json['late'], notatt: json['notatt']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['att'] = this.att;
  //   data['late'] = this.late;
  //   data['notatt'] = this.notatt;
  //   print(data);
  //   return data;
  // }
}