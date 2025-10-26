class DistibutoryMasterModel {
  DistibutoryMasterModel({
    required this.id,
    required this.areaId,
    required this.pipeLineName,
    required this.description,
    required this.deviceType,
  });

  final int? id;
  final int? areaId;
  final String? pipeLineName;
  final String? description;
  final String? deviceType;

  DistibutoryMasterModel copyWith({
    int? id,
    int? areaId,
    String? pipeLineName,
    String? description,
    String? deviceType,
  }) {
    return DistibutoryMasterModel(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      pipeLineName: pipeLineName ?? this.pipeLineName,
      description: description ?? this.description,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  factory DistibutoryMasterModel.fromJson(Map<String, dynamic> json) {
    return DistibutoryMasterModel(
      id: json["Id"],
      areaId: json["areaId"],
      pipeLineName: json["PipeLineName"],
      description: json["Description"],
      deviceType: json["DeviceType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "Id": id,
    "areaId": areaId,
    "PipeLineName": pipeLineName,
    "Description": description,
    "DeviceType": deviceType,
  };
}
