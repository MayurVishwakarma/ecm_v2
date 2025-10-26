class ProjectDetailsModel {
  ProjectDetailsModel({
    required this.id,
    required this.projectName,
    required this.state,
    required this.totalArea,
    required this.description,
    required this.project,
    required this.clientLogo,
    required this.contractorLogo,
    required this.userType,
    required this.hostIp,
    required this.userName,
    required this.password,
    required this.ecString,
    required this.drString,
    required this.rcString,
    required this.allowDeviceTypeString,
  });

  final int? id;
  final String? projectName;
  final String? state;
  final int? totalArea;
  final String? description;
  final String? project;
  final dynamic clientLogo;
  final dynamic contractorLogo;
  final String? userType;
  final String? hostIp;
  final String? userName;
  final String? password;
  final String? ecString;
  final String? drString;
  final String? rcString;
  final String? allowDeviceTypeString;

  ProjectDetailsModel copyWith({
    int? id,
    String? projectName,
    String? state,
    int? totalArea,
    String? description,
    String? project,
    dynamic clientLogo,
    dynamic contractorLogo,
    String? userType,
    String? hostIp,
    String? userName,
    String? password,
    String? ecString,
    String? drString,
    String? rcString,
    String? allowDeviceTypeString,
  }) {
    return ProjectDetailsModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      state: state ?? this.state,
      totalArea: totalArea ?? this.totalArea,
      description: description ?? this.description,
      project: project ?? this.project,
      clientLogo: clientLogo ?? this.clientLogo,
      contractorLogo: contractorLogo ?? this.contractorLogo,
      userType: userType ?? this.userType,
      hostIp: hostIp ?? this.hostIp,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      ecString: ecString ?? this.ecString,
      drString: drString ?? this.drString,
      rcString: rcString ?? this.rcString,
      allowDeviceTypeString:
          allowDeviceTypeString ?? this.allowDeviceTypeString,
    );
  }

  factory ProjectDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProjectDetailsModel(
      id: json["id"],
      projectName: json["ProjectName"],
      state: json["State"],
      totalArea: json["TotalArea"],
      description: json["Description"],
      project: json["project"],
      clientLogo: json["clientLogo"],
      contractorLogo: json["contractorLogo"],
      userType: json["User_Type"],
      hostIp: json["HostIp"],
      userName: json["userName"],
      password: json["Password"],
      ecString: json["ECString"],
      drString: json["DRString"],
      rcString: json["RCString"],
      allowDeviceTypeString: json["AllowDeviceTypeString"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "ProjectName": projectName,
    "State": state,
    "TotalArea": totalArea,
    "Description": description,
    "project": project,
    "clientLogo": clientLogo,
    "contractorLogo": contractorLogo,
    "User_Type": userType,
    "HostIp": hostIp,
    "userName": userName,
    "Password": password,
    "ECString": ecString,
    "DRString": drString,
    "RCString": rcString,
    "AllowDeviceTypeString": allowDeviceTypeString,
  };
}
