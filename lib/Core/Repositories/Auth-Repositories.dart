// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:ecm_v2/Core/Models/AppversionModel.dart';
import 'package:ecm_v2/Core/Models/AreaMasterModel.dart';
import 'package:ecm_v2/Core/Models/DistibutoryMasterModel.dart';
import 'package:ecm_v2/Core/Models/ProjectDetailsModel.dart';
import 'package:ecm_v2/Core/Models/ProjectUserModel.dart';
import 'package:ecm_v2/Core/Models/UserMasterModel.dart';
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
Future<UserMasterModel> userLogin(String? loginId, String? password) async {
  try {
    final response = await dio.post(
      GetHttpRequest(loginPrefix, 'login'),
      data: {'mobileNo': loginId, 'password': password},
    );

    if (response.statusCode == 200 && response.data != null) {
      debugPrint("Login successful: ${response.data}");
      return UserMasterModel.fromJson(response.data['data']['Response'][0]);
    } else {
      throw Exception("Failed with status: ${response.statusCode}");
    }
  } on DioException catch (dioError) {
    print("DioException: ${dioError.message}");
    throw Exception("Network error occurred");
  } catch (e) {
    print("Unexpected error: $e");
    throw Exception("An error occurred while logging in");
  }
}

Future<List<ProjectDetailsModel>> fetchProjectDetails(int? userId) async {
  try {
    print(GetHttpRequest(projectPrefix, '$userId/all'));
    final response = await dio.get(
      GetHttpRequest(loginPrefix, 'projects/$userId/all'),
    );

    if (response.statusCode == 200 && response.data != null) {
      debugPrint("Project details fetched successfully: ${response.data}");
      return (response.data['data']['Response'] as List)
          .map((project) => ProjectDetailsModel.fromJson(project))
          .toList();
    } else {
      throw Exception("Failed to fetch project details");
    }
  } on DioException catch (dioError) {
    print("DioException: ${dioError.message}");
    throw Exception("Network error occurred");
  } catch (e) {
    print("Unexpected error: $e");
    throw Exception("An error occurred while fetching project details");
  }
}

Future<List<AreaMasterModel>> getAreaMaster(int? projectId) async {
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

Future<ProjectUserDetailsModel> fetchProjectUserDetails({
  String? mobileNumber = "0",
  int? userId = 0,
  required int? projectId,
}) async {
  try {
    var response = await dio.request(
      GetHttpRequest(projectPrefix, 'users/$mobileNumber/$userId/$projectId'),
      options: Options(method: 'GET', headers: headers),
    );
    debugPrint(response.realUri.toString());
    if (response.statusCode == 200 && response.data != null) {
      return ProjectUserDetailsModel.fromJson(
        response.data['data']['Response'][0],
      );
    } else {
      throw Exception("Failed to fetch project user details");
    }
  } on DioException catch (dioError) {
    print("DioException: ${dioError.message}");
    throw Exception("Network error occurred");
  } catch (e) {
    print("Unexpected error: $e");
    throw Exception("An error occurred while fetching project user details");
  }
}

Future<AppVersionModel?> getAppVersion(String? device) async {
  try {
    var response = await dio.request(
      GetHttpRequest(loginPrefix, 'version/$device'),
      options: Options(method: 'GET', headers: headers),
    );
    if (response.statusCode == 200) {
      // final json = response.data;
      return AppVersionModel.fromJson(response.data['data']['Response'][0]);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
