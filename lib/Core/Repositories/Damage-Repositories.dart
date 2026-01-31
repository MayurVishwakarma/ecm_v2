// ignore_for_file: file_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageHistoryModel.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageNodeMasterModel.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageReportModel.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageStatusCountModel.dart';
import 'package:ecm_v2/Core/Models/Damage/InfoReportMasterModel.dart';
import 'package:ecm_v2/Core/Models/Damage/InformationCountModel.dart';
import 'package:ecm_v2/Core/Models/Damage/InfromationHistoryModel.dart';
import 'package:ecm_v2/Core/Models/Damage/InfromationListModel.dart';
import 'package:ecm_v2/Core/Models/Damage/MaterialHistoryModel.dart';
import 'package:ecm_v2/Core/Models/Damage/MaterialReportModel.dart';
import 'package:ecm_v2/Core/Models/Damage/MaterialStatusCountModel.dart';
import 'package:ecm_v2/Core/Models/Damage/MaterialStatusListModel.dart';
import 'package:ecm_v2/Core/Models/Damage/RectificationNodeModel.dart';
import 'package:ecm_v2/Core/Models/Damage/RectificationReportModel.dart';
import 'package:ecm_v2/Utils/Functions/Url_constants.dart';
import 'package:flutter/material.dart';

final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 15),
    contentType: Headers.jsonContentType,
  ),
);

var headers = {'Content-Type': 'application/json'};

Future<List<DamageNodeModel>?> getDamageStatusList({
  String? search = '',
  String? area = 'all',
  String? distributory = 'all',
  required int? index,
  int? limit = 20,
  required String? source,
  required int? projectId,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'damageReportList?search=$search&areaId=$area&distributoryId=$distributory&deviceType=$source&index=$index&limit=$limit&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<DamageNodeModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(DamageNodeModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<DamageReportModel>> getDamageform({
  int? deviceId,
  String? deviceType,
  int? projectId,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'damageDetailReport/$projectId/$deviceType/$deviceId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");

    if (response.statusCode == 200) {
      List<DamageReportModel> result = <DamageReportModel>[];
      var json = response.data;
      json['data']['Response'].forEach(
        (v) => result.add(DamageReportModel.fromJson(v)),
      );
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } catch (e) {
    throw Exception("API Consumed Failed : $e");
  }
}

Future<List<MaterialReportModel>> getMatrialform({
  int? deviceId,
  String? deviceType,
  int? projectId,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'materialConsumption/$projectId/$deviceType/$deviceId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<MaterialReportModel> result = <MaterialReportModel>[];
      var json = response.data;
      json['data']['Response'].forEach(
        (v) => result.add(MaterialReportModel.fromJson(v)),
      );
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } catch (e) {
    throw Exception("API Consumed Failed : $e");
  }
}

Future<List<InfoReportModel>> getInfomationform({
  int? deviceId,
  String? deviceType,
  int? projectId,
  int? type,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'informationReport/$projectId/$deviceType/$deviceId/$type',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<InfoReportModel> result = <InfoReportModel>[];
      var json = response.data;
      json['data']['Response'].forEach(
        (v) => result.add(InfoReportModel.fromJson(v)),
      );
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } catch (e) {
    throw Exception("API Consumed Failed : $e");
  }
}

Future<String?> uploadImageAndGetPath(
  String filePath,
  String deviceType,
  int deviceId,
  int projectId,
) async {
  try {
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      'ecmFile': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    final response = await dio.post(
      GetHttpRequest(damageImagePrefix, '$projectId/$deviceType/$deviceId'),
      data: formData,
    );

    if (response.statusCode == 200 && response.data != null) {
      // Response is a plain text path string like: /SEE...
      return response.data.toString().trim();
    } else {
      print(
        '❌ Upload failed with status: ${response.statusCode} - ${response.statusMessage}',
      );
      return null;
    }
  } catch (e) {
    print('❌ Error uploading file: $e');
    return null;
  }
}

Future<bool> uploadDamageReport(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(damageApiPrefix, 'savedamagereport'),

      options: Options(method: 'POST', headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      var json = response.data;
      if (json["Status"] == "Ok") {
        return true;
      } else {
        throw Exception();
      }
    } else {
      return false;
      // throw Exception("API Consumed Failed");
    }
  } catch (e) {
    print(jsonDecode(e.toString()));
    // Handle any errors that occur during the request
    throw Exception("Failed to upload ECM report");
  }
}

Future<bool> uploadMaterialReport(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(damageApiPrefix, 'savematerialconsumptionreport'),

      options: Options(method: 'POST', headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      var json = response.data;
      if (json["Status"] == "Ok") {
        return true;
      } else {
        throw Exception();
      }
    } else {
      return false;
      // throw Exception("API Consumed Failed");
    }
  } catch (e) {
    print(jsonDecode(e.toString()));
    // Handle any errors that occur during the request
    throw Exception("Failed to upload ECM report");
  }
}

