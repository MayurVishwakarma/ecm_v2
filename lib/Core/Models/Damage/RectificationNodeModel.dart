class RectificationNodeModel {
  RectificationNodeModel({
    required this.omsId,
    required this.chakNo,
    required this.amsId,
    required this.amsNo,
    required this.rmsId,
    required this.rmsNo,
    required this.gatewayId,
    required this.gatewayNo,
    required this.gatewayName,
    required this.areaName,
    required this.description,
    required this.villageName,
    required this.khasarano,
    required this.firstName,
    required this.rectification,
  });

  final int? omsId;
  final String? chakNo;
  final int? amsId;
  final String? amsNo;
  final int? rmsId;
  final String? rmsNo;
  final int? gatewayId;
  final String? gatewayNo;
  final String? gatewayName;
  final String? areaName;
  final String? description;
  final dynamic villageName;
  final dynamic khasarano;
  final dynamic firstName;
  final int? rectification;

  RectificationNodeModel copyWith({
    int? omsId,
    String? chakNo,
    String? amsNo,
    String? rmsNo,
    String? gatewayNo,
    String? gatewayName,
    String? areaName,
    String? description,
    dynamic villageName,
    dynamic khasarano,
    dynamic firstName,
    int? rectification,
  }) {
    return RectificationNodeModel(
      omsId: omsId ?? this.omsId,
      chakNo: chakNo ?? this.chakNo,
      amsId: amsId ?? amsId,
      amsNo: amsNo ?? this.amsNo,
      rmsId: rmsId ?? rmsId,
      rmsNo: rmsNo ?? this.rmsNo,
      gatewayId: gatewayId ?? gatewayId,
      gatewayNo: gatewayNo ?? this.gatewayNo,
      gatewayName: gatewayName ?? this.gatewayName,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      villageName: villageName ?? this.villageName,
      khasarano: khasarano ?? this.khasarano,
      firstName: firstName ?? this.firstName,
      rectification: rectification ?? this.rectification,
    );
  }

  factory RectificationNodeModel.fromJson(Map<String, dynamic> json) {
    return RectificationNodeModel(
      omsId: json["OmsId"],
      chakNo: json["ChakNo"],
      amsId: json["AmsId"],
      amsNo: json["AmsNo"],
      rmsId: json["RmsId"],
      rmsNo: json["RmsNo"],
      gatewayId: json["GatewayId"],
      gatewayNo: json["GatewayNo"],
      gatewayName: json["GatewayName"],
      areaName: json["AreaName"],
      description: json["Description"],
      villageName: json["VillageName"],
      khasarano: json["Khasarano"],
      firstName: json["firstName"],
      rectification: json["Rectification"],
    );
  }

  Map<String, dynamic> toJson() => {
    "OmsId": omsId,
    "ChakNo": chakNo,
    "AmsId": amsId,
    "AmsNo": amsNo,
    "RmsId": rmsId,
    "RmsNo": rmsNo,
    "GatewayId": gatewayId,
    "GatewayNo": gatewayNo,
    "GatewayName": gatewayName,
    "AreaName": areaName,
    "Description": description,
    "VillageName": villageName,
    "Khasarano": khasarano,
    "firstName": firstName,
    "Rectification": rectification,
  };
}
