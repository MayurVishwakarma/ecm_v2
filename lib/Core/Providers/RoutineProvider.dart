// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineListMasterModel.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineReportModel.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineStatusModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Repositories/Auth-Repositories.dart';
import 'package:ecm_v2/Core/Repositories/Routine-Repositories.dart';
import 'package:ecm_v2/Utils/Functions/ImageCommpress.dart';
import 'package:ecm_v2/Utils/Functions/locationProcessHelper.dart';
import 'package:ecm_v2/Utils/Functions/translate_helper.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class RoutineProvider extends ChangeNotifier {
  List<RoutineListMasterModel>? _routineList;
  RoutineListMasterModel? _selectedNode;
  int _index = 0;
  final int _limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  String? _source;
  bool _isLoad = false;
  // bool _isEdit = false;
  String? _workedBy;
  String? _approvedBy;
  List<RoutineStatusList>? _routineStatusList = [];
  List<RoutineStatusList>? _nextScheduleList = [];
  RoutineStatusList? _selectedStatus;
  RoutineStatusList? _selectedSchedule;
  List<RoutineReportModel>? _routineReport;
  Set<String>? _routineProcess;

  List<RoutineListMasterModel>? get routineList => _routineList;
  RoutineListMasterModel? get selectedNode => _selectedNode;
  int get index => _index;
  int get limit => _limit;
  bool get hasNextPage => _hasNextPage;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  bool get isLoadMoreRunning => _isLoadMoreRunning;
  bool get isLoad => _isLoad;
  String? get source => _source;
  // bool get isEdit => _isEdit;
  String? get workedBy => _workedBy;
  String? get approvedBy => _approvedBy;
  List<RoutineStatusList>? get routineStatusList => _routineStatusList;
  List<RoutineStatusList>? get nextScheduleList => _nextScheduleList;
  RoutineStatusList? get selectedStatus => _selectedStatus;
  RoutineStatusList? get selecltedSchedule => _selectedSchedule;
  List<RoutineReportModel>? get routineReport => _routineReport;
  Set<String>? get routineProcess => _routineProcess;

  List<String> _originalDescriptions = [];
  List<String> _originalSubProcess = [];

  void updateSource(String? res) {
    _source = res;
    notifyListeners();
  }

  /*void updateIsEdit(bool res) {
    _isEdit = res;
    notifyListeners();
  }
*/
  void updateLoad(bool value) {
    _isLoad = value;
    notifyListeners();
  }

  void updateIndex(int index) {
    _index = index;
    notifyListeners();
  }

  void updateLoadMore(bool value) {
    _isLoadMoreRunning = value;
    notifyListeners();
  }

  void updateFirstLoad(bool value) {
    _isFirstLoadRunning = value;
    notifyListeners();
  }

  void updateHasNextPage(bool value) {
    _hasNextPage = value;
    notifyListeners();
  }

  void updateRoutineList(
    List<RoutineListMasterModel>? nodeList, {
    bool isadd = false,
  }) {
    if (isadd && nodeList != null) {
      _routineList?.addAll(nodeList);
    } else {
      _routineList = nodeList;
    }
    notifyListeners();
  }

  void updateRoutineStatusList(List<RoutineStatusList>? res) {
    _routineStatusList = res;
    notifyListeners();
  }

  void updateNextScheduleList(List<RoutineStatusList>? res) {
    _nextScheduleList = res;
    notifyListeners();
  }

  void updateSelectedStatus(RoutineStatusList? res) {
    _selectedStatus = res;
    notifyListeners();
  }

  void updateSelectedSchedule(RoutineStatusList? res) {
    _selectedSchedule = res;
    notifyListeners();
  }

  void updateSelectedNode(RoutineListMasterModel? res) {
    _selectedNode = res;
    notifyListeners();
  }

  void updateRoutineReport(List<RoutineReportModel>? res) {
    _routineReport = res;
    _routineProcess = res
        ?.map((e) => e.processType ?? '')
        .toSet()
        .where((e) => e.isNotEmpty)
        .toSet();
    notifyListeners();
  }

  Future<void> getRouineList({
    int? projectId,
    String? search,
    String? source,
    String? area,
    int? routineStatus,
    int? dateSort = 0,
    int? nextSchedule,
    String? startDate = '1900-01-01',
    String? endDate = '1900-01-01',
    String? distributory,
    int index = 0,
    int limit = 10,
  }) async {
    try {
      var result = await getRoutineNodes(
        search: search ?? '',
        projectId: projectId,
        source: source,
        area: area,
        nextSchedule: nextSchedule,
        routineStatus: routineStatus,
        startDate: startDate,
        endDate: endDate,
        dateSort: dateSort,
        distributory: distributory ?? 'all',
        index: index,
        limit: limit,
      );
      bool isadd = index != 0;
      updateRoutineList(result, isadd: isadd);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getReport({
    required int? projectId,
    required int? deviceId,
    String? langCode,
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      Future.microtask(() => updateRoutineReport([]));
      var result = await getRoutineReport(
        deviceId: deviceId!,
        projectId: projectId!,
      );
      _originalDescriptions = result.map((e) => e.description ?? '').toList();
      _originalSubProcess = result.map((e) => e.processType ?? '').toList();
      if (langCode != 'en' || langCode != null) {
        result = await Future.wait(
          result.map((e) async {
            e.description = await TranslationHelper.translate(
              e.description ?? '',
              langCode!,
            );
            e.processType = await TranslationHelper.translate(
              e.processType ?? '',
              langCode,
            );
            return e;
          }),
        );
      }

      updateRoutineReport(result);
      if (result.first.workedBy != null) {
        await getProjectUserDetailsByUserId(result.first.workedBy, projectId);
      }
      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception(e);
    }
  }

  Future<void> getProjectUserDetailsByUserId(
    int? userId,
    int? projectId, {
    bool isWork = true,
  }) async {
    try {
      var projectUserDetails = await fetchProjectUserDetails(
        userId: userId,
        projectId: projectId,
      );
      isWork
          ? setWorkedBy(projectUserDetails.firstname)
          : setApprovedBy(projectUserDetails.firstname);
    } catch (e) {
      //print("Error fetching project user details: $e");
    }
  }

  Future<bool> insertRoutineReport(
    BuildContext context,
    List<RoutineReportModel> imageList,
    String? remark,
  ) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      int countflag = 0;
      int uploadflag = 0;

      var checkListId = imageList.map((e) => e.id).toList().join(",");
      var valueData = imageList.map((e) => e.value ?? '').toList().join(",");
      int deviceId = getDeviceIdBySource(source!);
      var projectUser = ap.projectUserDetails?.userid;

      // --- Validation: Check missing text fields ---
      final missingText = imageList.any(
        (item) =>
            (item.value == null || item.value!.isEmpty) &&
            item.inputType != "image" &&
            item.inputType != "pdf" &&
            (item.inputType?.isNotEmpty ?? false),
      );

      // --- Validation: Count uploaded images/pdfs ---
      final uploadedImages = imageList
          .where(
            (e) =>
                (e.inputType == "image" || e.inputType == "pdf") &&
                e.imageByteArray != null,
          )
          .toList();

      int approveStatus = 0;

      // --- Business logic ---
      if (missingText) {
        await _showMessageDialog(
          context,
          "Partially done is not allow in this process",
        );
        return false;
      } else if (uploadedImages.length < 3) {
        await _showMessageDialog(context, "Minimum 3 Images are required");
        return false;
      } else {
        approveStatus = 2; // Fully filled
      }
      // ---- Upload images/pdfs ----
      await Future.wait(
        imageList
            .where(
              (element) =>
                  (element.processType?.toLowerCase() == 'image' ||
                      element.processType?.toLowerCase() == 'pdf') &&
                  element.image != null,
            )
            .map((element) async {
              String? imagePathValue = await uploadImageAndGetPath(
                element.image!.path,
                _source!.toUpperCase(),
                getDeviceIdBySource(_source!),
                projectId,
              );

              if (imagePathValue != null && imagePathValue.isNotEmpty) {
                element.value = imagePathValue;
                uploadflag++;
              }
              countflag++;
            }),
      );

      // ---- Prepare request payload ----
      var data = json.encode({
        "Checklistid": checkListId,
        "deviceId": deviceId,
        "userid": projectUser,
        "values": valueData,
        "remark": remark,
        "routineStatus": approveStatus.toString(), // dynamic status
        "projectId": projectId,
      });

      // ---- Final check ----
      if (countflag == uploadflag) {
        var result = await uploadRoutineReport(data);
        return result;
      } else {
        return false;
      }
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  /*Future<bool> insertRoutineReport(
    BuildContext context,
    List<RoutineReportModel> imageList,
    String? remark,
  ) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(
        imageList
            .where(
              (element) =>
                  (element.processType?.toLowerCase() == 'image' ||
                      element.processType?.toLowerCase() == 'pdf') &&
                  element.image != null,
            )
            .map((element) async {
              String? imagePathValue = await uploadImageAndGetPath(
                element.image!.path,
                _source!.toUpperCase(),
                getDeviceIdBySource(_source!),
                projectId,
              );
              if (imagePathValue!.isNotEmpty) {
                element.value = imagePathValue;
                uploadflag++;
              }
              countflag++;
            }),
      );

      var checkListId = imageList.map((e) => e.id).toList().join(",");
      var valueData = imageList.map((e) => e.value ?? '').toList().join(",");
      int deviceId = getDeviceIdBySource(source!);
      var projectUser = ap.projectUserDetails?.userid;

      // --- Validation: Check text and image/pdf ---
      final missingText = imageList.any(
        (item) =>
            (item.value == null || item.value!.isEmpty) &&
            item.inputType != "image" &&
            item.inputType != "pdf" &&
            item.inputType!.isNotEmpty,
      );

      final images = imageList
          .where(
            (e) =>
                (e.inputType == "image" || e.inputType == "pdf") &&
                e.imageByteArray != null,
          )
          .toList();

      int approveStatus = 0;

      /*if (!isPartialProcess) {
        if (missingText) {
          approveStatus = 1; // Partial filled
        } else if (images.length < 3) {
          await _showMessageDialog(context, "Minimum 3 Images are required");
          return false;
        } else {
          approveStatus = 2; // Fully filled
        }
      } else {
        approveStatus = 1; // Allow partial for dry/auto/wet
      }*/

      var data = json.encode({
        "Checklistid": checkListId,
        "deviceId": deviceId,
        "userid": projectUser,
        "values": valueData,
        "remark": remark,
        "routineStatus": "2",
        "projectId": projectId,
      });

      if (countflag == uploadflag) {
        var result = await uploadRoutineReport(data);
        return result;
      } else {
        return false;
      }
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }
*/
  /// Simple reusable dialog
  Future<void> _showMessageDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Message"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void setWorkedBy(String? workedBy) {
    _workedBy = workedBy;
    notifyListeners();
  }

  void setApprovedBy(String? approvedBy) {
    _approvedBy = approvedBy;
    notifyListeners();
  }

  String getNodeName(String source, dynamic item) {
    try {
      switch (source) {
        case 'AMS':
          return item.amsNo!;
        case 'OMS':
          return item.chakNo!;
        case 'RMS':
          return item.rmsNo!;
        case 'LORA':
          return item.gatewayName!;
        default:
          return '';
      }
    } catch (e) {
      return '';
    }
  }

  int getDeviceIdBySource(String? source) {
    try {
      switch (source) {
        case 'OMS':
          return _selectedNode?.omsId ?? 0;
        case 'AMS':
          return _selectedNode?.omsId ?? 0;
        case 'RMS':
          return _selectedNode?.omsId ?? 0;
        case 'LORA':
          return _selectedNode?.omsId ?? 0;
        default:
          return 0;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return 0;
    }
  }

  Widget getRoutineStatus(int status, DateTime? schedule) {
    try {
      DateTime now = DateTime.now();

      // Common styling for all bars
      BoxDecoration baseBox(Color color) => BoxDecoration(
        color: color,
        border: Border.all(color: ColorManager.darkElm, width: 1),
        borderRadius: BorderRadius.circular(5),
      );

      // 🛠 function to return status text
      String getStatusText() {
        if (schedule == null) return "Pending";

        if (schedule.isBefore(now) && status == 2) {
          return "Already Due";
        } else if (schedule.isAfter(now) && status == 2) {
          return "Done";
        } else if (status == 1) {
          return "Partially Done";
        } else {
          return "Pending";
        }
      }

      // 🛠 function to return status color
      Color getStatusColor() {
        if (schedule == null) return Colors.transparent;

        if (schedule.isBefore(now) && status == 2) {
          return Colors.red;
        } else if (schedule.isAfter(now) && status == 2) {
          return Colors.green;
        } else if (status == 1) {
          return Colors.orange.shade600;
        } else {
          return Colors.transparent;
        }
      }

      // 🛠 common UI box builder
      Widget buildBox(Color color, String text) {
        return Container(
          width: 150,
          height: 50,
          decoration: baseBox(color),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                // color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      return buildBox(getStatusColor(), getStatusText().tr());
    } catch (ex) {
      return Container(
        width: 120,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: ColorManager.darkElm, width: 0.8),
        ),
        child: const Center(
          child: Text(
            "Error",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }

  String getDateFormated(DateTime? res) {
    try {
      if (res == null) return '';
      final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.format(res.add(Duration(hours: 5, minutes: 30)));
    } catch (e) {
      throw Exception('Failed to format date: $e');
    }
  }

  String getShortDateFormated(DateTime? res) {
    try {
      if (res == null) return '';
      final formatter = DateFormat('dd-MMM-yyyy');
      return formatter.format(res.add(Duration(hours: 5, minutes: 30)));
    } catch (e) {
      throw Exception('Failed to format date: $e');
    }
  }

  Future<void> pickImage(
    ImageSource media,
    RoutineReportModel imageItem,
    BuildContext context,
  ) async {
    try {
      final picker = ImagePicker();
      final imgPicker = await picker.pickImage(source: media, imageQuality: 30);
      if (imgPicker == null) {
        return;
      }

      final byteData = await imgPicker.readAsBytes();
      final watermarkText = await getCurrentLocationImage();

      final watermarkedBytes = await compute(
        imageProcessingIsolate,
        ImageProcessingInput(byteData, watermarkText),
      );

      final tempDir = await getTemporaryDirectory();
      final watermarkedFile = File('${tempDir.path}/${imgPicker.name}');
      await watermarkedFile.writeAsBytes(watermarkedBytes);

      final externalDir = await getExternalStorageDirectory();
      final fileName = basename(watermarkedFile.path);
      await imgPicker.saveTo('${externalDir!.path}/$fileName');

      // update checklist item with image
      updateChecklistItem(
        imageItem,
        watermarkedBytes,
        XFile(watermarkedFile.path),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image Selected Successfully.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to Load Image'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void deleteImage(RoutineReportModel model) {
    model.image = null;
    model.imageByteArray = null;
    model.value = null;
    notifyListeners();
  }

  void updateChecklistItem(
    RoutineReportModel item,
    Uint8List bytes,
    XFile file,
  ) {
    item.imageByteArray = bytes;
    item.image = file;
    item.value = "Image Uploaded";
    notifyListeners();
  }

  Future<void> getRoutineStatusList() async {
    final status = [
      RoutineStatusList(3, "ALL STATUS"),
      RoutineStatusList(0, "PENDING"),
      RoutineStatusList(2, "COMPLETELY DONE"),
    ];
    final nextSchedule = [
      RoutineStatusList(0, "ALL SCHEDULE"),
      RoutineStatusList(1, "ALREADY DUE"),
      RoutineStatusList(7, "WITHIN NEXT WEEK"),
      RoutineStatusList(15, "IN NEXT 15 DAYS"),
      RoutineStatusList(25, "IN NEXT 25 DAYS"),
    ];

    updateRoutineStatusList(status);
    updateNextScheduleList(nextSchedule);
  }

  Future<void> toggleTranslation(String langCode) async {
    if (langCode != 'en') {
      if (_routineReport != null) {
        _routineReport = await Future.wait(
          _routineReport!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.description = await TranslationHelper.translate(
              _originalDescriptions[i], // ✅ Always from original list
              langCode,
            );
            e.processType = await TranslationHelper.translate(
              _originalSubProcess[i], // ✅ Always from original list
              langCode,
            );
            return e;
          }),
        );
        updateRoutineReport(_routineReport);
      }
    } else {
      if (_originalDescriptions.isNotEmpty &&
          _originalSubProcess.isNotEmpty &&
          _routineReport != null) {
        _routineReport = await Future.wait(
          _routineReport!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.description = _originalDescriptions[i];
            e.processType = _originalSubProcess[i];
            return e;
          }),
        );
        updateRoutineReport(_routineReport);
      }
    }

    notifyListeners();
  }
}
