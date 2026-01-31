// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, depend_on_referenced_packages, avoid_function_literals_in_foreach_calls, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Database/DBHelper.dart';
import 'package:ecm_v2/Core/Models/ReportHistoryModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Repositories/Auth-Repositories.dart';
import 'package:ecm_v2/Utils/Functions/translate_helper.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecm_v2/Core/Models/ECMReportModel.dart';
import 'package:ecm_v2/Core/Models/ECMStatusCountModel.dart';
import 'package:ecm_v2/Core/Models/EcmNodeMasterModel.dart';
import 'package:ecm_v2/Core/Models/ProcessMasterModel.dart';
import 'package:ecm_v2/Core/Models/ProcessModel.dart';
import 'package:ecm_v2/Core/Repositories/ECM-Repositories.dart';
import 'package:ecm_v2/Utils/Functions/ImageCommpress.dart';
import 'package:ecm_v2/Utils/Functions/locationProcessHelper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' hide context;
import 'package:provider/provider.dart';

class ProjectProvider extends ChangeNotifier {
  ECMStatusCountMasterModel? _ecmStatusCount;
  // List<AreaMasterModel>? _area;
  // AreaMasterModel? _selectedArea;
  String? _source;
  // List<DistibutoryMasterModel>? _distributory;
  // DistibutoryMasterModel? _selectedDistributory;
  List<ProcessMasterModel>? _processList;
  List<ProcessModel>? _processStatusList;
  ProcessMasterModel? _selectedProcess;
  ProcessMasterModel? _selectedReportProcess;
  ProcessMasterModel? _selectedProcessStatus;
  List<EcmNodeListMasterModel>? _nodeList;
  EcmNodeListMasterModel? _selectedNode;
  Set<String>? _subProcessName;
  List<EcmReportMasterModel>? _checklistModel;
  List<ReportHistoryModel>? _ecmReportHistory;
  bool _isLoad = false;
  ECMStatusCountMasterModel? get ecmStatusCount => _ecmStatusCount;
  // List<AreaMasterModel>? get area => _area;
  // AreaMasterModel? get selectedArea => _selectedArea;
  // List<DistibutoryMasterModel>? get distributory => _distributory;
  // DistibutoryMasterModel? get selectedDistributory => _selectedDistributory;
  List<ProcessMasterModel>? get processList => _processList;
  List<ProcessModel>? get processStatusList => _processStatusList;
  ProcessMasterModel? get selectedProcess => _selectedProcess;
  ProcessMasterModel? get selectedReportProcess => _selectedReportProcess;
  ProcessMasterModel? get selectedProcessStatus => _selectedProcessStatus;
  List<ProcessMasterModel>? _subProcessList;
  ProcessMasterModel? _selectedSubProcess;
  List<ProcessMasterModel>? get subProcessList => _subProcessList;
  ProcessMasterModel? get selectedSubProcess => _selectedSubProcess;
  List<EcmNodeListMasterModel>? get nodeList => _nodeList;
  String? get source => _source;
  EcmNodeListMasterModel? get selectedNode => _selectedNode;
  List<EcmReportMasterModel>? get checklistModel => _checklistModel;
  List<ReportHistoryModel>? get ecmReportHistory => _ecmReportHistory;
  Set<String>? get subProcessName => _subProcessName;

  bool get isLoad => _isLoad;
  String? _workedBy;
  String? _approvedBy;
  String? get workedBy => _workedBy;
  String? get approvedBy => _approvedBy;
  int _index = 0;
  final int _limit = 20;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  int get index => _index;
  int get limit => _limit;
  bool get hasNextPage => _hasNextPage;
  bool get isFirstLoadRunning => _isFirstLoadRunning;
  bool get isLoadMoreRunning => _isLoadMoreRunning;

  List<String> _originalDescriptions = [];
  List<String> _originalSubProcess = [];

  void updateSource(String? source) {
    _source = source;
    notifyListeners();
  }

  void updateProcessList(List<ProcessMasterModel>? processList) {
    _processList = processList;
    if (processList != null && processList.isNotEmpty) {
      _selectedProcess ??= processList.first;
      // 🔹 also auto load subprocess for first process
      updateSelectedProcess(_selectedProcess);
    }
    notifyListeners();
  }