Future<bool> uploadInfromationReport(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(damageApiPrefix, 'saveinformationreport'),
      options: Options(method: 'POST', headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      var json = response.data;
      if (json["Status"] == "Ok") {
        return true;
      } else {
        throw Exception();
      }
    } else {
      return false;
      // throw Exception("API Consumed Failed");
    }
  } catch (e) {
    print(jsonDecode(e.toString()));
    // Handle any errors that occur during the request
    throw Exception("Failed to upload ECM report");
  }
}

Future<bool> uploadRectificationReport(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(damageApiPrefix, 'saverectificationreport'),

      options: Options(method: 'POST', headers: headers),
      data: payload,
    );

    if (response.statusCode == 200) {
      var json = response.data;
      if (json["Status"] == "Ok") {
        return true;
      } else {
        throw Exception();
      }
    } else {
      return false;
      // throw Exception("API Consumed Failed");
    }
  } catch (e) {
    print(jsonDecode(e.toString()));
    // Handle any errors that occur during the request
    throw Exception("Failed to upload ECM report");
  }
}

Future<List<DamageNodeModel>?> getDamageSummaryList({
  String? filter = '',
  String? area = 'all',
  String? distributory = 'all',
  required String? source,
  required int? projectId,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'damageSummaryList?damageId=$filter&areaId=$area&distributoryId=$distributory&deviceType=$source&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<DamageNodeModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(DamageNodeModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<DamageStatusCountModel>?> getDamageSummaryCount({
  String? area = 'all',
  String? distributory = 'all',
  required String? source,
  required int? projectId,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'damageSummaryCount/$projectId/$source/$area/$distributory',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<DamageStatusCountModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(DamageStatusCountModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<DamageHistoryModel>> getDamageHistoryReport({
  int? deviceId,
  String? source,
  int? projectId,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'damageHistoryreport?deviceId=$deviceId&startDate=1900-01-01&endDate=1900-01-01&index=0&limit=1500&deviceType=$source&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<DamageHistoryModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(DamageHistoryModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

Future<List<MaterialStatusCountModel>?> getMaterialSummaryCount({
  String? area = 'all',
  String? distributory = 'all',
  required String? source,
  required int? projectId,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'materialConsumptionSummaryCount/$projectId/$area/$distributory/$source',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<MaterialStatusCountModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(MaterialStatusCountModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<MaterialStatusListModel>?> getMaterialSummaryList({
  String? search = '',
  String? filter = '',
  String? area = 'all',
  String? distributory = 'all',
  required String? source,
  required int? projectId,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'materialConsumptionSummaryList?search=$search&areaId=$area&distributoryId=$distributory&deviceType=$source&isFilter=$filter&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<MaterialStatusListModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(MaterialStatusListModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<MaterialHistoryModel>> getMaterialHistoryReport({
  int? deviceId,
  String? source,
  int? projectId,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'materialConsumptionSummaryReport/$projectId/$deviceId/$source',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<MaterialHistoryModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(MaterialHistoryModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

Future<List<InformationCountModel>?> getInformationSummaryCount({
  String? area = 'all',
  String? distributory = 'all',
  required String? source,
  required int? projectId,
  required String? type,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'informationSummaryCount/$projectId/$area/$distributory/$source/$type',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<InformationCountModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(InformationCountModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<InformationListModel>?> getInformationSummaryList({
  String? filter = '',
  String? area = 'all',
  String? distributory = 'all',
  required String? source,
  required int? projectId,
  required String? type,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'informationSummaryList/$projectId/$area/$distributory/$source/$filter/$type',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<InformationListModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(InformationListModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<InformationHistoryModel>> getInformationHistoryReport({
  int? deviceId,
  String? source,
  int? projectId,
  String? type,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'informationSummaryReport/$projectId/$deviceId/$source/$type',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<InformationHistoryModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(InformationHistoryModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } on Exception catch (e) {
    print(e.toString());
    throw Exception("API Consumed Failed");
  }
}

Future<List<RectificationNodeModel>?> getRectificationNodeList({
  String? search = '',
  String? area = 'all',
  String? distributory = 'all',
  required int? index,
  int? limit = 20,
  required String? source,
  required int? projectId,
}) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distributory == '-1' || distributory == '0') {
      distributory = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'rectificationReportList?search=$search&areaId=$area&distributoryId=$distributory&deviceType=$source&index=$index&limit=$limit&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<RectificationNodeModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(RectificationNodeModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<RectificationReportModel>> RectificationReport({
  int? deviceId,
  String? deviceType,
  int? projectId,
}) async {
  try {
    final response = await dio.request(
      GetHttpRequest(
        damageApiPrefix,
        'rectificationDetailReport/$projectId/$deviceType/$deviceId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");

    if (response.statusCode == 200) {
      List<RectificationReportModel> result = <RectificationReportModel>[];
      var json = response.data;
      json['data']['Response'].forEach(
        (v) => result.add(RectificationReportModel.fromJson(v)),
      );
      return result;
    } else {
      throw Exception("API Consumed Failed");
    }
  } catch (e) {
    throw Exception("API Consumed Failed : $e");
  }
}
