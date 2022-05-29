class Leave {
  final int id;
  final String name;
  final String position;
  final String departement;
  final String supervisor;
  final String replacement_pic;
  final String phone_number;
  final String days_off_date;
  final String back_to_office;
  final String submitted_job;
  final String reason;
  final int status;

  // "response_date": "2022-05-20 15:29:17",
  // "created_at": "2022-05-20 15:29:17",
  // "updated_at": "2022-05-20 15:29:17"

  Leave(
      {this.id,
      this.name,
      this.position,
      this.departement,
      this.supervisor,
      this.replacement_pic,
      this.phone_number,
      this.days_off_date,
      this.back_to_office,
      this.submitted_job,
      this.reason,
      this.status});

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
        id: json['id'],
        name: json['name'],
        position: json['position'],
        departement: json['departement'],
        supervisor: json['supervisor'],
        replacement_pic: json['replacement_pic'],
        phone_number: json['nomor_telepon'],
        days_off_date: json['days_off_date'],
        back_to_office: json['back_to_office'],
        submitted_job: json['submitted_job'],
        reason: json['reason'],
        status: json['status']);
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['name'] = this.name;
  //   data['position'] = this.position;
  //   data['departement'] = this.departement;
  //   data['supervisor'] = this.supervisor;
  //   data['pic_pengganti'] = this.replacement_pic;
  //   data['nomor_telepon'] = this.phone_number;
  //   data['days_off_date'] = this.days_off_date;
  //   data['back_to_office'] = this.back_to_office;
  //   data['submitted_job'] = this.submitted_job;
  //   data['reason'] = this.reason;
  //   data['mprof_id'] = this.mprofId;
  //   data['status'] = this.status;
  //   return data;
  // }
}
