class DamageHistoryModel {
  DamageHistoryModel({
    required this.id,
    required this.chakNo,
    required this.areaName,
    required this.description,
    required this.dateTime,
    required this.userId,
    required this.username,
    required this.remark,
    required this.electDamageList,
    required this.mechDamageList,
    required this.damageImageList,
  });

  final int? id;
  final String? chakNo;
  final String? areaName;
  final String? description;
  final DateTime? dateTime;
  final int? userId;
  final dynamic username;
  final String? remark;
  final String? electDamageList;
  final String? mechDamageList;
  final String? damageImageList;

  DamageHistoryModel copyWith({
    int? id,
    String? chakNo,
    String? areaName,
    String? description,
    DateTime? dateTime,
    int? userId,
    dynamic username,
    String? remark,
    String? electDamageList,
    String? mechDamageList,
    String? damageImageList,
  }) {
    return DamageHistoryModel(
      id: id ?? this.id,
      chakNo: chakNo ?? this.chakNo,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      remark: remark ?? this.remark,
      electDamageList: electDamageList ?? this.electDamageList,
      mechDamageList: mechDamageList ?? this.mechDamageList,
      damageImageList: damageImageList ?? this.damageImageList,
    );
  }

  factory DamageHistoryModel.fromJson(Map<String, dynamic> json) {
    return DamageHistoryModel(
      id: json["Id"],
      chakNo: json["ChakNo"],
      areaName: json["AreaName"],
      description: json["Description"],
      dateTime: DateTime.tryParse(json["DateTime"] ?? ""),
      userId: json["UserId"],
      username: json["Username"],
      remark: json["Remark"],
      electDamageList: json["ElectDamageList"],
      mechDamageList: json["MechDamageList"],
      damageImageList: json["DamageImageList"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ChakNo": chakNo,
    "AreaName": areaName,
    "Description": description,
    "DateTime": dateTime?.toIso8601String(),
    "UserId": userId,
    "Username": username,
    "Remark": remark,
    "ElectDamageList": electDamageList,
    "MechDamageList": mechDamageList,
    "DamageImageList": damageImageList,
  };
}
