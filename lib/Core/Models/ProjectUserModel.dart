class ProjectUserDetailsModel {
  ProjectUserDetailsModel({
    required this.userid,
    required this.firstname,
    required this.emailaddress,
    required this.mobilenumber,
  });

  final int? userid;
  final String? firstname;
  final String? emailaddress;
  final dynamic mobilenumber;

  ProjectUserDetailsModel copyWith({
    int? userid,
    String? firstname,
    String? emailaddress,
    dynamic mobilenumber,
  }) {
    return ProjectUserDetailsModel(
      userid: userid ?? this.userid,
      firstname: firstname ?? this.firstname,
      emailaddress: emailaddress ?? this.emailaddress,
      mobilenumber: mobilenumber ?? this.mobilenumber,
    );
  }

  factory ProjectUserDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProjectUserDetailsModel(
      userid: json["userid"],
      firstname: json["firstname"],
      emailaddress: json["emailaddress"],
      mobilenumber: json["mobilenumber"],
    );
  }

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "firstname": firstname,
    "emailaddress": emailaddress,
    "mobilenumber": mobilenumber,
  };
}
