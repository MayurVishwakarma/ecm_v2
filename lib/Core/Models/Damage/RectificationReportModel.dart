import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class RectificationReportModel {
  RectificationReportModel({
    required this.id,
    required this.rectification,
    required this.deviceId,
    required this.userId,
    required this.datetime,
    required this.type,
    required this.value,
    required this.imagePath,
    required this.inputType,
    required this.remark,
    required this.imageByteArray,
    this.image,
  });

  final int? id;
  String? rectification;
  final int? deviceId;
  final int? userId;
  final DateTime? datetime;
  String? type;
  String? value;
  String? imagePath;
  String? inputType;
  String? remark;
  Uint8List? imageByteArray;
  XFile? image;

  RectificationReportModel copyWith({
    int? id,
    String? rectification,
    int? deviceId,
    int? userId,
    DateTime? datetime,
    String? type,
    String? value,
    String? imagePath,
    String? inputType,
    String? remark,
    Uint8List? imageByteArray,
    XFile? image,
  }) {
    return RectificationReportModel(
      id: id ?? this.id,
      rectification: rectification ?? this.rectification,
      deviceId: deviceId ?? this.deviceId,
      userId: userId ?? this.userId,
      datetime: datetime ?? this.datetime,
      type: type ?? this.type,
      value: value ?? this.value,
      imagePath: imagePath ?? this.imagePath,
      inputType: inputType ?? this.inputType,
      remark: remark ?? this.remark,
      imageByteArray: imageByteArray ?? this.imageByteArray,
      image: image,
    );
  }

  factory RectificationReportModel.fromJson(Map<String, dynamic> json) {
    return RectificationReportModel(
      id: json["Id"],
      rectification: json["Rectification"],
      deviceId: json["deviceId"],
      userId: json["UserId"],
      datetime: DateTime.tryParse(json["Datetime"] ?? ""),
      type: json["Type"],
      value: json["Value"],
      imagePath: json["imagePath"],
      inputType: json["inputType"],
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
    "Rectification": rectification,
    "deviceId": deviceId,
    "UserId": userId,
    "Datetime": datetime?.toIso8601String(),
    "Type": type,
    "Value": value,
    "imagePath": imagePath,
    "inputType": inputType,
    "remark": remark,
    "imageByteArray": imageByteArray != null
        ? base64.encode(imageByteArray!)
        : null,
    "image": image,
  };
}
