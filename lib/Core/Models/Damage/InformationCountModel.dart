class InformationCountModel {
  InformationCountModel({
    required this.infoId,
    required this.cnt,
    required this.infoDescription,
    required this.type,
    required this.total,
    required this.totalDevice,
  });

  final int? infoId;
  final int? cnt;
  final String? infoDescription;
  final String? type;
  final int? total;
  final int? totalDevice;

  InformationCountModel copyWith({
    int? infoId,
    int? cnt,
    String? infoDescription,
    String? type,
    int? total,
    int? totalDevice,
  }) {
    return InformationCountModel(
      infoId: infoId ?? this.infoId,
      cnt: cnt ?? this.cnt,
      infoDescription: infoDescription ?? this.infoDescription,
      type: type ?? this.type,
      total: total ?? this.total,
      totalDevice: totalDevice ?? this.totalDevice,
    );
  }

  factory InformationCountModel.fromJson(Map<String, dynamic> json) {
    return InformationCountModel(
      infoId: json["InfoId"],
      cnt: json["CNT"],
      infoDescription: json["InfoDescription"],
      type: json["Type"],
      total: json["Total"],
      totalDevice: json["TotalDevice"],
    );
  }

  Map<String, dynamic> toJson() => {
    "InfoId": infoId,
    "CNT": cnt,
    "InfoDescription": infoDescription,
    "Type": type,
    "Total": total,
    "TotalDevice": totalDevice,
  };
}
