class MaterialStatusListModel {
  MaterialStatusListModel({
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
    required this.electrical,
    required this.tubing,
    required this.mechanical,
    required this.reportedOn,
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
  final String? description;
  final int? electrical;
  final int? tubing;
  final int? mechanical;
  final DateTime? reportedOn;

  MaterialStatusListModel copyWith({
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
    int? electrical,
    int? tubing,
    int? mechanical,
    DateTime? reportedOn,
  }) {
    return MaterialStatusListModel(
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
      electrical: electrical ?? this.electrical,
      tubing: tubing ?? this.tubing,
      mechanical: mechanical ?? this.mechanical,
      reportedOn: reportedOn ?? this.reportedOn,
    );
  }

  factory MaterialStatusListModel.fromJson(Map<String, dynamic> json) {
    return MaterialStatusListModel(
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
      electrical: json["Electrical"],
      tubing: json["Tubing"],
      mechanical: json["Mechanical"],
      reportedOn: DateTime.tryParse(json["reportedOn"] ?? ""),
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
    "Electrical": electrical,
    "Tubing": tubing,
    "Mechanical": mechanical,
    "reportedOn": reportedOn?.toIso8601String(),
  };
}
