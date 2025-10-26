class InformationHistoryModel {
  InformationHistoryModel({
    required this.id,
    required this.chakNo,
    required this.areaName,
    required this.description,
    required this.reportedOn,
    required this.reportedBy,
    required this.username,
    required this.remark,
    required this.informationList,
  });

  final int? id;
  final String? chakNo;
  final String? areaName;
  final String? description;
  final DateTime? reportedOn;
  final int? reportedBy;
  final String? username;
  final String? remark;
  final String? informationList;

  InformationHistoryModel copyWith({
    int? id,
    String? chakNo,
    String? areaName,
    String? description,
    DateTime? reportedOn,
    int? reportedBy,
    String? username,
    String? remark,
    String? informationList,
  }) {
    return InformationHistoryModel(
      id: id ?? this.id,
      chakNo: chakNo ?? this.chakNo,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      reportedOn: reportedOn ?? this.reportedOn,
      reportedBy: reportedBy ?? this.reportedBy,
      username: username ?? this.username,
      remark: remark ?? this.remark,
      informationList: informationList ?? this.informationList,
    );
  }

  factory InformationHistoryModel.fromJson(Map<String, dynamic> json) {
    return InformationHistoryModel(
      id: json["Id"],
      chakNo: json["ChakNo"],
      areaName: json["AreaName"],
      description: json["Description"],
      reportedOn: DateTime.tryParse(json["ReportedOn"] ?? ""),
      reportedBy: json["ReportedBy"],
      username: json["Username"],
      remark: json["Remark"],
      informationList: json["InformationList"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ChakNo": chakNo,
    "AreaName": areaName,
    "Description": description,
    "ReportedOn": reportedOn?.toIso8601String(),
    "ReportedBy": reportedBy,
    "Username": username,
    "Remark": remark,
    "InformationList": informationList,
  };
}
