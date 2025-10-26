class UserMasterModel {
  UserMasterModel({
    required this.userid,
    required this.mobileNo,
    required this.email,
    required this.mobMessage,
    required this.token,
    required this.userType,
    required this.fName,
    required this.lName,
    required this.pwd,
    required this.notify,
    required this.isDryTestUser,
    required this.designation,
  });

  final int? userid;
  final String? mobileNo;
  final String? email;
  final String? mobMessage;
  final String? token;
  final String? userType;
  final String? fName;
  final String? lName;
  final String? pwd;
  final String? notify;
  final int? isDryTestUser;
  final String? designation;

  UserMasterModel copyWith({
    int? userid,
    String? mobileNo,
    String? email,
    String? mobMessage,
    String? token,
    String? userType,
    String? fName,
    String? lName,
    String? pwd,
    String? notify,
    int? isDryTestUser,
    String? designation,
  }) {
    return UserMasterModel(
      userid: userid ?? this.userid,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      mobMessage: mobMessage ?? this.mobMessage,
      token: token ?? this.token,
      userType: userType ?? this.userType,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      pwd: pwd ?? this.pwd,
      notify: notify ?? this.notify,
      isDryTestUser: isDryTestUser ?? this.isDryTestUser,
      designation: designation ?? this.designation,
    );
  }

  factory UserMasterModel.fromJson(Map<String, dynamic> json) {
    return UserMasterModel(
      userid: json["userid"],
      mobileNo: json["mobileNo"],
      email: json["email"],
      mobMessage: json["MobMessage"],
      token: json["Token"],
      userType: json["userType"],
      fName: json["FName"],
      lName: json["LName"],
      pwd: json["pwd"],
      notify: json["notify"],
      isDryTestUser: json["isDryTestUser"],
      designation: json["designation"],
    );
  }

  Map<String, dynamic> toJson() => {
    "userid": userid,
    "mobileNo": mobileNo,
    "email": email,
    "MobMessage": mobMessage,
    "Token": token,
    "userType": userType,
    "FName": fName,
    "LName": lName,
    "pwd": pwd,
    "notify": notify,
    "isDryTestUser": isDryTestUser,
    "designation": designation,
  };
}
