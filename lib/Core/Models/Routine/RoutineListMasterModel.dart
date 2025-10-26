class RoutineListMasterModel {
  RoutineListMasterModel({
    required this.omsId,
    required this.chakNo,
    required this.areaName,
    required this.description,
    required this.villageName,
    required this.khasarano,
    required this.firstname,
    required this.workedOn,
    required this.routineStatus,
    required this.nextScheduleDate,
  });

  final int? omsId;
  final String? chakNo;
  final String? areaName;
  final String? description;
  final String? villageName;
  final String? khasarano;
  final String? firstname;
  final DateTime? workedOn;
  final int? routineStatus;
  final DateTime? nextScheduleDate;

  RoutineListMasterModel copyWith({
    int? omsId,
    String? chakNo,
    String? areaName,
    String? description,
    String? villageName,
    String? khasarano,
    String? firstname,
    DateTime? workedOn,
    int? routineStatus,
    DateTime? nextScheduleDate,
  }) {
    return RoutineListMasterModel(
      omsId: omsId ?? this.omsId,
      chakNo: chakNo ?? this.chakNo,
      areaName: areaName ?? this.areaName,
      description: description ?? this.description,
      villageName: villageName ?? this.villageName,
      khasarano: khasarano ?? this.khasarano,
      firstname: firstname ?? this.firstname,
      workedOn: workedOn ?? this.workedOn,
      routineStatus: routineStatus ?? this.routineStatus,
      nextScheduleDate: nextScheduleDate ?? this.nextScheduleDate,
    );
  }

  factory RoutineListMasterModel.fromJson(Map<String, dynamic> json) {
    return RoutineListMasterModel(
      omsId: json["OmsId"],
      chakNo: json["ChakNo"],
      areaName: json["AreaName"],
      description: json["Description"],
      villageName: json["villageName"],
      khasarano: json["Khasarano"],
      firstname: json["firstname"],
      workedOn: DateTime.tryParse(json["WorkedOn"] ?? ""),
      routineStatus: json["RoutineStatus"],
      nextScheduleDate: DateTime.tryParse(json["NextScheduleDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "OmsId": omsId,
    "ChakNo": chakNo,
    "AreaName": areaName,
    "Description": description,
    "villageName": villageName,
    "Khasarano": khasarano,
    "firstname": firstname,
    "WorkedOn": workedOn?.toIso8601String(),
    "RoutineStatus": routineStatus,
    "NextScheduleDate": nextScheduleDate?.toIso8601String(),
  };
}
