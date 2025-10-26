class AreaMasterModel {
  AreaMasterModel({
    required this.areaId,
    required this.projectId,
    required this.areaCoordinates,
    required this.areaName,
  });

  final int? areaId;
  final int? projectId;
  final String? areaCoordinates;
  final String? areaName;

  AreaMasterModel copyWith({
    int? areaId,
    int? projectId,
    String? areaCoordinates,
    String? areaName,
  }) {
    return AreaMasterModel(
      areaId: areaId ?? this.areaId,
      projectId: projectId ?? this.projectId,
      areaCoordinates: areaCoordinates ?? this.areaCoordinates,
      areaName: areaName ?? this.areaName,
    );
  }

  factory AreaMasterModel.fromJson(Map<String, dynamic> json) {
    return AreaMasterModel(
      areaId: json["AreaId"],
      projectId: json["ProjectId"],
      areaCoordinates: json["AreaCoordinates"],
      areaName: json["AreaName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "AreaId": areaId,
    "ProjectId": projectId,
    "AreaCoordinates": areaCoordinates,
    "AreaName": areaName,
  };
}
