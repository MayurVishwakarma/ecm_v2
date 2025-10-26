import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class InfoReportModel {
  InfoReportModel({
    required this.id,
    required this.infoDescription,
    required this.deviceId,
    required this.reportedBy,
    required this.reportedOn,
    required this.type,
    required this.value,
    required this.remark,
    required this.imageByteArray,
    this.image,
  });

  final int? id;
  String? infoDescription;
  final int? deviceId;
  final int? reportedBy;
  final DateTime? reportedOn;
  final String? type;
  String? value;
  final String? remark;
  Uint8List? imageByteArray;
  XFile? image;

  InfoReportModel copyWith({
    int? id,
    String? infoDescription,
    int? deviceId,
    int? reportedBy,
    DateTime? reportedOn,
    String? type,
    String? value,
    String? remark,
    Uint8List? imageByteArray,
    XFile? image,
  }) {
    return InfoReportModel(
      id: id ?? this.id,
      infoDescription: infoDescription ?? this.infoDescription,
      deviceId: deviceId ?? this.deviceId,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedOn: reportedOn ?? this.reportedOn,
      type: type ?? this.type,
      value: value ?? this.value,
      remark: remark ?? this.remark,
      imageByteArray: imageByteArray ?? this.imageByteArray,
      image: image,
    );
  }

  factory InfoReportModel.fromJson(Map<String, dynamic> json) {
    return InfoReportModel(
      id: json["Id"],
      infoDescription: json["InfoDescription"],
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
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "InfoDescription": infoDescription,
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
  };
}