  void updateSelectedProcess(ProcessMasterModel? process) {
    _selectedProcess = process;
    _selectedSubProcess = null;

    if (process != null && _processStatusList != null) {
      _subProcessList = _processStatusList
          ?.where((e) => e.processId == process.processId)
          .map(
            (e) => ProcessMasterModel(
              processId: e.processId,
              processName: e.processName,
              subProcessId: int.tryParse(e.processStatusId ?? ""),
              subProcessName: e.processStatusName,
              deviceType: source,
            ),
          )
          .toList();

      // 🔹 auto select first subProcess if available
      if (_subProcessList != null && _subProcessList!.isNotEmpty) {
        _selectedSubProcess = _subProcessList!.first;
      }
    } else {
      _subProcessList = [];
    }

    notifyListeners();
  }

  void updateSelectedReportProcess(ProcessMasterModel? process) {
    _selectedReportProcess = process;
    notifyListeners();
  }

  void updateEcmReportHistory(
    List<ReportHistoryModel>? res, {
    bool isadd = false,
  }) {
    if (isadd && res != null) {
      _ecmReportHistory?.addAll(res);
    } else {
      _ecmReportHistory = res;
    }
    notifyListeners();
  }

  void setWorkedBy(String? workedBy) {
    _workedBy = workedBy;
    notifyListeners();
  }

  void setApprovedBy(String? approvedBy) {
    _approvedBy = approvedBy;
    notifyListeners();
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

  void updateProcessStatusList(List<ProcessModel>? processStatusList) {
    _processStatusList = processStatusList;
    notifyListeners();
  }

  void updateSelectedProcessStatus(ProcessMasterModel? processStatus) {
    _selectedProcessStatus = processStatus;
    notifyListeners();
  }

  void updateChecklistModel(List<EcmReportMasterModel>? checklistModel) {
    _checklistModel = checklistModel;
    _subProcessName = checklistModel
        ?.map((e) => e.subProcessName ?? '')
        .toSet()
        .where((e) => e.isNotEmpty)
        .toSet();
    notifyListeners();
  }

  Future<void> loadProcesses({
    required String? source,
    required int? projectId,
    bool isListView = true,
  }) async {
    var result = await getProcessid(
      source: source,
      projectId: projectId,
      isListView: isListView,
    );

    final uniqueProcessNames = result.map((e) => e.processName).toSet();

    List<ProcessMasterModel> newList = [];
    List<ProcessModel> newStatusList = [];

    for (var name in uniqueProcessNames) {
      final matched = result.firstWhere(
        (element) => element.processName == name,
      );
      final processId = matched.processId;

      // build checklist
      newList.add(
        ProcessMasterModel(
          processId: processId,
          processName: name,
          subProcessId: null,
          subProcessName: '',
          deviceType: source,
          projectId: projectId,
        ),
      );

      // build status list
      if (name!.toLowerCase().contains('dry comm')) {
        newStatusList.addAll([
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: 'all',
            processStatusName: "Pending",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '3',
            processStatusName: "Commented",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '1',
            processStatusName: "Fully Completed",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '2',
            processStatusName: "Fully Completed & Approved",
          ),
        ]);
      } else {
        newStatusList.addAll([
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: 'all',
            processStatusName: "Pending",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '4',
            processStatusName: "Commented",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '1',
            processStatusName: "Partially Completed",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '2',
            processStatusName: "Fully Completed",
          ),
          ProcessModel(
            processId: processId,
            processName: name,
            processStatusId: '3',
            processStatusName: "Fully Completed & Approved",
          ),
        ]);
      }
    }

    updateProcessList(newList);
    updateProcessStatusList(newStatusList);
    insertProcess(newList);

