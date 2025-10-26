class DamageStatusCountModel {
  DamageStatusCountModel({
    required this.damageId,
    required this.cnt,
    required this.damage,
    required this.type,
    required this.total,
    required this.electrical,
    required this.mechanical,
    required this.totalOms,
    required this.totalElectOms,
    required this.totalMechOms,
    required this.totalAms,
    required this.totalElectAms,
    required this.totalMechAms,
    required this.totalGateway,
    required this.totalEleCtAms,
    required this.totalMeChAms,
    required this.totalRms,
    required this.totalElectRms,
    required this.totalMechRms,
  });

  final int? damageId;
  final int? cnt;
  final String? damage;
  final String? type;
  final int? total;
  final int? electrical;
  final int? mechanical;
  final int? totalOms;
  final int? totalElectOms;
  final int? totalMechOms;
  final int? totalAms;
  final int? totalElectAms;
  final int? totalMechAms;
  final int? totalGateway;
  final int? totalEleCtAms;
  final int? totalMeChAms;
  final int? totalRms;
  final int? totalElectRms;
  final int? totalMechRms;

  DamageStatusCountModel copyWith({
    int? damageId,
    int? cnt,
    String? damage,
    String? type,
    int? total,
    int? electrical,
    int? mechanical,
    int? totalOms,
    int? totalElectOms,
    int? totalMechOms,
    int? totalAms,
    int? totalElectAms,
    int? totalMechAms,
    int? totalGateway,
    int? totalEleCtAms,
    int? totalMeChAms,
    int? totalRms,
    int? totalElectRms,
    int? totalMechRms,
  }) {
    return DamageStatusCountModel(
      damageId: damageId ?? this.damageId,
      cnt: cnt ?? this.cnt,
      damage: damage ?? this.damage,
      type: type ?? this.type,
      total: total ?? this.total,
      electrical: electrical ?? this.electrical,
      mechanical: mechanical ?? this.mechanical,
      totalOms: totalOms ?? this.totalOms,
      totalElectOms: totalElectOms ?? this.totalElectOms,
      totalMechOms: totalMechOms ?? this.totalMechOms,
      totalAms: totalAms ?? this.totalAms,
      totalElectAms: totalElectAms ?? this.totalElectAms,
      totalMechAms: totalMechAms ?? this.totalMechAms,
      totalGateway: totalGateway ?? this.totalGateway,
      totalEleCtAms: totalEleCtAms ?? this.totalEleCtAms,
      totalMeChAms: totalMeChAms ?? this.totalMeChAms,
      totalRms: totalRms ?? this.totalRms,
      totalElectRms: totalElectRms ?? this.totalElectRms,
      totalMechRms: totalMechRms ?? this.totalMechRms,
    );
  }

  factory DamageStatusCountModel.fromJson(Map<String, dynamic> json) {
    return DamageStatusCountModel(
      damageId: json["DamageId"],
      cnt: json["CNT"],
      damage: json["Damage"],
      type: json["Type"],
      total: json["Total"],
      electrical: json["Electrical"],
      mechanical: json["Mechanical"],
      totalOms: json["TotalOMS"],
      totalElectOms: json["TotalElectOMS"],
      totalMechOms: json["TotalMechOMS"],
      totalAms: json["TotalAMS"],
      totalElectAms: json["TotalElectAMS"],
      totalMechAms: json["TotalMechAMS"],
      totalGateway: json["TotalGateway"],
      totalEleCtAms: json["TotalEleCtAMS"],
      totalMeChAms: json["TotalMeChAMS"],
      totalRms: json["TotalRMS"],
      totalElectRms: json["TotalElectRMS"],
      totalMechRms: json["TotalMechRMS"],
    );
  }

  Map<String, dynamic> toJson() => {
    "DamageId": damageId,
    "CNT": cnt,
    "Damage": damage,
    "Type": type,
    "Total": total,
    "Electrical": electrical,
    "Mechanical": mechanical,
    "TotalOMS": totalOms,
    "TotalElectOMS": totalElectOms,
    "TotalMechOMS": totalMechOms,
    "TotalAMS": totalAms,
    "TotalElectAMS": totalElectAms,
    "TotalMechAMS": totalMechAms,
    "TotalGateway": totalGateway,
    "TotalEleCtAMS": totalEleCtAms,
    "TotalMeChAMS": totalMeChAms,
    "TotalRMS": totalRms,
    "TotalElectRMS": totalElectRms,
    "TotalMechRMS": totalMechRms,
  };
}
