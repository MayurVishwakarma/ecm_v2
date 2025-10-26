import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DamageReportModel {
  static const String tableName = "damage_report";
  static const Map<String, String> schema = {
    "Id": "INTEGER",
    "Damage": "TEXT",
    "OmsId": "INTEGER",
    "Amsid": "INTEGER",
    "Rmsid": "INTEGER",
    "GateWayId": "INTEGER",
    "UserId": "INTEGER",
    "Datetime": "TEXT",
    "Type": "TEXT",
    "Value": "TEXT",
    "ImagePath": "TEXT",
    "remark": "TEXT",
    "inputType": "TEXT",
    "imageByteArray": "TEXT",
    "image": "TEXT",
    "isSaved": "TEXT",
    "ProjectId": "INTEGER",
  };

  DamageReportModel({
    required this.id,
    required this.damage,
    required this.omsId,
    required this.amsid,
    required this.rmsid,
    required this.gateWayId,
    required this.userId,
    required this.datetime,
    required this.type,
    required this.value,
    required this.imagePath,
    required this.remark,
    required this.inputType,
    required this.imageByteArray,
    this.image,
    this.isSaved,
    this.projectId,
  });

  final int? id;
  String? damage;
  int? omsId;
  int? amsid;
  int? rmsid;
  int? gateWayId;
  final int? userId;
  final DateTime? datetime;
  final String? type;
  String? value;
  String? imagePath;
  final String? remark;
  final String? inputType;
  Uint8List? imageByteArray;
  XFile? image;
  String? isSaved;
  int? projectId;

  DamageReportModel copyWith({
    int? id,
    String? damage,
    int? omsId,
    int? amsid,
    int? rmsid,
    int? gateWayId,
    int? userId,
    DateTime? datetime,
    String? type,
    String? value,
    String? imagePath,
    String? remark,
    String? inputType,
    Uint8List? imageByteArray,
    XFile? image,
    String? isSaved,
    int? projectId,
  }) {
    return DamageReportModel(
      id: id ?? this.id,
      damage: damage ?? this.damage,
      omsId: omsId ?? this.omsId,
      amsid: amsid ?? this.amsid,
      rmsid: rmsid ?? this.rmsid,
      gateWayId: gateWayId ?? this.gateWayId,
      userId: userId ?? this.userId,
      datetime: datetime ?? this.datetime,
      type: type ?? this.type,
      value: value ?? this.value,
      imagePath: imagePath ?? this.imagePath,
      remark: remark ?? this.remark,
      inputType: inputType ?? this.inputType,
      imageByteArray: imageByteArray ?? this.imageByteArray,
      image: image,
      isSaved: isSaved ?? this.isSaved,
      projectId: projectId ?? this.projectId,
    );
  }

  factory DamageReportModel.fromJson(Map<String, dynamic> json) {
    return DamageReportModel(
      id: json["Id"],
      damage: json["Damage"],
      omsId: json["OmsId"],
      amsid: json["Amsid"],
      rmsid: json["Rmsid"],
      gateWayId: json["GateWayId"],
      userId: json["UserId"],
      datetime: DateTime.tryParse(json["Datetime"] ?? ""),
      type: json["Type"],
      value: json["Value"],
      imagePath: json["ImagePath"],
      remark: json["remark"],
      inputType: json["inputType"],
      imageByteArray:
          json['imageByteArray'] != null && json['imageByteArray'] != ''
          ? base64.decode(json['imageByteArray'])
          : null,
      image: json["image"],
      isSaved: json["isSaved"],
      projectId: json["ProjectId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Damage": damage,
    "OmsId": omsId,
    "Amsid": amsid,
    "Rmsid": rmsid,
    "GateWayId": gateWayId,
    "UserId": userId,
    "Datetime": datetime?.toIso8601String(),
    "Type": type,
    "Value": value,
    "ImagePath": imagePath,
    "remark": remark,
    "inputType": inputType,
    "imageByteArray": imageByteArray != null
        ? base64.encode(imageByteArray!)
        : null,
    "image": image,
    "isSaved": isSaved,
    "ProjectId": projectId,
  };
}
