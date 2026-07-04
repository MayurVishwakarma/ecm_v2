import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class EcmReportMasterModel {
  static const String tableName = "ecm_report";
  static const Map<String, String> schema = {
    "DeviceId": "INTEGER",
    "DeviceType": "TEXT",
    "CheckListId": "INTEGER",
    "SubProcessId": "INTEGER",
    "ProcessId": "INTEGER",
    "Description": "TEXT",
    "SeqNo": "INTEGER",
    "InputType": "TEXT",
    "InputText": "TEXT",
    "SubProcessName": "TEXT",
    "ProcessName": "TEXT",
    "IsMultiValue": "TEXT",
    "Comment": "TEXT",
    "ParameterName": "TEXT",
    "IsBullet": "TEXT",
    "IsBulletHeader": "TEXT",
    "SubChakQty": "INTEGER",
    "ApprovedStatus": "INTEGER",
    "WorkedBy": "INTEGER",
    "WorkedOn": "TEXT",
    "Remark": "TEXT",
    "ApprovedBy": "INTEGER",
    "ApprovedOn": "TEXT",
    "ApprovalRemark": "TEXT",
    "TempDt": "TEXT",
    "Value": "TEXT",
    "image": "BLOB",
    "imageByteArray": "TEXT",
    "imagePath": "TEXT",
    "isSaved": "TEXT",
    "ProjectId": "INTEGER",
  };

  EcmReportMasterModel({
    required this.deviceId,
    required this.deviceType,
    required this.checkListId,
    required this.subProcessId,
    required this.processId,
    required this.description,
    required this.seqNo,
    required this.inputType,
    required this.inputText,
    required this.subProcessName,
    required this.processName,
    required this.isMultiValue,
    required this.comment,
    required this.parameterName,
    required this.isBullet,
    required this.isBulletHeader,
    required this.subChakQty,
    required this.approvedStatus,
    required this.workedBy,
    required this.workedOn,
    required this.remark,
    required this.approvedBy,
    required this.approvedOn,
    required this.approvalRemark,
    required this.tempDt,
    required this.value,
    required this.imageByteArray,
    this.image,
    this.issaved,
    this.projectId,
  });

  int? deviceId;
  String? deviceType;
  int? checkListId;
  int? subProcessId;
  int? processId;
  String? description;
  int? seqNo;
  String? inputType;
  dynamic inputText;
  String? subProcessName;
  String? processName;
  dynamic isMultiValue;
  dynamic comment;
  dynamic parameterName;
  dynamic isBullet;
  dynamic isBulletHeader;
  dynamic subChakQty;
  dynamic approvedStatus;
  dynamic workedBy;
  DateTime? workedOn;
  String? remark;
  dynamic approvedBy;
  DateTime? approvedOn;
  String? approvalRemark;
  DateTime? tempDt;
  String? value;
  Uint8List? imageByteArray;
  XFile? image;
  String? issaved;
  int? projectId;

  EcmReportMasterModel copyWith({
    int? deviceId,
    String? deviceType,
    int? checkListId,
    int? subProcessId,
    int? processId,
    String? description,
    int? seqNo,
    String? inputType,
    dynamic inputText,
    String? subProcessName,
    String? processName,
    dynamic isMultiValue,
    dynamic comment,
    dynamic parameterName,
    dynamic isBullet,
    dynamic isBulletHeader,
    dynamic subChakQty,
    dynamic approvedStatus,
    dynamic workedBy,
    DateTime? workedOn,
    String? remark,
    dynamic approvedBy,
    DateTime? approvedOn,
    String? approvalRemark,
    DateTime? tempDt,
    String? value,
    Uint8List? imageByteArray,
    XFile? image,
    String? issaved,
    int? projectId,
  }) {
    return EcmReportMasterModel(
      deviceId: deviceId ?? this.deviceId,
      deviceType: deviceType ?? this.deviceType,
      checkListId: checkListId ?? this.checkListId,
      subProcessId: subProcessId ?? this.subProcessId,
      processId: processId ?? this.processId,
      description: description ?? this.description,
      seqNo: seqNo ?? this.seqNo,
      inputType: inputType ?? this.inputType,
      inputText: inputText ?? this.inputText,
      subProcessName: subProcessName ?? this.subProcessName,
      processName: processName ?? this.processName,
      isMultiValue: isMultiValue ?? this.isMultiValue,
      comment: comment ?? this.comment,
      parameterName: parameterName ?? this.parameterName,
      isBullet: isBullet ?? this.isBullet,
      isBulletHeader: isBulletHeader ?? this.isBulletHeader,
      subChakQty: subChakQty ?? this.subChakQty,
      approvedStatus: approvedStatus ?? this.approvedStatus,
      workedBy: workedBy ?? this.workedBy,
      workedOn: workedOn ?? this.workedOn,
      remark: remark ?? this.remark,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedOn: approvedOn ?? this.approvedOn,
      approvalRemark: approvalRemark ?? this.approvalRemark,
      tempDt: tempDt ?? this.tempDt,
      value: value ?? this.value,
      imageByteArray: imageByteArray ?? this.imageByteArray,
      image: image ?? this.image,
      issaved: issaved ?? this.issaved,
      projectId: projectId ?? this.projectId,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static String? _parseString(dynamic value) {
    return value?.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    return DateTime.tryParse(text);
  }

  static Uint8List? _parseBytes(dynamic value) {
    if (value == null || value == '') return null;
    if (value is Uint8List) return value;

    try {
      return base64.decode(value.toString());
    } catch (_) {
      return null;
    }
  }

  factory EcmReportMasterModel.fromJson(Map<String, dynamic> json) {
    return EcmReportMasterModel(
      deviceId: _parseInt(json["DeviceId"]),
      deviceType: _parseString(json["DeviceType"]),
      checkListId: _parseInt(json["CheckListId"]),
      subProcessId: _parseInt(json["SubProcessId"]),
      processId: _parseInt(json["ProcessId"]),
      description: _parseString(json["Description"]),
      seqNo: _parseInt(json["SeqNo"]),
      inputType: _parseString(json["InputType"]),
      inputText: json["InputText"],
      subProcessName: _parseString(json["SubProcessName"]),
      processName: _parseString(json["ProcessName"]),
      isMultiValue: json["IsMultiValue"],
      comment: json["Comment"],
      parameterName: json["ParameterName"],
      isBullet: json["IsBullet"],
      isBulletHeader: json["IsBulletHeader"],
      subChakQty: json["SubChakQty"],
      approvedStatus: json["ApprovedStatus"],
      workedBy: _parseInt(json["WorkedBy"]),
      workedOn: _parseDate(json["WorkedOn"]),
      remark: _parseString(json["Remark"]),
      approvedBy: _parseInt(json["ApprovedBy"]),
      approvedOn: _parseDate(json["ApprovedOn"]),
      approvalRemark: _parseString(json["ApprovalRemark"]),
      tempDt: _parseDate(json["TempDt"]),
      value: _parseString(json["Value"]),
      imageByteArray: _parseBytes(json['imageByteArray']),
      image: json["image"] is XFile ? json["image"] : null,
      issaved: _parseString(json["issaved"]),
      projectId: _parseInt(json["ProjectId"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "DeviceId": deviceId,
    "DeviceType": deviceType,
    "CheckListId": checkListId,
    "SubProcessId": subProcessId,
    "ProcessId": processId,
    "Description": description,
    "SeqNo": seqNo,
    "InputType": inputType,
    "InputText": inputText,
    "SubProcessName": subProcessName,
    "ProcessName": processName,
    "IsMultiValue": isMultiValue,
    "Comment": comment,
    "ParameterName": parameterName,
    "IsBullet": isBullet,
    "IsBulletHeader": isBulletHeader,
    "SubChakQty": subChakQty,
    "ApprovedStatus": approvedStatus,
    "WorkedBy": workedBy,
    "WorkedOn": workedOn?.toIso8601String(),
    "Remark": remark,
    "ApprovedBy": approvedBy,
    "ApprovedOn": approvedOn?.toIso8601String(),
    "ApprovalRemark": approvalRemark,
    "TempDt": tempDt?.toIso8601String(),
    "Value": value,
    "imageByteArray": imageByteArray != null
        ? base64.encode(imageByteArray!)
        : null,
    "image": image,
    "issaved": issaved,
    "ProjectId": projectId,
  };
}
