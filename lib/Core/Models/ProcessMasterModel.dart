class ProcessMasterModel {
  static const String tableName = "ecm_process";
  static const Map<String, String> schema = {
    "ProcessId": "INTEGER",
    "ProcessName": "TEXT",
    "SubProcessId": "INTEGER",
    "SubProcessName": "TEXT",
    "DeviceType": "TEXT",
    "ProjectId": "INTEGER",
  };

  ProcessMasterModel({
    required this.processId,
    required this.processName,
    required this.subProcessId,
    required this.subProcessName,
    required this.deviceType,
    this.projectId,
  });

  final int? processId;
  final String? processName;
  final int? subProcessId;
  final String? subProcessName;
  String? deviceType;
  int? projectId;

  ProcessMasterModel copyWith({
    int? processId,
    String? processName,
    int? subProcessId,
    String? subProcessName,
    String? deviceType,
    int? projectId,
  }) {
    return ProcessMasterModel(
      processId: processId ?? this.processId,
      processName: processName ?? this.processName,
      subProcessId: subProcessId ?? this.subProcessId,
      subProcessName: subProcessName ?? this.subProcessName,
      deviceType: deviceType ?? this.deviceType,
      projectId: projectId ?? this.projectId,
    );
  }

  factory ProcessMasterModel.fromJson(Map<String, dynamic> json) {
    return ProcessMasterModel(
      processId: json["ProcessId"],
      processName: json["ProcessName"],
      subProcessId: json["SubProcessId"],
      subProcessName: json["SubProcessName"],
      deviceType: json["DeviceType"],
      projectId: json["ProjectId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "ProcessId": processId,
    "ProcessName": processName,
    "SubProcessId": subProcessId,
    "SubProcessName": subProcessName,
    "DeviceType": deviceType,
    "ProjectId": projectId,
  };
}
