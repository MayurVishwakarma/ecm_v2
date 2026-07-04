// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

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
import 'package:path/path.dart' as path;

final Dio dio = Dio();
var headers = {'Content-Type': 'application/json'};

String _apiErrorMessage(dynamic data, int? statusCode) {
  String? readMapMessage(dynamic value) {
    if (value is! Map) return null;

    for (final key in const ['Message', 'message', 'Error', 'error']) {
      final message = value[key]?.toString().trim();
      if (message != null && message.isNotEmpty) return message;
    }

    return readMapMessage(value['data']);
  }

  final mapMessage = readMapMessage(data);
  if (mapMessage != null) return mapMessage;

  if (data is String && data.trim().isNotEmpty) {
    return data.trim();
  }

  return statusCode == null
      ? 'Unable to load report. Please try again.'
      : 'Unable to load report. Server returned $statusCode.';
}

String _cleanExceptionMessage(Object error) {
  return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
}

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

    debugPrint(response.realUri.toString());

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
    debugPrint(response.realUri.toString());
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
    final url = GetHttpRequest(
      ecmApiPrefix,
      'ecmdetailreport/$projectId/$processId/$source/$deviceId',
    );

    var response = await dio.request(
      url,
      options: Options(
        method: 'GET',
        headers: headers,
        validateStatus: (status) => status != null && status < 600,
      ),
    );
    debugPrint(url);

    if (response.statusCode == 200) {
      List<EcmReportMasterModel> result = [];
      final responseData = response.data;
      final data = responseData is Map ? responseData['data'] : null;
      final items = data is Map ? data['Response'] ?? [] : [];
      items.forEach((v) {
        result.add(EcmReportMasterModel.fromJson(v));
      });
      return result;
    } else {
      final message = _apiErrorMessage(response.data, response.statusCode);
      debugPrint(
        "ECM report detail failed [${response.statusCode}] $url: ${response.data}",
      );
      throw Exception(message);
    }
  } on DioException catch (e) {
    final message = _apiErrorMessage(e.response?.data, e.response?.statusCode);
    debugPrint("Error in getECMReportByProcessId: $message");
    throw Exception(message);
  } catch (e) {
    final message = _cleanExceptionMessage(e);
    debugPrint("Error in getECMReportByProcessId: $message");
    throw Exception(message);
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
    debugPrint(response.realUri.toString());
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
    final file = File(filePath);
    if (!await file.exists()) {
      debugPrint('ECM file upload skipped. File not found: $filePath');
      return null;
    }

    final fileName = path.basename(file.path);
    final uploadUrl = GetHttpRequest(
      ecmImagePrefix,
      '$projectId/$deviceType/$deviceId',
    );

    final formData = FormData.fromMap({
      'ecmFile': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dio.post(
      uploadUrl,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        validateStatus: (status) => status != null && status < 600,
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      // Response is a plain text path string like: /SEE...
      return response.data.toString().trim();
    } else {
      debugPrint(
        'ECM file upload failed [${response.statusCode}] $uploadUrl: ${response.data}',
      );
      return null;
    }
  } on DioException catch (e) {
    debugPrint(
      'ECM file upload request failed [${e.response?.statusCode}]: ${e.response?.data ?? e.message}',
    );
    return null;
  } catch (e) {
    debugPrint('ECM file upload error: $e');
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
    debugPrint(jsonDecode(e.toString()));
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
    debugPrint(jsonDecode(e.toString()));
    throw Exception("Failed to change ECM report status");
  }
}
