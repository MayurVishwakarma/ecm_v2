import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class RoutineReportModel {
  RoutineReportModel({
    required this.id,
    required this.description,
    required this.inputType,
    required this.processType,
    required this.routineTestType,
    required this.value,
    required this.workedBy,
    required this.workedOn,
    required this.routineStatus,
    required this.nextScheduleDate,
    required this.remark,
    required this.imageByteArray,
    this.image,
  });

  int? id;
  String? description;
  String? inputType;
  String? processType;
  String? routineTestType;
  String? value;
  int? workedBy;
  DateTime? workedOn;
  int? routineStatus;
  DateTime? nextScheduleDate;
  String? remark;
  Uint8List? imageByteArray;
  XFile? image;

  RoutineReportModel copyWith({
    int? id,
    String? description,
    String? inputType,
    String? processType,
    String? routineTestType,
    String? value,
    int? workedBy,
    DateTime? workedOn,
    int? routineStatus,
    DateTime? nextScheduleDate,
    String? remark,
    Uint8List? imageByteArray,
    XFile? image,
  }) {
    return RoutineReportModel(
      id: id ?? this.id,
      description: description ?? this.description,
      inputType: inputType ?? this.inputType,
      processType: processType ?? this.processType,
      routineTestType: routineTestType ?? this.routineTestType,
      value: value ?? this.value,
      workedBy: workedBy ?? this.workedBy,
      workedOn: workedOn ?? this.workedOn,
      routineStatus: routineStatus ?? this.routineStatus,
      nextScheduleDate: nextScheduleDate ?? this.nextScheduleDate,
      remark: remark ?? this.remark,
      imageByteArray: imageByteArray ?? this.imageByteArray,
      image: image ?? this.image,
    );
  }

  factory RoutineReportModel.fromJson(Map<String, dynamic> json) {
    return RoutineReportModel(
      id: json["Id"],
      description: json["Description"],
      inputType: json["InputType"],
      processType: json["ProcessType"],
      routineTestType: json["RoutineTestType"],
      value: json["Value"],
      workedBy: json["WorkedBy"],
      workedOn: DateTime.tryParse(json["WorkedOn"] ?? ""),
      routineStatus: json["RoutineStatus"],
      nextScheduleDate: DateTime.tryParse(json["NextScheduleDate"] ?? ""),
      remark: json["Remark"],
      imageByteArray:
          json['imageByteArray'] != null && json['imageByteArray'] != ''
          ? base64.decode(json['imageByteArray'])
          : null,
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Description": description,
    "InputType": inputType,
    "ProcessType": processType,
    "RoutineTestType": routineTestType,
    "Value": value,
    "WorkedBy": workedBy,
    "WorkedOn": workedOn?.toIso8601String(),
    "RoutineStatus": routineStatus,
    "NextScheduleDate": nextScheduleDate?.toIso8601String(),
    "Remark": remark,
    "imageByteArray": imageByteArray != null
        ? base64.encode(imageByteArray!)
        : null,
    "image": image,
  };
}
