// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class MaterialReportModel {
  static const String tableName = "material_report";
  static const Map<String, String> schema = {
    "Id": "INTEGER",
    "Rectification": "TEXT",
    "DeviceId": "INTEGER",
    "ReportedBy": "INTEGER",
    "ReportedOn": "TEXT",
    "Type": "TEXT",
    "Value": "TEXT",
    "remark": "TEXT",
    "imageByteArray": "TEXT",
    "image": "TEXT",
    "isSaved": "TEXT",
    "ProjectId": "INTEGER",
  };

  MaterialReportModel({
    required this.id,
    required this.rectification,
    required this.deviceId,
    required this.reportedBy,
    required this.reportedOn,
    required this.type,
    required this.value,
    required this.remark,
    required this.imageByteArray,
    this.image,
    this.isSaved,
    this.projectId,
  });

  final int? id;
  String? rectification;
  int? deviceId;
  final int? reportedBy;
  final DateTime? reportedOn;
  final String? type;
  String? value;
  final String? remark;
  Uint8List? imageByteArray;
  XFile? image;
  String? isSaved;
  int? projectId;

  MaterialReportModel copyWith({
    int? id,
    String? rectification,
    int? deviceId,
    int? reportedBy,
    DateTime? reportedOn,
    String? type,
    String? value,
    String? remark,
    Uint8List? imageByteArray,
    XFile? image,
    String? isSaved,
    int? projectId,
  }) {
    return MaterialReportModel(
      id: id ?? this.id,
      rectification: rectification ?? this.rectification,
      deviceId: deviceId ?? this.deviceId,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedOn: reportedOn ?? this.reportedOn,
      type: type ?? this.type,
      value: value ?? this.value,
      remark: remark ?? this.remark,
      imageByteArray: imageByteArray ?? this.imageByteArray,
      image: image,
      isSaved: isSaved ?? this.isSaved,
      projectId: projectId ?? this.projectId,
    );
  }

  factory MaterialReportModel.fromJson(Map<String, dynamic> json) {
    return MaterialReportModel(
      id: json["Id"],
      rectification: json["Rectification"],
      deviceId: json["DeviceId"],
      reportedBy: json["ReportedBy"],
      reportedOn: DateTime.tryParse(json["ReportedOn"] ?? ""),
      type: json["Type"],
      value: json["Value"],
      remark: json["remark"],
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
    "Rectification": rectification,
    "DeviceId": deviceId,
    "ReportedBy": reportedBy,
    "ReportedOn": reportedOn?.toIso8601String(),
    "Type": type,
    "Value": value,
    "remark": remark,
    "imageByteArray": imageByteArray != null
        ? base64.encode(imageByteArray!)
        : null,
    "image": image,
    "isSaved": isSaved,
    "ProjectId": projectId,
  };
}
