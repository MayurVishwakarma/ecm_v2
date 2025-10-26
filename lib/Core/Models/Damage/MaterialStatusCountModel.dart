class MaterialStatusCountModel {
  MaterialStatusCountModel({
    required this.rectificationId,
    required this.cnt,
    required this.rectification,
    required this.type,
    required this.total,
    required this.electrical,
    required this.tubing,
    required this.mechanical,
    required this.totalDevice,
    required this.totalElectDevice,
    required this.totalTubDevice,
    required this.totalMechDevice,
  });

  final int? rectificationId;
  final int? cnt;
  final String? rectification;
  final String? type;
  final int? total;
  final int? electrical;
  final int? tubing;
  final int? mechanical;
  final int? totalDevice;
  final int? totalElectDevice;
  final int? totalTubDevice;
  final int? totalMechDevice;

  MaterialStatusCountModel copyWith({
    int? rectificationId,
    int? cnt,
    String? rectification,
    String? type,
    int? total,
    int? electrical,
    int? tubing,
    int? mechanical,
    int? totalDevice,
    int? totalElectDevice,
    int? totalTubDevice,
    int? totalMechDevice,
  }) {
    return MaterialStatusCountModel(
      rectificationId: rectificationId ?? this.rectificationId,
      cnt: cnt ?? this.cnt,
      rectification: rectification ?? this.rectification,
      type: type ?? this.type,
      total: total ?? this.total,
      electrical: electrical ?? this.electrical,
      tubing: tubing ?? this.tubing,
      mechanical: mechanical ?? this.mechanical,
      totalDevice: totalDevice ?? this.totalDevice,
      totalElectDevice: totalElectDevice ?? this.totalElectDevice,
      totalTubDevice: totalTubDevice ?? this.totalTubDevice,
      totalMechDevice: totalMechDevice ?? this.totalMechDevice,
    );
  }

  factory MaterialStatusCountModel.fromJson(Map<String, dynamic> json) {
    return MaterialStatusCountModel(
      rectificationId: json["RectificationId"],
      cnt: json["CNT"],
      rectification: json["Rectification"],
      type: json["Type"],
      total: json["Total"],
      electrical: json["Electrical"],
      tubing: json["Tubing"],
      mechanical: json["Mechanical"],
      totalDevice: json["TotalDevice"],
      totalElectDevice: json["TotalElectDevice"],
      totalTubDevice: json["TotalTubDevice"],
      totalMechDevice: json["TotalMechDevice"],
    );
  }

  Map<String, dynamic> toJson() => {
    "RectificationId": rectificationId,
    "CNT": cnt,
    "Rectification": rectification,
    "Type": type,
    "Total": total,
    "Electrical": electrical,
    "Tubing": tubing,
    "Mechanical": mechanical,
    "TotalDevice": totalDevice,
    "TotalElectDevice": totalElectDevice,
    "TotalTubDevice": totalTubDevice,
    "TotalMechDevice": totalMechDevice,
  };
}
