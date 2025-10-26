class ReportHistoryModel {
  ReportHistoryModel({
    required this.chakNo,
    required this.areaName,
    required this.description,
    required this.processName,
    required this.approvedStatus,
    required this.changedOn,
    required this.changedBy,
    required this.username,
    required this.remark,
  });

  final String? chakNo;
  final String? areaName;
  final String? description;
  final String? processName;
  final int? approvedStatus;
  final DateTime? changedOn;
  final int? changedBy;
  final String? username;
  final String? remark;

  ReportHistoryModel copyWith({
    String? chakNo,
    String? areaName,
    String? description,
    String? processName,
    int? approvedStatus,
    DateTime? changedOn,
    int? changedBy,
    String? username,
    String? remark,
  }) {
    return ReportHistoryModel(
      chakNo: chakNo ?? this.chakNo,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      processName: processName ?? this.processName,
      approvedStatus: approvedStatus ?? this.approvedStatus,
      changedOn: changedOn ?? this.changedOn,
      changedBy: changedBy ?? this.changedBy,
      username: username ?? this.username,
      remark: remark ?? this.remark,
    );
  }

  factory ReportHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReportHistoryModel(
      chakNo: json["ChakNo"],
      areaName: json["AreaName"],
      description: json["Description"],
      processName: json["ProcessName"],
      approvedStatus: json["ApprovedStatus"],
      changedOn: DateTime.tryParse(json["ChangedOn"] ?? ""),
      changedBy: json["ChangedBy"],
      username: json["Username"],
      remark: json["Remark"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ChakNo": chakNo,
    "AreaName": areaName,
    "Description": description,
    "ProcessName": processName,
    "ApprovedStatus": approvedStatus,
    "ChangedOn": changedOn?.toIso8601String(),
    "ChangedBy": changedBy,
    "Username": username,
    "Remark": remark,
  };
}
