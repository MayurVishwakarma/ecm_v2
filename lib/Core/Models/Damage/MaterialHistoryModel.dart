class MaterialHistoryModel {
  MaterialHistoryModel({
    required this.id,
    required this.chakNo,
    required this.amsNo,
    required this.rmsNo,
    required this.gatewayNo,
    required this.gatewayName,
    required this.areaName,
    required this.description,
    required this.reportedOn,
    required this.reportedBy,
    required this.username,
    required this.remark,
    required this.electRectifyList,
    required this.tubRectifyList,
    required this.mechRectifyList,
  });

  final int? id;
  final String? chakNo;
  final String? amsNo;
  final String? rmsNo;
  final String? gatewayNo;
  final String? gatewayName;
  final String? areaName;
  final String? description;
  final DateTime? reportedOn;
  final int? reportedBy;
  final String? username;
  final String? remark;
  final String? electRectifyList;
  final String? tubRectifyList;
  final String? mechRectifyList;

  MaterialHistoryModel copyWith({
    int? id,
    String? chakNo,
    String? amsNo,
    String? rmsNo,
    String? gatewayNo,
    String? gatewayName,
    String? areaName,
    String? description,
    DateTime? reportedOn,
    int? reportedBy,
    String? username,
    String? remark,
    String? electRectifyList,
    String? tubRectifyList,
    String? mechRectifyList,
  }) {
    return MaterialHistoryModel(
      id: id ?? this.id,
      chakNo: chakNo ?? this.chakNo,
      amsNo: amsNo ?? this.amsNo,
      rmsNo: rmsNo ?? this.rmsNo,
      gatewayNo: gatewayNo ?? this.gatewayNo,
      gatewayName: gatewayName ?? this.gatewayName,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      reportedOn: reportedOn ?? this.reportedOn,
      reportedBy: reportedBy ?? this.reportedBy,
      username: username ?? this.username,
      remark: remark ?? this.remark,
      electRectifyList: electRectifyList ?? this.electRectifyList,
      tubRectifyList: tubRectifyList ?? this.tubRectifyList,
      mechRectifyList: mechRectifyList ?? this.mechRectifyList,
    );
  }

  factory MaterialHistoryModel.fromJson(Map<String, dynamic> json) {
    return MaterialHistoryModel(
      id: json["Id"],
      chakNo: json["ChakNo"],
      amsNo: json["AmsNo"],
      rmsNo: json["RmsNo"],
      gatewayNo: json["GatewayNo"],
      gatewayName: json["GatewayName"],
      areaName: json["AreaName"],
      description: json["Description"],
      reportedOn: DateTime.tryParse(json["ReportedOn"] ?? ""),
      reportedBy: json["ReportedBy"],
      username: json["Username"],
      remark: json["Remark"],
      electRectifyList: json["ElectRectifyList"],
      tubRectifyList: json["TubRectifyList"],
      mechRectifyList: json["MechRectifyList"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ChakNo": chakNo,
    "AmsNo": amsNo,
    "RmsNo": rmsNo,
    "GatewayNo": gatewayNo,
    "GatewayName": gatewayName,
    "AreaName": areaName,
    "Description": description,
    "ReportedOn": reportedOn?.toIso8601String(),
    "ReportedBy": reportedBy,
    "Username": username,
    "Remark": remark,
    "ElectRectifyList": electRectifyList,
    "TubRectifyList": tubRectifyList,
    "MechRectifyList": mechRectifyList,
  };
}
