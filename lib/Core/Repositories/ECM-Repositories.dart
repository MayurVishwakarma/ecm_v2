// ignore_for_file: avoid_print

import 'dart:convert';

// import '../../../Core/Models/AreaMasterModel.dart';
// import '../../../Core/Models/DistibutoryMasterModel.dart';
import '../../../Core/Models/ECMReportModel.dart';
import '../../../Core/Models/ECMStatusCountModel.dart';
import 'package:dio/dio.dart';
import '../../../Core/Models/EcmNodeMasterModel.dart';
import '../../../Core/Models/ProcessMasterModel.dart';
import '../../../Core/Models/ReportHistoryModel.dart';
import '../../../Utils/Functions/Url_constants.dart';
import 'package:flutter/material.dart';

final Dio dio = Dio();
var headers = {'Content-Type': 'application/json'};
/*Future<List<AreaMasterModel>> getAreaMaster(int? projectId) async {
  try {
    var response = await dio.get(
      GetHttpRequest(projectPrefix, 'area/$projectId'),
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final areaList = (response.data['data']['Response'] as List)
          .map((e) => AreaMasterModel.fromJson(e))
          .toList();

      // ✅ Add "All Area" option at 0th position
      areaList.insert(
        0,
        AreaMasterModel(
          areaId: -1, // or 0 if your API handles it better
          areaName: "All Area",
          projectId: null,
          areaCoordinates: '',
        ),
      );

      return areaList;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<DistibutoryMasterModel>> getDistibutoryMaster(
  String? areaId,
  int? projectId,
) async {
  try {
    var response = await dio.get(
      GetHttpRequest(projectPrefix, 'distributory/$projectId/$areaId'),
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final distList = (response.data['data']['Response'] as List)
          .map((e) => DistibutoryMasterModel.fromJson(e))
          .toList();

      // ✅ Add "All Area" option at 0th position
      distList.insert(
        0,
        DistibutoryMasterModel(
          id: -1, // or 0 if your API handles it better
          description: "All Distributory",
          areaId: null,
          pipeLineName: '',
          deviceType: '',
        ),
      );

      return distList;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}
*/
Future<List<ProcessMasterModel>> getProcessid({
  required String? source,
  required int? projectId,
  bool isListView = false,
}) async {
  try {
    var response = await dio.request(
      GetHttpRequest(ecmApiPrefix, 'processlist/$projectId/$source'),
      options: Options(method: 'GET', headers: headers),
    );

    if (response.statusCode == 200) {
      List<ProcessMasterModel> result = [];
      if (isListView) {
        result = [
          ProcessMasterModel(
            processId: 0,
            processName: 'ALL PROCESS',
            subProcessId: null,
            subProcessName: '',
            deviceType: source,
          ),
        ];
      }

      response.data['data']['Response'].forEach((v) {
        result.add(ProcessMasterModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<ECMStatusCountMasterModel> getECMReportStatusCount(
  String? area,
  String? distibutory,
  String? process,
  String? subProcess,
  int? projectId,
  String? deviceType,
) async {
  try {
    if (area == '-1' || area == '0') {
      area = 'all';
    }
    if (distibutory == '-1' || distibutory == '0') {
      distibutory = 'all';
    }
    if (process == '-1' || process == '0') {
      process = 'all';
    }
    if (subProcess == '-1' || subProcess == '0') {
      subProcess = 'all';
    }
    var response = await dio.request(
      GetHttpRequest(
        ecmApiPrefix,
        'ecmreportcount?search&areaId=${area ?? "all"}&distributoryId=${distibutory ?? "all"}&processId=${process ?? "all"}&subProcessId=${subProcess ?? "all"}&deviceType=${deviceType ?? "OMS"}&projectId=${projectId ?? 0}',
      ),
      options: Options(method: 'GET', headers: headers),
    );

    print(response.realUri);

    if (response.statusCode == 200) {
      return ECMStatusCountMasterModel.fromJson(
        response.data['data']['Response'][0],
      );
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<EcmNodeListMasterModel>> getECMNodeList({
  String? search = '',
  String? area = 'all',
  String? distributory = 'all',
  String? process = 'all',
  String? subProcess = 'all',
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
    if (process == '-1' || process == '0') {
      process = 'all';
    }
    if (subProcess == '-1' || subProcess == '0') {
      subProcess = 'all';
    }
    final response = await dio.request(
      GetHttpRequest(
        ecmApiPrefix,
        'ecmreportlist?search=$search&areaId=$area&distributoryId=$distributory&processId=$process&subProcessId=$subProcess&deviceType=$source&index=$index&limit=$limit&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    print(response.realUri);
    if (response.statusCode == 200) {
      List<EcmNodeListMasterModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(
          EcmNodeListMasterModel.fromJson(v).copyWith(projectId: projectId),
        );
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<EcmReportMasterModel>> getECMReportByProcessId({
  required int processId,
  required int deviceId,
  required String source,
  required int projectId,
}) async {
  try {
    var response = await dio.request(
      GetHttpRequest(
        ecmApiPrefix,
        'ecmdetailreport/$projectId/$processId/$source/$deviceId',
      ),
      options: Options(method: 'GET', headers: headers),
    );
    print(response.realUri);

    if (response.statusCode == 200) {
      List<EcmReportMasterModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(EcmReportMasterModel.fromJson(v));
      });
      return result;
    } else {
      print("Error: ${response.statusCode} - ${response.statusMessage}");
      throw Exception('Failed to load API');
    }
  } catch (e) {
    print("Error in getECMReportByProcessId: $e");
    throw Exception('Failed to load API');
  }
}

Future<List<ReportHistoryModel>> getEcmReportHistory({
  required int? deviceId,
  String? startDate = '',
  String? endDate = '',
  required int? index,
  int? limit = 20,
  required String? source,
  required int? projectId,
}) async {
  try {
    debugPrint(
      GetHttpRequest(
        ecmApiPrefix,
        'ecmreporthistory/$projectId/$deviceId/$startDate/$endDate/$index/$limit/$source',
      ),
    );
    final response = await dio.request(
      GetHttpRequest(
        ecmApiPrefix,
        'ecmreporthistory/$projectId/$deviceId/$startDate/$endDate/$index/$limit/$source',
      ),
      options: Options(method: 'GET'),
    );
    print(response.realUri);
    if (response.statusCode == 200) {
      List<ReportHistoryModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(ReportHistoryModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception("Failed to load API : $e");
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
      GetHttpRequest(ecmImagePrefix, '$projectId/$deviceType/$deviceId'),
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

Future<bool> uploadECMReport(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(ecmApiPrefix, 'saveecmreport'),
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
    }
  } catch (e) {
    print(jsonDecode(e.toString()));
    throw Exception("Failed to upload ECM report");
  }
}

Future<bool> changeApproveStatus(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(ecmApiPrefix, 'changeapprovestatus'),
      options: Options(method: 'PUT', headers: headers),
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
    }
  } catch (e) {
    print(jsonDecode(e.toString()));
    throw Exception("Failed to change ECM report status");
  }
}
