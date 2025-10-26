class EcmNodeListMasterModel {
  static const String tableName = "ecm_node_list";
  static const Map<String, String> schema = {
    "OmsId": "INTEGER",
    "ChakNo": "TEXT",
    "AmsId": "INTEGER",
    "AmsNo": "TEXT",
    "RmsId": "INTEGER",
    "RmsNo": "TEXT",
    "AreaName": "TEXT",
    "Description": "TEXT",
    "Mechanical": "TEXT",
    "Erection": "TEXT",
    "DryCommissioning": "TEXT",
    "WetCommissioning": "TEXT",
    "GateWayId": "INTEGER",
    "GatewayNo": "TEXT",
    "GatewayName": "TEXT",
    "Process1": "TEXT",
    "Process2": "TEXT",
    "Process3": "TEXT",
    "ProjectId": "INTEGER",
    "DeviceType": "TEXT",
    "IsSaved": "INTEGER DEFAULT 0",
  };
  EcmNodeListMasterModel({
    required this.omsId,
    required this.chakNo,
    required this.amsId,
    required this.amsNo,
    required this.rmsId,
    required this.rmsNo,
    required this.areaName,
    required this.description,
    required this.mechanical,
    required this.erection,
    required this.dryCommissioning,
    required this.wetCommissioning,
    required this.gateWayId,
    required this.gatewayNo,
    required this.gatewayName,
    required this.process1,
    required this.process2,
    required this.process3,
    this.projectId,
    this.deviceType,
    this.isSaved,
  });

  final int? omsId;
  final String? chakNo;
  final int? amsId;
  final String? amsNo;
  final int? rmsId;
  final String? rmsNo;
  final String? areaName;
  final String? description;
  final String? mechanical;
  final dynamic erection;
  final dynamic dryCommissioning;
  final dynamic wetCommissioning;
  final int? gateWayId;
  final String? gatewayNo;
  final String? gatewayName;
  final dynamic process1;
  final dynamic process2;
  final dynamic process3;
  int? projectId;
  String? deviceType;
  int? isSaved;

  EcmNodeListMasterModel copyWith({
    int? omsId,
    String? chakNo,
    int? amsId,
    String? amsNo,
    int? rmsId,
    String? rmsNo,
    String? areaName,
    String? description,
    String? mechanical,
    dynamic erection,
    dynamic dryCommissioning,
    dynamic wetCommissioning,
    int? gateWayId,
    String? gatewayNo,
    String? gatewayName,
    dynamic process1,
    dynamic process2,
    dynamic process3,
    int? projectId,
    String? deviceType,
    int? isSaved,
  }) {
    return EcmNodeListMasterModel(
      omsId: omsId ?? this.omsId,
      chakNo: chakNo ?? this.chakNo,
      amsId: amsId ?? this.amsId,
      amsNo: amsNo ?? this.amsNo,
      rmsId: rmsId ?? this.rmsId,
      rmsNo: rmsNo ?? this.rmsNo,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      mechanical: mechanical ?? this.mechanical,
      erection: erection ?? this.erection,
      dryCommissioning: dryCommissioning ?? this.dryCommissioning,
      wetCommissioning: wetCommissioning ?? this.wetCommissioning,
      gateWayId: gateWayId ?? this.gateWayId,
      gatewayNo: gatewayNo ?? this.gatewayNo,
      gatewayName: gatewayName ?? this.gatewayName,
      process1: process1 ?? this.process1,
      process2: process2 ?? this.process2,
      process3: process3 ?? this.process3,
      projectId: projectId ?? this.projectId,
      deviceType: deviceType ?? this.deviceType,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  factory EcmNodeListMasterModel.fromJson(Map<String, dynamic> json) {
    return EcmNodeListMasterModel(
      omsId: json["OmsId"],
      chakNo: json["ChakNo"],
      amsId: json["AmsId"],
      amsNo: json["AmsNo"],
      rmsId: json["RmsId"],
      rmsNo: json["RmsNo"],
      areaName: json["AreaName"],
      description: json["Description"],
      mechanical: json["Mechanical"],
      erection: json["Erection"],
      dryCommissioning: json["DryCommissioning"],
      wetCommissioning: json["WetCommissioning"],
      gateWayId: json["GateWayId"],
      gatewayNo: json["GatewayNo"],
      gatewayName: json["GatewayName"],
      process1: json["Process1"],
      process2: json["Process2"],
      process3: json["Process3"],
      projectId: json["ProjectId"],
      deviceType: json["DeviceType"],
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
    "AreaName": areaName,
    "Description": description,
    "Mechanical": mechanical,
    "Erection": erection,
    "DryCommissioning": dryCommissioning,
    "WetCommissioning": wetCommissioning,
    "GateWayId": gateWayId,
    "GatewayNo": gatewayNo,
    "GatewayName": gatewayName,
    "Process1": process1,
    "Process2": process2,
    "Process3": process3,
    "ProjectId": projectId,
    "DeviceType": deviceType,
    "IsSaved": isSaved,
  };
}
