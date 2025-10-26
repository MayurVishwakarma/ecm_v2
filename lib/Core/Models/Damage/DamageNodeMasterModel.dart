class DamageNodeModel {
  static const String tableName = "damage_node_list";

  static const Map<String, String> schema = {
    "OmsId": "INTEGER",
    "ChakNo": "TEXT",
    "AmsId": "INTEGER",
    "AmsNo": "TEXT",
    "RmsId": "INTEGER",
    "RmsNo": "TEXT",
    "GateWayId": "INTEGER",
    "GatewayNo": "TEXT",
    "GatewayName": "TEXT",
    "AreaName": "TEXT",
    "Description": "TEXT",
    "VillageName": "TEXT",
    "Khasarano": "TEXT",
    "firstName": "TEXT",
    "Electrical": "TEXT", // stored as TEXT, you can parse later
    "Mechanical": "TEXT",
    "ProjectId": "INTEGER",
    "DeviceType": "TEXT",
    "IsSaved": "INTEGER DEFAULT 0",
  };
  DamageNodeModel({
    required this.omsId,
    required this.chakNo,
    required this.amsId,
    required this.amsNo,
    required this.rmsId,
    required this.rmsNo,
    required this.gateWayId,
    required this.gatewayNo,
    required this.gatewayName,
    required this.areaName,
    required this.description,
    required this.villageName,
    required this.khasarano,
    required this.firstName,
    required this.electrical,
    required this.mechanical,
    this.deviceType,
    this.projectId,
    this.isSaved = 0,
  });

  final int? omsId;
  final String? chakNo;
  final int? amsId;
  final String? amsNo;
  final int? rmsId;
  final String? rmsNo;
  final int? gateWayId;
  final String? gatewayNo;
  final String? gatewayName;
  final String? areaName;
  String? description;
  final String? villageName;
  final String? khasarano;
  final String? firstName;
  final dynamic electrical;
  final dynamic mechanical;
  dynamic deviceType;
  dynamic projectId;
  int? isSaved;

  DamageNodeModel copyWith({
    int? omsId,
    String? chakNo,
    int? amsId,
    String? amsNo,
    int? rmsId,
    String? rmsNo,
    int? gateWayId,
    String? gatewayNo,
    String? gatewayName,
    String? areaName,
    String? description,
    String? villageName,
    String? khasarano,
    String? firstName,
    dynamic electrical,
    dynamic mechanical,
    dynamic deviceType,
    dynamic projectId,
    int? isSaved,
  }) {
    return DamageNodeModel(
      omsId: omsId ?? this.omsId,
      chakNo: chakNo ?? this.chakNo,
      amsId: amsId ?? this.amsId,
      amsNo: amsNo ?? this.amsNo,
      rmsId: rmsId ?? this.rmsId,
      rmsNo: rmsNo ?? this.rmsNo,
      gateWayId: gateWayId ?? this.gateWayId,
      gatewayNo: gatewayNo ?? this.gatewayNo,
      gatewayName: gatewayName ?? this.gatewayName,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      villageName: villageName ?? this.villageName,
      khasarano: khasarano ?? this.khasarano,
      firstName: firstName ?? this.firstName,
      electrical: electrical ?? this.electrical,
      mechanical: mechanical ?? this.mechanical,
      deviceType: deviceType ?? this.deviceType,
      projectId: projectId ?? this.projectId,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  factory DamageNodeModel.fromJson(Map<String, dynamic> json) {
    return DamageNodeModel(
      omsId: json["OmsId"],
      chakNo: json["ChakNo"],
      amsId: json["AmsId"],
      amsNo: json["AmsNo"],
      rmsId: json["RmsId"],
      rmsNo: json["RmsNo"],
      gateWayId: json["GateWayId"],
      gatewayNo: json["GatewayNo"],
      gatewayName: json["GatewayName"],
      areaName: json["AreaName"],
      description: json["Description"],
      villageName: json["VillageName"],
      khasarano: json["Khasarano"],
      firstName: json["firstName"],
      electrical: json["Electrical"],
      mechanical: json["Mechanical"],
      deviceType: json["DeviceType"],
      projectId: json["ProjectId"],
      isSaved: json["IsSaved"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OmsId": omsId,
    "ChakNo": chakNo,
    "AmsId": amsId,
    "AmsNo": amsNo,
    "RmsId": rmsId,
    "RmsNo": rmsNo,
    "GateWayId": gateWayId,
    "GatewayNo": gatewayNo,
    "GatewayName": gatewayName,
    "AreaName": areaName,
    "Description": description,
    "VillageName": villageName,
    "Khasarano": khasarano,
    "firstName": firstName,
    "Electrical": electrical,
    "Mechanical": mechanical,
    "DeviceType": deviceType,
    "ProjectId": projectId,
    "IsSaved": isSaved,
  };
}
