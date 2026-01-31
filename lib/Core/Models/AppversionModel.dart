// ignore_for_file: file_names

class AppVersionModel {
  AppVersionModel({
    required this.id,
    required this.device,
    required this.version,
    required this.updatedOn,
  });

  final int? id;
  final String? device;
  final String? version;
  final DateTime? updatedOn;

  AppVersionModel copyWith({
    int? id,
    String? device,
    String? version,
    DateTime? updatedOn,
  }) {
    return AppVersionModel(
      id: id ?? this.id,
      device: device ?? this.device,
      version: version ?? this.version,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      id: json["id"],
      device: json["device"],
      version: json["version"],
      updatedOn: DateTime.tryParse(json["updatedOn"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "device": device,
    "version": version,
    "updatedOn": updatedOn?.toIso8601String(),
  };
}
