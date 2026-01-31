// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineListMasterModel.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineReportModel.dart';
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

Future<List<RoutineListMasterModel>?> getRoutineNodes({
  String? search = '',
  String? area = 'all',
  String? distributory = 'all',
  int? routineStatus = 3,
  int? dateSort = 0,
  String? startDate = '1900-01-01',
  String? endDate = '1900-01-01',
  int? nextSchedule = 0,
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
        routinePrefix,
        'routineNodeList?search=$search&areaId=$area&distributoryId=$distributory&routineStatus=$routineStatus&dateSort=$dateSort&StartDate=$startDate&EndDate=$endDate&NextSchedule=$nextSchedule&deviceType=$source&index=$index&limit=$limit&projectId=$projectId',
      ),
      options: Options(method: 'GET'),
    );
    debugPrint("${response.realUri}");
    if (response.statusCode == 200) {
      List<RoutineListMasterModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(RoutineListMasterModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
  }
}

Future<List<RoutineReportModel>> getRoutineReport({
  required int deviceId,
  required int projectId,
}) async {
  try {
    var response = await dio.request(
      GetHttpRequest(routinePrefix, 'routineReport/$projectId/$deviceId'),
      options: Options(method: 'GET', headers: headers),
    );
    print(response.realUri);

    if (response.statusCode == 200) {
      List<RoutineReportModel> result = [];
      response.data['data']['Response'].forEach((v) {
        result.add(RoutineReportModel.fromJson(v));
      });
      return result;
    } else {
      throw Exception('Failed to load API');
    }
  } catch (e) {
    throw Exception('Failed to load API');
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
      GetHttpRequest(routineImagePrefix, '$projectId/$deviceType/$deviceId'),
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

Future<bool> uploadRoutineReport(dynamic payload) async {
  try {
    var response = await dio.request(
      GetHttpRequest(routinePrefix, 'savereoutinereport'),

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