    notifyListeners();
  }

  Future<void> insertProcess(List<ProcessMasterModel> process) async {
    process.forEach((element) async {
      element.deviceType = source;
      await ProcessDB.instance.insertOrUpdate(element);
    });
  }

  void updateEcmStatusCount(ECMStatusCountMasterModel? statusCount) {
    _ecmStatusCount = statusCount;
    notifyListeners();
  }

  void updateNodeList(
    List<EcmNodeListMasterModel>? nodeList, {
    bool isadd = false,
  }) {
    if (isadd && nodeList != null) {
      _nodeList?.addAll(nodeList);
    } else {
      _nodeList = nodeList;
    }
    notifyListeners();
  }

  void updateSelectedNode(EcmNodeListMasterModel? node) {
    _selectedNode = node;
    notifyListeners();
  }

  void updateSelectedSubProcess(ProcessMasterModel? subProcess) {
    _selectedSubProcess = subProcess;
    notifyListeners();
  }

  Future<void> pickImage(
    ImageSource media,
    EcmReportMasterModel imageItem,
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

  void deleteImage(EcmReportMasterModel model) {
    model.image = null;
    model.imageByteArray = null;
    model.value = null;
    notifyListeners();
  }

  void updateChecklistItem(
    EcmReportMasterModel item,
    Uint8List bytes,
    XFile file,
  ) {
    item.imageByteArray = bytes;
    item.image = file;
    item.value = "Image Uploaded";
    notifyListeners();
  }

  Future<void> getEcmStatusCount({
    int? projectId = 0,
    String? source = 'OMS',
    String? area = 'all',
    String? process = 'all',
    String? subProcess = 'all',
    String? distributory = 'all',
  }) async {
    try {
      var result = await getECMReportStatusCount(
        area,
        distributory,
        process,
        subProcess,
        projectId,
        source,
      );
      updateEcmStatusCount(result);
    } catch (e) {
      throw Exception('Failed to fetch ECM status count: $e');
    }
  }

  Future<void> getEcmNodes({
    int? projectId,
    String? search,
    String? source,
    String? area,
    String? process,
    String? subProcess,
    String? distributory,
    int index = 0,
    int limit = 20,
  }) async {
    try {
      var result = await getECMNodeList(
        search: search ?? '',
        projectId: projectId,
        source: source,
        area: area,
        process: process ?? 'all',
        subProcess: subProcess ?? 'all',
        distributory: distributory ?? 'all',
        index: index,
        limit: limit,
      );
      bool isadd = index != 0;
      updateNodeList(result, isadd: isadd);
      addNodes(nodes: result, projectId: projectId!, deviceType: source!);
    } catch (e) {
      throw Exception('Failed to fetch ECM nodes: $e');
    }
  }

  Future<void> getECMReport({
    required int deviceId,
    required int processId,
    required String source,
    required int projectId,
    String? langCode,
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      Future.microtask(() => updateChecklistModel([]));
      var result = await getECMReportByProcessId(
        deviceId: deviceId,
        processId: processId,
        source: source,
        projectId: projectId,
      );
      _originalDescriptions = result.map((e) => e.description ?? '').toList();
      _originalSubProcess = result.map((e) => e.subProcessName ?? '').toList();
      if (langCode != 'en' || langCode != null) {
        result = await Future.wait(
          result.map((e) async {
            e.description = await TranslationHelper.translate(
              e.description ?? '',
              langCode ?? 'en',
            );
            e.subProcessName = await TranslationHelper.translate(
              e.subProcessName ?? '',
              langCode ?? 'en',
            );
            return e;
          }),
        );
      }

      updateChecklistModel(result);
      if (result.first.workedBy != null) {
        await getProjectUserDetailsByUserId(result.first.workedBy, projectId);
      }
      if (result.first.approvedBy != null) {
        await getProjectUserDetailsByUserId(
          result.first.approvedBy,
          projectId,
          isWork: false,
        );
      }

      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
    notifyListeners();
  }

  Future<void> getReportHistory({
    int? projectId,
    int? deviceId,
    String? startDate,
    String? endDate,
    String? source,
    int index = 0,
    int limit = 20,
  }) async {
    try {
      var result = await getEcmReportHistory(
        deviceId: deviceId,
        projectId: projectId,
        source: source,
        startDate: startDate,
        endDate: endDate,
        index: index,
        limit: limit,
      );
      bool isadd = index != 0;
      updateEcmReportHistory(result, isadd: isadd);
    } catch (e) {
      throw Exception('Failed to fetch Report History: $e');
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

  String getNodeName(String source, EcmNodeListMasterModel item) {
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
          return _selectedNode?.amsId ?? 0;
        case 'RMS':
          return _selectedNode?.rmsId ?? 0;
        case 'LORA':
          return _selectedNode?.gateWayId ?? 0;
        default:
          return 0;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return 0;
    }
  }

  bool isEdit(bool isManager, String? processName, int? status) {
    if (isManager) {
      return false;
    } else {
      if (!processName!.toLowerCase().contains('dry comm')) {
        return (status == 3) ? false : true;
      } else {
        return (status == 2) ? false : true;
      }
    }
  }

  String approvedTitle(String? processName, int? approvedStatus) {
    if (selectedReportProcess!.processName!.toLowerCase().contains(
      'dry comm',
    )) {
      return approvedStatus == 3 ? 'Commented' : 'Approved';
    } else {
      return approvedStatus == 4 ? 'Commented' : 'Approved';
    }
  }

  bool isApproved(bool isManager, String? processName, int? status) {
    if (!processName!.toLowerCase().contains('dry com')) {
      return status == 2 && isManager;
    } else {
      return status == 1 && isManager;
    }
  }

  bool isSubmit(bool isManager, String? processName, int? status) {
    if (isManager) {
      return false;
    } else {
      if (!processName!.toLowerCase().contains('dry comm')) {
        return (status == 3) ? false : true;
      } else {
        return (status == 2) ? false : true;
      }
    }
  }

  /*String getprocessstatus(String pro, int proStatus) {
    String imagepath = 'assets/images/pending.png';
    try {
      if (pro.toLowerCase().contains('auto')) {
        if (proStatus == 1) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      } else if (pro.toLowerCase().contains('dry comm')) {
        if (proStatus == 1) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      } else {
        if (proStatus == 1) {
          imagepath = 'assets/images/Partially-2.png';
        } else if (proStatus == 2) {
          imagepath = 'assets/images/Completed.png';
        } else if (proStatus == 3) {
          imagepath = 'assets/images/fullydone.png';
        } else if (proStatus == 4) {
          imagepath = 'assets/images/Commented.png';
        } else {
          imagepath = 'assets/images/notcompletted.png';
        }
      }
    } catch (ex, _) {
      imagepath = 'assets/images/notcompletted.png';
    }
    return imagepath;
  }
*/

  Widget getProcessStatusBar(String pro, int proStatus) {
    try {
      // Common styling for all bars
      BoxDecoration baseBox(Color color) => BoxDecoration(
        color: color,
        border: Border.all(color: ColorManager.darkElm, width: 1),
        borderRadius: BorderRadius.circular(5),
      );

      Widget buildBox(Color color, String text, {bool halfFill = false}) {
        return Container(
          width: 150, // 🔥 increased width
          height: 30, // 🔥 increased height
          decoration: baseBox(color),
          child: halfFill
              ? Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                              color: ColorManager.pureWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: FittedBox(
                        child: Text(
                          text.tr(),
                          style: const TextStyle(
                            fontSize: 10, // 🔥 readable size
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: FittedBox(
                    child: Text(
                      text.tr(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.white, // default text color
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        );
      }

      if (pro.toLowerCase().contains('auto')) {
        if (proStatus == 1) return buildBox(Colors.blue.shade900, "Completed");
        if (proStatus == 2) return buildBox(Colors.green, "Approved");
        if (proStatus == 3) return buildBox(Colors.orange, "Commented");
        return buildBox(Colors.red, "Pending");
      } else if (pro.toLowerCase().contains('dry comm') ||
          pro.toLowerCase().contains('wet comm')) {
        if (proStatus == 1) return buildBox(Colors.blue.shade900, "Completed");
        if (proStatus == 2) return buildBox(Colors.green, "Approved");
        if (proStatus == 3) return buildBox(Colors.orange, "Commented");
        return buildBox(Colors.red, "Pending");
      } else {
        if (proStatus == 1)
          return buildBox(Colors.white, "Partially Done", halfFill: true);
        if (proStatus == 2) return buildBox(Colors.blue.shade900, "Completed");
        if (proStatus == 3) return buildBox(Colors.green, "Approved");
        if (proStatus == 4) return buildBox(Colors.orange, "Commented");
        return buildBox(Colors.red, "Pending");
      }
    } catch (ex) {
      return Container(
        width: 120,
        height: 35,
        decoration: BoxDecoration(
          color: ColorManager.pureWhite,
          border: Border.all(color: ColorManager.darkElm, width: 0.8),
        ),
        child: const Center(
          child: Text(
            "Pending",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }

  String getApprovestatus(String pro, int proStatus) {
    String approveStatus = 'Pending';
    try {
      if (pro.toLowerCase().contains('auto')) {
        if (proStatus == 1) {
          approveStatus = 'Completed';
        } else if (proStatus == 2) {
          approveStatus = 'Approved';
        } else if (proStatus == 3) {
          approveStatus = 'Commented';
        } else {
          approveStatus = 'Pending';
        }
      } else if (pro.toLowerCase().contains('dry comm')) {
        if (proStatus == 1) {
          approveStatus = 'Completed';
        } else if (proStatus == 2) {
          approveStatus = 'Approved';
        } else if (proStatus == 3) {
          approveStatus = 'Commented';
        } else {
          approveStatus = 'Pending';
        }
      } else {
        if (proStatus == 1) {
          approveStatus = 'Partially';
        } else if (proStatus == 2) {
          approveStatus = 'Completed';
        } else if (proStatus == 3) {
          approveStatus = 'Approved';
        } else if (proStatus == 4) {
          approveStatus = 'Commented';
        } else {
          approveStatus = 'Pending';
        }
      }
    } catch (ex, _) {
      approveStatus = 'Pending';
    }
    return approveStatus;
  }

  String ConvertLongtoShortString(String str) {
    var list = str.split(' ');
    var tempStr = '';
    for (var i in list) {
      if (i.length > 3) {
        tempStr += "${i.substring(0, 4).toUpperCase()} ";
      } else {
        tempStr += "${i.toUpperCase()} ";
      }
    }

    return tempStr;
  }

  int getProStatus(String proStatus, EcmNodeListMasterModel model) {
    int? status = 0;
    try {
      proStatus = proStatus.toLowerCase();
      if (proStatus.contains('mechan')) {
        status = int.tryParse(model.mechanical ?? '0');
      } else if (proStatus.contains('erect'))
        status = int.tryParse(model.erection ?? '0');
      else if (proStatus.contains('dry comm'))
        status = int.tryParse(model.dryCommissioning ?? '0');
      else if (proStatus.contains('wet comm'))
        status = int.tryParse(model.wetCommissioning ?? '0');
    } catch (_) {}
    return status ?? 0;
  }

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

  bool canProceed(ProcessMasterModel process, EcmNodeListMasterModel node) {
    var selectedProcess = process.processName!.toLowerCase();

    if (process.processId == 4) {
      if (selectedProcess.contains("mechanical")) return true;
      if (selectedProcess.contains("erection") &&
          (node.mechanical == "2" || node.mechanical == "3"))
        return true;
      if (selectedProcess.contains("dry") &&
          (node.mechanical == "2" || node.mechanical == "3") &&
          (node.erection == "2" || node.erection == "3"))
        return true;
      if (selectedProcess.contains("wet") &&
          (node.mechanical == "2" || node.mechanical == "3") &&
          (node.erection == "2" || node.erection == "3") &&
          ((node.dryCommissioning == "1" || node.dryCommissioning == "2"))) {
        return true;
      }
      if (selectedProcess.contains("tower")) return true;
    } else {
      if (selectedProcess.contains("mechanical")) return true;
      if (selectedProcess.contains("erection") &&
          (node.mechanical == "2" || node.mechanical == "3"))
        return true;
      if ((selectedProcess.contains("dry comm") &&
          (node.erection == "2" || node.erection == "3")))
        return true;
      if (selectedProcess.contains("wet commissioning") &&
          (node.erection == "2" || node.erection == "3") &&
          (node.dryCommissioning == "2" || node.dryCommissioning == "3"))
        return true;
      if (selectedProcess.contains("tower")) return true;
    }

    return false;
  }

  Future<bool> insertCheckList(
    List<EcmReportMasterModel> checklist,
    String? remark,
    String? siteTeam,
    BuildContext context,
  ) async {
    if (checklist.isEmpty) return false;

    try {
      // --- Determine if process is partial ---
      final isPartialProcess = ["dry", "auto", "wet"].any(
        (p) => selectedReportProcess!.processName!.toLowerCase().contains(p),
      );

      // --- Validation: Check text and image/pdf ---
      final missingText = checklist.any(
        (item) =>
            (item.value == null || item.value!.isEmpty) &&
            item.inputType != "image" &&
            item.inputType != "pdf" &&
            item.inputType != "text" &&
            item.inputType!.isNotEmpty,
      );

      final images = checklist
          .where(
            (e) =>
                (e.inputType == "image" || e.inputType == "pdf") &&
                e.imageByteArray != null,
          )
          .toList();

      int approveStatus = 0;

      if (!isPartialProcess) {
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
      }

      // --- Submit subprocess-wise ---
      int submittedCount = 0;

      for (var subProcess in subProcessName ?? []) {
        var subList = checklist
            .where(
              (item) =>
                  item.subProcessName?.toLowerCase() ==
                  subProcess!.toString().toLowerCase(),
            )
            .toList();

        final response = await uploadToServer(
          context,
          subList,
          remark!,
          subList.first.subProcessId!,
          apporvedStatus: approveStatus,
          siteTeam: siteTeam ?? '',
        );

        if (response) submittedCount++;
      }

      return submittedCount == (subProcessName?.length ?? 0);
    } catch (e) {
      debugPrint('Error While Inserting Checklist Data: $e');
      return false;
    }
  }

  Future<bool> approveCheckList(
    List<EcmReportMasterModel> checklist,
    String? remark,
    BuildContext context,
  ) async {
    int approveStatus = 0;
    if (checklist.isEmpty) return false;
    try {
      // --- Determine if process is partial ---
      final isPartialProcess = [
        "dry",
        "auto",
        "wet",
      ].any((p) => selectedProcess!.processName!.toLowerCase().contains(p));

      if (!isPartialProcess) {
        approveStatus = 3; // Commented
      } else {
        approveStatus = 2; // Commented
      }
      final response = await approveOrCommentReport(
        context,
        remark!,
        apporvedStatus: approveStatus,
      );
      return response;
    } catch (e) {
      debugPrint('Error While Inserting Checklist Data: $e');
      return false;
    }
  }

  Future<bool> CommentCheckList(
    List<EcmReportMasterModel> checklist,
    String? remark,
    BuildContext context,
  ) async {
    int approveStatus = 0;
    if (checklist.isEmpty) return false;
    try {
      // --- Determine if process is partial ---
      final isPartialProcess = [
        "dry",
        "auto",
        "wet",
      ].any((p) => selectedProcess!.processName!.toLowerCase().contains(p));

      if (!isPartialProcess) {
        approveStatus = 4;
      } else {
        approveStatus = 3;
      }
      final response = await approveOrCommentReport(
        context,
        remark!,
        apporvedStatus: approveStatus,
      );
      return response;
    } catch (e) {
      debugPrint('Error While Inserting Checklist Data: $e');
      return false;
    }
  }

  Future<void> viewPdfByFileName(dynamic base64String, String fileName) async {
    // var bytes = base64Decode(base64String);
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName.pdf");
    await file.writeAsBytes(base64String.buffer.asUint8List());
    await OpenFile.open("${output.path}/$fileName.pdf");
  }

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

  Future<bool> uploadToServer(
    BuildContext context,
    List<EcmReportMasterModel> imageList,
    String? remark,
    int subprocessId, {
    int apporvedStatus = 0,
    String siteTeam = '',
  }) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      String submitDate = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(
        imageList
            .where(
              (element) =>
                  (element.inputType == 'image' ||
                      element.inputType == 'pdf') &&
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

      var checkListId = imageList.map((e) => e.checkListId).toList().join(",");
      var valueData = imageList.map((e) => e.value ?? '').toList().join(",");
      var aproveStatus = apporvedStatus;
      var projectUser = ap.projectUserDetails?.userid;

      var data = json.encode({
        "ProcessId": selectedReportProcess!.processId!,
        "SubProcessId": subprocessId,
        "Checklistid": checkListId,
        "deviceId": getDeviceIdBySource(_source!),
        "userid": projectUser ?? 0,
        "values": valueData,
        "remark": remark!,
        "approvestatus": aproveStatus,
        "workedOn": submitDate,
        "deviceType": _source,
        "siteEngineer": siteTeam,
        "projectId": ap.selectedProject!.id!,
      });

      if (countflag == uploadflag) {
        var result = await uploadECMReport(data);
        return result;
      } else {
        return false;
      }
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  Future<bool> approveOrCommentReport(
    BuildContext context,
    String? remark, {
    int apporvedStatus = 0,
  }) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      var aproveStatus = apporvedStatus;
      var data = json.encode({
        "ProcessId": selectedReportProcess!.processId!,
        "deviceId": getDeviceIdBySource(_source!),
        "userid": ap.projectUserDetails!.userid,
        "remark": remark!,
        "approveStatus": aproveStatus,
        "deviceType": _source,
        "projectId": projectId,
      });
      var result = await changeApproveStatus(data);
      return result;
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  Future<bool> addNew(
    List<EcmReportMasterModel> checklist,
    String remark,
    int projectId,
  ) async {
    var res = false;
    try {
      if (checklist.isNotEmpty) {
        for (int i = 0; i < checklist.length; i++) {
          final data = checklist[i];
          data
            ..deviceId = getDeviceIdBySource(source!)
            ..deviceType = source
            ..projectId = projectId
            ..image = null
            ..issaved = "Save Offline Data!";
          res = await ECMReportDB.instance.insertOrUpdate(data);
        }
      }
    } catch (e) {
      res = false;
      debugPrint('Error While Inserting Checklist Data: $e');
    }
    return res;
  }

  Future<bool> deleteReport(
    List<EcmReportMasterModel> report,
    int projectId,
  ) async {
    try {
      for (var report in report) {
        ECMReportDB.instance.deleteECMReport(
          report.deviceId!,
          report.processId!,
          report.deviceType!,
          projectId,
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error While Deleting ECM Report: $e');
      return false;
    }
  }

  Future<void> addNodes({
    required List<EcmNodeListMasterModel> nodes,
    required int projectId,
    required String deviceType,
  }) async {
    try {
      if (deviceType.toLowerCase() == 'oms') {
        for (var node in nodes) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await NodeDB.instance.insertOrUpdateOms(node);
        }
      }
      if (deviceType.toLowerCase() == 'ams') {
        for (var node in nodes) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await NodeDB.instance.insertOrUpdateAms(node);
        }
      }
      if (deviceType.toLowerCase() == 'rms') {
        for (var node in nodes) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await NodeDB.instance.insertOrUpdateRms(node);
        }
      }
      if (deviceType.toLowerCase() == 'lora') {
        for (var node in nodes) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await NodeDB.instance.insertOrUpdateLoRa(node);
        }
      }
    } catch (e) {
      throw Exception('Failed to add nodes: $e');
    }
  }

  Future<void> deleteNode(
    int deviceId,
    String deviceType,
    int projectId,
  ) async {
    try {
      if (deviceType.toLowerCase() == 'oms') {
        await NodeDB.instance.deleteOMSNode(deviceId, projectId, deviceType);
      }
      if (deviceType.toLowerCase() == 'ams') {
        await NodeDB.instance.deleteAMSNode(deviceId, projectId, deviceType);
      }
      if (deviceType.toLowerCase() == 'rms') {
        await NodeDB.instance.deleteRMSNode(deviceId, projectId, deviceType);
      }
      if (deviceType.toLowerCase() == 'lora') {
        await NodeDB.instance.deleteLoRANode(deviceId, projectId, deviceType);
      }
    } catch (e) {
      throw Exception('Failed to delete nodes: $e');
    }
  }

  Future<void> toggleTranslation(String langCode) async {
    if (langCode != 'en') {
      if (_checklistModel != null) {
        _checklistModel = await Future.wait(
          _checklistModel!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.description = await TranslationHelper.translate(
              _originalDescriptions[i], // ✅ Always from original list
              langCode,
            );
            e.subProcessName = await TranslationHelper.translate(
              _originalSubProcess[i], // ✅ Always from original list
              langCode,
            );
            return e;
          }),
        );
        updateChecklistModel(_checklistModel);
      }
    } else {
      if (_originalDescriptions.isNotEmpty &&
          _originalSubProcess.isNotEmpty &&
          _checklistModel != null) {
        _checklistModel = await Future.wait(
          _checklistModel!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.description = _originalDescriptions[i];
            e.subProcessName = _originalSubProcess[i];
            return e;
          }),
        );
        updateChecklistModel(_checklistModel);
      }
    }

    notifyListeners();
  }
}
