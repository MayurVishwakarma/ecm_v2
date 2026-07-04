// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, unused_field

import 'dart:convert';
import '../../../Core/Database/DamageDBHelper.dart';
import '../../../Core/Models/Damage/DamageHistoryModel.dart';
import '../../../Core/Models/Damage/DamageNodeMasterModel.dart';
import '../../../Core/Models/Damage/DamageReportModel.dart';
import '../../../Core/Models/Damage/DamageStatusCountModel.dart';
import '../../../Core/Models/Damage/InfoReportMasterModel.dart';
import '../../../Core/Models/Damage/InformationCountModel.dart';
import '../../../Core/Models/Damage/InfromationHistoryModel.dart';
import '../../../Core/Models/Damage/InfromationListModel.dart';
import '../../../Core/Models/Damage/MaterialHistoryModel.dart';
import '../../../Core/Models/Damage/MaterialReportModel.dart';
import '../../../Core/Models/Damage/MaterialStatusCountModel.dart';
import '../../../Core/Models/Damage/MaterialStatusListModel.dart';
import '../../../Core/Models/Damage/RectificationNodeModel.dart';
import '../../../Core/Models/Damage/RectificationReportModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Repositories/Auth-Repositories.dart';
import '../../../Core/Repositories/Damage-Repositories.dart';
import '../../../Utils/Functions/ImageCommpress.dart';
import '../../../Utils/Functions/locationProcessHelper.dart';
import '../../../Utils/Functions/translate_helper.dart';
import '../../../Utils/Themes/color_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class DamageProvider extends ChangeNotifier {
  String? _source;
  String? get source => _source;
  bool _isLoad = false;
  bool get isLoad => _isLoad;
  bool _isEdit = false;
  bool get isEdit => _isEdit;
  String? _workedBy;
  String? _approvedBy;
  String? _selectedMenu;
  final List<String> _damageMenus = [
    "Damage Form",
    "Material Consumption",
    "Information",
    "Issue",
  ];
  final List<String> _damageProcess = [
    "Electrical",
    "Mechanical",
    "Rectification",
  ];
  final List<String> _materialProcess = ["Electrical", "Mechanical", "Tubing"];
  final List<String> _informatinProcess = ["Information"];
  final List<String> _issueProcess = ["Issue"];
  List<DamageNodeModel>? _nodeList;
  List<DamageNodeModel>? _damagestatuslist;
  List<DamageStatusCountModel>? _damageStatusCount;
  List<MaterialStatusCountModel>? _materialStatusCount;
  List<MaterialStatusListModel>? _materialStatusList;
  List<MaterialHistoryModel>? _materialHistory;
  MaterialHistoryModel? _materialHistoryReport;
  List<InformationCountModel>? _informationCount;
  List<InformationListModel>? _informationList;
  List<InformationHistoryModel>? _informationHistory;
  List<RectificationNodeModel>? _rectificationList;

  MaterialStatusListModel? _selectedMaterialNode;
  DamageNodeModel? _selectedNode;
  RectificationNodeModel? _selectedRec;
  InformationListModel? _selectedInformationNode;
  List<DamageReportModel>? _damageReport;
  List<RectificationReportModel>? _rectificationReport;
  List<MaterialReportModel>? _materialReport;
  List<InfoReportModel>? _infoReport;
  List<DamageHistoryModel>? _damageHistory;
  DamageHistoryModel? _damageHistoryReport;
  InformationHistoryModel? _informationHistoryReport;
  String? get workedBy => _workedBy;
  String? get approvedBy => _approvedBy;
  String? get selectedMenu => _selectedMenu;
  List<String> get damageMenus => _damageMenus;
  List<String> get damageProcess => _damageProcess;
  List<String> get materialProcess => _materialProcess;
  List<RectificationNodeModel>? get rectificationList => _rectificationList;
  List<RectificationReportModel>? get rectificationReport =>
      _rectificationReport;

  List<String> get informationProcess => _informatinProcess;
  List<String> get issueProcess => _issueProcess;
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
  List<DamageNodeModel>? get nodeList => _nodeList;
  List<DamageNodeModel>? get damagestatuslist => _damagestatuslist;
  List<DamageStatusCountModel>? get damageStatusCount => _damageStatusCount;
  List<MaterialStatusCountModel>? get materialStatusCount =>
      _materialStatusCount;
  List<MaterialStatusListModel>? get materialStatusList => _materialStatusList;
  List<MaterialHistoryModel>? get materialHistory => _materialHistory;
  List<InformationCountModel>? get informationCount => _informationCount;
  List<InformationListModel>? get informationList => _informationList;
  MaterialStatusListModel? get selectedMaterialNode => _selectedMaterialNode;
  DamageNodeModel? get selectedNode => _selectedNode;
  RectificationNodeModel? get selectedRec => _selectedRec;
  InformationListModel? get selectedInformationNode => _selectedInformationNode;
  List<DamageReportModel>? get damageReport => _damageReport;
  List<MaterialReportModel>? get materialReport => _materialReport;
  List<InfoReportModel>? get infoReports => _infoReport;
  List<DamageHistoryModel>? get damageHistory => _damageHistory;
  DamageHistoryModel? get damageHistoryReport => _damageHistoryReport;
  InformationHistoryModel? get informationHistoryReport =>
      _informationHistoryReport;
  List<DamageStatusCountModel>? _filter;
  List<DamageStatusCountModel>? get filter => _filter;
  List<MaterialStatusCountModel>? _materialfilter;
  List<MaterialStatusCountModel>? get materialfilter => _materialfilter;
  MaterialHistoryModel? get materialHistoryReport => _materialHistoryReport;
  List<InformationCountModel>? _informationFilter;
  List<InformationCountModel>? get informationFilter => _informationFilter;
  List<InformationHistoryModel>? get informationHistory => _informationHistory;

  List<String> _originalDescriptions = [];
  List<String> _originalMaterialList = [];
  List<String> _originalInfoList = [];
  List<String> _originalIssueList = [];
  List<String> _originalRectification = [];

  void updateSource(String? res) {
    _source = res;
    notifyListeners();
  }

  void updateIsEdit(bool res) {
    _isEdit = res;
    notifyListeners();
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

  void updateNodeList(List<DamageNodeModel>? nodeList, {bool isadd = false}) {
    if (isadd && nodeList != null) {
      _nodeList?.addAll(nodeList);
    } else {
      _nodeList = nodeList;
    }
    notifyListeners();
  }

  void updateRectificationList(
    List<RectificationNodeModel>? rectificationList, {
    bool isadd = false,
  }) {
    if (isadd && rectificationList != null) {
      _rectificationList?.addAll(rectificationList);
    } else {
      _rectificationList = rectificationList;
    }
    notifyListeners();
  }

  void updateStatusList(List<DamageNodeModel>? nodeList) {
    _damagestatuslist = nodeList;
    notifyListeners();
  }

  void updateMaterialHistory(List<MaterialHistoryModel>? res) {
    _materialHistory = res;
    notifyListeners();
  }

  void updateMaterialHistoryReport(MaterialHistoryModel? res) {
    _materialHistoryReport = res;
    notifyListeners();
  }

  void updateInformationHistory(List<InformationHistoryModel>? res) {
    _informationHistory = res;
    notifyListeners();
  }

  void updateStatusCount(List<DamageStatusCountModel>? nodeList) {
    _damageStatusCount = nodeList;
    notifyListeners();
  }

  void updateMaterialStatusCount(List<MaterialStatusCountModel>? res) {
    _materialStatusCount = res;
    notifyListeners();
  }

  void updateInformationCount(List<InformationCountModel>? res) {
    _informationCount = res;
    notifyListeners();
  }

  void updateInformationList(List<InformationListModel>? res) {
    _informationList = res;
    notifyListeners();
  }

  void updatefilter(List<DamageStatusCountModel>? res) {
    _filter = res;
    notifyListeners();
  }

  void updateMaterialfilter(List<MaterialStatusCountModel>? res) {
    _materialfilter = res;
    notifyListeners();
  }

  void updateInformationFilter(List<InformationCountModel>? res) {
    _informationFilter = res;
    notifyListeners();
  }

  void updateSelectedNode(DamageNodeModel? node) {
    _selectedNode = node;
    notifyListeners();
  }

  void updateMaterialSelectedNode(MaterialStatusListModel? node) {
    _selectedMaterialNode = node;
    notifyListeners();
  }

  void updateSelectedInformationNode(InformationListModel? node) {
    _selectedInformationNode = node;
    notifyListeners();
  }

  void updateSelectedRec(RectificationNodeModel? node) {
    _selectedRec = node;
    notifyListeners();
  }

  void updateDamageReport(List<DamageReportModel>? res) {
    _damageReport = res;

    notifyListeners();
  }

  void updateRectificationReport(List<RectificationReportModel>? res) {
    _rectificationReport = res;
    notifyListeners();
  }

  void updateMaterialStatusList(List<MaterialStatusListModel>? nodeList) {
    _materialStatusList = nodeList;
    notifyListeners();
  }

  void updateMaterialReport(List<MaterialReportModel>? res) {
    _materialReport = res;
    notifyListeners();
  }

  void updateInfoReport(List<InfoReportModel>? res) {
    _infoReport = res;
    notifyListeners();
  }

  void updateDamageHistory(List<DamageHistoryModel>? res) {
    _damageHistory = res;
    notifyListeners();
  }

  void updateDamageHistoryReport(DamageHistoryModel? res) {
    _damageHistoryReport = res;
    notifyListeners();
  }

  void updateInformationHistoryReport(InformationHistoryModel? res) {
    _informationHistoryReport = res;
    notifyListeners();
  }

  void updateSelectedMenu(String? res) {
    _selectedMenu = res;
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

  int getDeviceIdInfoBySource(String? source) {
    try {
      switch (source) {
        case 'OMS':
          return _selectedInformationNode?.omsId ?? 0;
        case 'AMS':
          return _selectedInformationNode?.amsId ?? 0;
        case 'RMS':
          return _selectedInformationNode?.rmsId ?? 0;
        case 'LORA':
          return _selectedInformationNode?.gateWayId ?? 0;
        default:
          return 0;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return 0;
    }
  }

  int getMaterialDeviceIdBySource(String? source) {
    try {
      switch (source) {
        case 'OMS':
          return _selectedMaterialNode?.omsId ?? 0;
        case 'AMS':
          return _selectedMaterialNode?.amsId ?? 0;
        case 'RMS':
          return _selectedMaterialNode?.rmsId ?? 0;
        case 'LORA':
          return _selectedMaterialNode?.gateWayId ?? 0;
        default:
          return 0;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return 0;
    }
  }

  int getRectificationDeviceIdBySource(String? source) {
    try {
      switch (source) {
        case 'OMS':
          return _selectedRec?.omsId ?? 0;
        case 'AMS':
          return _selectedRec?.amsId ?? 0;
        case 'RMS':
          return _selectedRec?.rmsId ?? 0;
        case 'LORA':
          return _selectedRec?.gatewayId ?? 0;
        default:
          return 0;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return 0;
    }
  }

  Future<void> pickImage(
    ImageSource media,
    DamageReportModel imageItem,
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
      if (media == ImageSource.camera) {
        await markCameraImageForGallery(watermarkedFile.path);
      }

      // update checklist item with image
      await unmarkCameraImageForGallery(imageItem.image?.path);
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

  void deleteImage(DamageReportModel model) {
    unmarkCameraImageForGallery(model.image?.path);
    model.image = null;
    model.imageByteArray = null;
    model.value = null;
    notifyListeners();
  }

  Future<void> pickRectificationImage(
    ImageSource media,
    RectificationReportModel imageItem,
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
      if (media == ImageSource.camera) {
        await markCameraImageForGallery(watermarkedFile.path);
      }

      // update checklist item with image
      await unmarkCameraImageForGallery(imageItem.image?.path);
      updateRectificationChecklistItem(
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

  void deleteRectificationImage(RectificationReportModel model) {
    unmarkCameraImageForGallery(model.image?.path);
    model.image = null;
    model.imageByteArray = null;
    model.value = null;
    notifyListeners();
  }

  void updateChecklistItem(
    DamageReportModel item,
    Uint8List bytes,
    XFile file,
  ) {
    item.imageByteArray = bytes;
    item.image = file;

    notifyListeners();
  }

  void updateRectificationChecklistItem(
    RectificationReportModel item,
    Uint8List bytes,
    XFile file,
  ) {
    item.imageByteArray = bytes;
    item.image = file;

    notifyListeners();
  }

  void setWorkedBy(String? workedBy) {
    _workedBy = workedBy;
    notifyListeners();
  }

  Future<void> getProjectUserDetailsByUserId(
    int? userId,
    int? projectId,
  ) async {
    try {
      var projectUserDetails = await fetchProjectUserDetails(
        userId: userId,
        projectId: projectId,
      );
      setWorkedBy(projectUserDetails.firstname);
    } catch (e) {
      //print("Error fetching project user details: $e");
    }
  }

  Widget getDamageStatusBar(String pro, int proStatus) {
    try {
      // Common styling for all bars
      BoxDecoration baseBox(Color color) => BoxDecoration(
        color: color,
        border: Border.all(color: ColorManager.darkElm, width: 1),
        borderRadius: BorderRadius.circular(5),
      );

      Widget buildBox(Color color, String text) {
        return Container(
          width: 150, // 🔥 increased width
          height: 50, // 🔥 increased height
          decoration: baseBox(color),
          child: Center(
            child: FittedBox(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white, // default text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      if (pro.toLowerCase().contains('ele')) {
        if (proStatus != 0) {
          return buildBox(Colors.red, "$proStatus");
        } else {
          return buildBox(Colors.green, "$proStatus");
        }
      } else if (pro.toLowerCase().contains('mech')) {
        if (proStatus != 0) {
          return buildBox(Colors.red, "$proStatus");
        } else {
          return buildBox(Colors.green, "$proStatus");
        }
      } else if (pro.toLowerCase().contains('tub')) {
        if (proStatus != 0) {
          return buildBox(Colors.red, "$proStatus");
        } else {
          return buildBox(Colors.green, "$proStatus");
        }
      } else {
        return buildBox(Colors.red, "Pending");
      }
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
            "0",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }
  }

  Future<void> getDamageFormNode({
    int? projectId,
    String? search,
    String? source,
    String? area,
    String? distributory,
    int index = 0,
    int limit = 10,
  }) async {
    try {
      var result = await getDamageStatusList(
        search: search ?? '',
        projectId: projectId,
        source: source,
        area: area,
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

  Future<void> getRectificationFormNode({
    int? projectId,
    String? search,
    String? source,
    String? area,
    String? distributory,
    int index = 0,
    int limit = 10,
  }) async {
    try {
      var result = await getRectificationNodeList(
        search: search ?? '',
        projectId: projectId,

        source: source,
        area: area,
        distributory: distributory ?? 'all',
        index: index,
        limit: limit,
      );
      bool isadd = index != 0;
      updateRectificationList(result, isadd: isadd);
    } catch (e) {
      throw Exception('Failed to fetch ECM nodes: $e');
    }
  }

  Future<void> getDamageStatusNode({
    int? projectId,
    String? search,
    String? source,
    String? area,
    String? distributory,
    // int index = 0,
    // int limit = 10,
  }) async {
    try {
      var result = await getDamageSummaryList(
        filter: search ?? '0',
        projectId: projectId,
        source: source,
        area: area,
        distributory: distributory ?? 'all',
      );

      updateStatusList(result);
      // addNodes(nodes: result, projectId: projectId!, deviceType: source!);
    } catch (e) {
      throw Exception('Failed to fetch ECM nodes: $e');
    }
  }

  Future<void> getDamageStatusFilter({
    int? projectId,

    String? source,
    String? area,
    String? distributory,
    // int index = 0,
    // int limit = 10,
  }) async {
    try {
      var result = await getDamageSummaryCount(
        projectId: projectId,
        source: source,
        area: area,
        distributory: distributory ?? 'all',
      );

      updateStatusCount(result);
      // addNodes(nodes: result, projectId: projectId!, deviceType: source!);
    } catch (e) {
      throw Exception('Failed to fetch ECM nodes: $e');
    }
  }

  Future<void> getDamageReport({
    required int deviceId,
    required String source,
    required int projectId,
    String? langCode = 'en',
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await getDamageform(
        deviceId: deviceId,
        deviceType: source,
        projectId: projectId,
      );
      _originalDescriptions = result.map((e) => e.damage ?? '').toList();
      if (langCode != 'en') {
        result = await Future.wait(
          result.map((e) async {
            e.damage = await TranslationHelper.translate(
              e.damage ?? '',
              langCode!,
            );
            return e;
          }),
        );
      }
      updateDamageReport(result);

      if (result.first.userId != null) {
        await getProjectUserDetailsByUserId(result.first.userId, projectId);
      }
      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getRectificationReport({
    required int deviceId,
    required String source,
    required int projectId,
    String? langCode = 'en',
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await RectificationReport(
        deviceId: deviceId,
        deviceType: source,
        projectId: projectId,
      );
      _originalRectification = result
          .map((e) => e.rectification ?? '')
          .toList();
      if (langCode != 'en') {
        result = await Future.wait(
          result.map((e) async {
            e.rectification = await TranslationHelper.translate(
              e.rectification ?? '',
              langCode!,
            );
            return e;
          }),
        );
      }
      updateRectificationReport(result);

      if (result.first.userId != null) {
        await getProjectUserDetailsByUserId(result.first.userId, projectId);
      }
      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getMaterialReport({
    required int deviceId,
    required String source,
    required int projectId,
    String? langCode,
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await getMatrialform(
        deviceId: deviceId,
        deviceType: source,
        projectId: projectId,
      );
      _originalMaterialList = result.map((e) => e.rectification ?? '').toList();
      if (langCode != 'en') {
        result = await Future.wait(
          result.map((e) async {
            e.rectification = await TranslationHelper.translate(
              e.rectification ?? '',
              langCode!,
            );
            return e;
          }),
        );
      }
      updateMaterialReport(result);

      if (result.first.reportedBy != null) {
        await getProjectUserDetailsByUserId(result.first.reportedBy, projectId);
      }
      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getInfoReport({
    required int deviceId,
    required String source,
    required int projectId,
    required int type,
    String? langCode,
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await getInfomationform(
        deviceId: deviceId,
        deviceType: source,
        projectId: projectId,
        type: type,
      );
      type == 1
          ? _originalInfoList = result
                .map((e) => e.infoDescription ?? '')
                .toList()
          : _originalIssueList = result
                .map((e) => e.infoDescription ?? '')
                .toList();
      if (langCode != 'en') {
        if (type == 1) {
          result = await Future.wait(
            result.map((e) async {
              e.infoDescription = await TranslationHelper.translate(
                e.infoDescription ?? '',
                langCode!,
              );
              return e;
            }),
          );
        }
        if (type == 2) {
          result = await Future.wait(
            result.map((e) async {
              e.infoDescription = await TranslationHelper.translate(
                e.infoDescription ?? '',
                langCode!,
              );
              return e;
            }),
          );
        }
      }
      updateInfoReport(result);

      if (result.first.reportedBy != null) {
        await getProjectUserDetailsByUserId(result.first.reportedBy, projectId);
      }
      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
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

  Future<bool> insertDamageReport(
    BuildContext context,
    List<DamageReportModel> report,
    String? remark,
  ) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(
        report
            .where(
              (element) =>
                  (element.type?.toLowerCase() == 'image' ||
                      element.type?.toLowerCase() == 'pdf') &&
                  /*(element.value?.toLowerCase() == '1' ||
                      element.value?.toLowerCase() == 'yes') &&*/
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

      var checkListId = report.map((e) => e.id).toList().join(",");
      var valueData = report.map((e) => e.value ?? '').toList().join(",");
      // var images = report.map((e) => e.imagePath ?? '').toList().join(",");
      int deviceId = getDeviceIdBySource(source!);
      var projectUser = ap.projectUserDetails?.userid;

      var data = json.encode({
        "userid": projectUser.toString(),
        "deviceId": deviceId,
        "Checklistid": checkListId,
        "values": valueData,
        // "imagePath": images,
        "deviceType": source!.toUpperCase(),
        "remark": remark,
        "projectId": projectId,
      });

      if (countflag == uploadflag) {
        var result = await uploadDamageReport(data);
        if (result) {
          await savePendingCameraImagesToGallery(report.map((e) => e.image));
        }
        return result;
      } else {
        return false;
      }
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  Future<bool> insertMaterialReport(
    BuildContext context,
    List<MaterialReportModel> report,
    String? remark,
  ) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      var checkListId = report.map((e) => e.id).toList().join(",");
      var valueData = report.map((e) => e.value ?? '').toList().join(",");
      int deviceId = getDeviceIdBySource(source!);
      var projectUser = ap.projectUserDetails?.userid;

      var data = json.encode({
        "deviceId": deviceId,
        "Checklistid": checkListId,
        "values": valueData,
        "userid": projectUser.toString(),
        "remark": remark,
        "deviceType": source!.toUpperCase(),
        "projectId": projectId,
      });

      var result = await uploadMaterialReport(data);
      return result;
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  Future<bool> insertInfoReport(
    BuildContext context,
    List<InfoReportModel> report,
    String? remark,
    int? type,
  ) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      int countflag = 0;
      int uploadflag = 0;
      await Future.wait(
        report
            .where(
              (element) =>
                  (element.type?.toLowerCase() == 'image' ||
                      element.type?.toLowerCase() == 'pdf') &&
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

      var checkListId = report.map((e) => e.id).toList().join(",");
      var valueData = report.map((e) => e.value ?? '').toList().join(",");
      int deviceId = getDeviceIdBySource(source!);
      var projectUser = ap.projectUserDetails?.userid;

      var data = json.encode({
        "deviceId": deviceId,
        "Checklistid": checkListId,
        "values": valueData,
        "userid": projectUser.toString(),
        "deviceType": source!.toUpperCase(),
        "remark": remark,
        "infoType": type,
        "projectId": projectId,
      });

      if (countflag == uploadflag) {
        var result = await uploadInfromationReport(data);
        if (result) {
          await savePendingCameraImagesToGallery(report.map((e) => e.image));
        }
        return result;
      } else {
        return false;
      }
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  Future<bool> insertRectificationReport(
    BuildContext context,
    List<RectificationReportModel> report,
    String? remark,
  ) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    try {
      int projectId = ap.selectedProject!.id!;
      int countflag = 0;
      int uploadflag = 0;

      await Future.wait(
        report
            .where(
              (element) =>
                  (element.inputType?.toLowerCase() == 'image' ||
                      element.inputType?.toLowerCase() == 'pdf') &&
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

      // var checkListId = report.map((e) => e.id).toList().join(",");
      // var valueData = report.map((e) => e.value ?? '').toList().join(",");
      var checkListId = report.map((e) => e.id).toList().join(",");
      var valueData = report.map((e) => e.value ?? '').toList().join(",");
      int deviceId = getRectificationDeviceIdBySource(source!);
      var projectUser = ap.projectUserDetails?.userid;

      var data = json.encode({
        "userid": projectUser.toString(),
        "deviceId": deviceId,
        "Checklistid": checkListId,
        "values": valueData,
        "deviceType": source!.toUpperCase(),
        "remark": remark,
        "projectId": projectId,
      });

      if (countflag == uploadflag) {
        var result = await uploadRectificationReport(data);
        if (result) {
          await savePendingCameraImagesToGallery(report.map((e) => e.image));
        }
        return result;
      } else {
        return false;
      }
    } catch (_, ex) {
      debugPrint('Error While Inserting Checklist Data: $ex');
      return false;
    }
  }

  Future<void> getDamageHistory({
    int? projectId,
    String? source,
    int? deviceId,
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await getDamageHistoryReport(
        deviceId: deviceId,
        projectId: projectId,
        source: source,
      );
      updateDamageHistory(result);

      if (result.first.userId != null) {
        await getProjectUserDetailsByUserId(result.first.userId, projectId);
      }
      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getMaterialStatusFilter({
    int? projectId,
    String? source,
    String? area,
    String? distributory,
  }) async {
    try {
      var result = await getMaterialSummaryCount(
        projectId: projectId,
        source: source,
        area: area,
        distributory: distributory ?? 'all',
      );

      updateMaterialStatusCount(result);
      // addNodes(nodes: result, projectId: projectId!, deviceType: source!);
    } catch (e) {
      throw Exception('Failed to fetch ECM nodes: $e');
    }
  }

  Future<void> getMaterialStatusList({
    int? projectId,
    String? search,
    String? source,
    String? area,
    String? distributory,
    String? filter,
  }) async {
    try {
      var result = await getMaterialSummaryList(
        search: search,
        area: area,
        distributory: distributory,
        source: source,
        filter: filter ?? '0',
        projectId: projectId,
      );

      updateMaterialStatusList(result);
    } catch (e) {
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getMaterialHistory({
    int? projectId,
    String? source,
    int? deviceId,
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await getMaterialHistoryReport(
        deviceId: deviceId,
        projectId: projectId,
        source: source,
      );
      updateMaterialHistory(result);

      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getInformationStatusFilter({
    int? projectId,
    String? source,
    String? area,
    String? distributory,
    String? type = 'info',
  }) async {
    try {
      var result = await getInformationSummaryCount(
        projectId: projectId,
        source: source,
        area: area,
        distributory: distributory ?? 'all',
        type: type,
      );

      updateInformationCount(result);
    } catch (e) {
      throw Exception('Failed to fetch ECM nodes: $e');
    }
  }

  Future<void> getInformationStatusList({
    int? projectId,
    String? source,
    String? area,
    String? distributory,
    String? filter,
    String? type = 'info',
  }) async {
    try {
      var result = await getInformationSummaryList(
        area: area,
        distributory: distributory,
        source: source,
        filter: filter ?? '0',
        projectId: projectId,
        type: type,
      );

      updateInformationList(result);
    } catch (e) {
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> getInformationHistory({
    int? projectId,
    String? source,
    int? deviceId,
    String? type = 'info',
  }) async {
    try {
      Future.microtask(() => updateLoad(true));
      var result = await getInformationHistoryReport(
        deviceId: deviceId,
        projectId: projectId,
        source: source,
        type: type,
      );
      updateInformationHistory(result);

      await Future.delayed(Duration(seconds: 1), () {
        updateLoad(false);
      });
    } catch (e) {
      updateLoad(false);
      throw Exception('Failed to fetch ECM report: $e');
    }
  }

  Future<void> toggleTranslation(String langCode) async {
    if (langCode != 'en') {
      // 🔹 Damage Report
      if (_damageReport != null) {
        _damageReport = await Future.wait(
          _damageReport!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.damage = await TranslationHelper.translate(
              _originalDescriptions[i], // ✅ Always from original list
              langCode,
            );
            return e;
          }),
        );
        // _damageReport = await Future.wait(
        //   _damageReport!.map((e) async {
        //     e.damage = await TranslationHelper.translate(
        //       e.damage ?? '',
        //       langCode,
        //     );
        //     return e;
        //   }),
        // );
      }

      // 🔹 Material Report
      if (_materialReport != null) {
        _materialReport = await Future.wait(
          _materialReport!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.rectification = await TranslationHelper.translate(
              _originalMaterialList[i], // ✅ Always from original list
              langCode,
            );
            return e;
          }),
        );
        /*_materialReport = await Future.wait(
          _materialReport!.map((e) async {
            e.rectification = await TranslationHelper.translate(
              e.rectification ?? '',
              langCode,
            );
            return e;
          }),
        );*/
      }

      // 🔹 Info Report
      if (_infoReport != null) {
        _infoReport = await Future.wait(
          _infoReport!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.infoDescription = await TranslationHelper.translate(
              _originalInfoList[i], // ✅ Always from original list
              langCode,
            );
            return e;
          }),
        );
        /* _infoReport = await Future.wait(
          _infoReport!.map((e) async {
            e.infoDescription = await TranslationHelper.translate(
              e.infoDescription ?? '',
              langCode,
            );
            return e;
          }),
        );*/
      }

      // 🔹 Issue Report (if same as infoReport)
      if (_infoReport != null) {
        _infoReport = await Future.wait(
          _infoReport!.asMap().entries.map((entry) async {
            final i = entry.key;
            final e = entry.value;
            e.infoDescription = await TranslationHelper.translate(
              _originalIssueList[i], // ✅ Always from original list
              langCode,
            );
            return e;
          }),
        );
        /* _infoReport = await Future.wait(
          _infoReport!.map((e) async {
            e.infoDescription = await TranslationHelper.translate(
              e.infoDescription ?? '',
              langCode,
            );
            return e;
          }),
        );*/
      }
    } else {
      // 👉 Revert back to original text
      if (_originalDescriptions.isNotEmpty && _damageReport != null) {
        for (int i = 0; i < _originalDescriptions.length; i++) {
          _damageReport![i].damage = _originalDescriptions[i];
        }
      }

      if (_originalMaterialList.isNotEmpty && _materialReport != null) {
        for (int i = 0; i < _originalMaterialList.length; i++) {
          _materialReport![i].rectification = _originalMaterialList[i];
        }
      }

      if (_originalInfoList.isNotEmpty && _infoReport != null) {
        for (int i = 0; i < _originalInfoList.length; i++) {
          _infoReport![i].infoDescription = _originalInfoList[i];
        }
      }

      if (_originalIssueList.isNotEmpty && _damagestatuslist != null) {
        for (int i = 0; i < _originalIssueList.length; i++) {
          _infoReport![i].infoDescription = _originalIssueList[i];
        }
      }
    }

    notifyListeners();
  }

  Future<bool> addDamageReport(
    List<DamageReportModel> checklist,
    String remark,
    int projectId,
  ) async {
    var res = false;
    try {
      if (checklist.isNotEmpty) {
        for (int i = 0; i < checklist.length; i++) {
          final data = checklist[i];
          data
            ..omsId = getDeviceIdBySource(source!)
            ..projectId = projectId
            ..image = null
            ..isSaved = "Save Offline Data!";
          res = await DamageReportDB.instance.insertOrUpdate(data, source!);
        }
      }
    } catch (e) {
      res = false;
      debugPrint('Error While Inserting Checklist Data: $e');
    }
    return res;
  }

  Future<bool> deleteReport(
    List<DamageReportModel> report,
    int projectId,
    String deviceType,
  ) async {
    try {
      for (var report in report) {
        DamageReportDB.instance.deleteDamageReport(
          report.omsId!,
          projectId,
          deviceType,
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error While Deleting ECM Report: $e');
      return false;
    }
  }

  Future<void> addNodes({
    required List<DamageNodeModel>? nodes,
    required int projectId,
    required String deviceType,
  }) async {
    try {
      if (deviceType.toLowerCase() == 'oms') {
        for (var node in nodes!) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await DamageNodeDB.instance.insertOrUpdateOms(node);
        }
      }
      if (deviceType.toLowerCase() == 'ams') {
        for (var node in nodes!) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await DamageNodeDB.instance.insertOrUpdateAms(node);
        }
      }
      if (deviceType.toLowerCase() == 'rms') {
        for (var node in nodes!) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await DamageNodeDB.instance.insertOrUpdateRms(node);
        }
      }
      if (deviceType.toLowerCase() == 'lora') {
        for (var node in nodes!) {
          node
            ..projectId = projectId
            ..deviceType = deviceType;
          await DamageNodeDB.instance.insertOrUpdateLoRa(node);
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
        await DamageNodeDB.instance.deleteOMSNode(
          deviceId,
          projectId,
          deviceType,
        );
      }
      if (deviceType.toLowerCase() == 'ams') {
        await DamageNodeDB.instance.deleteAMSNode(
          deviceId,
          projectId,
          deviceType,
        );
      }
      if (deviceType.toLowerCase() == 'rms') {
        await DamageNodeDB.instance.deleteRMSNode(
          deviceId,
          projectId,
          deviceType,
        );
      }
      if (deviceType.toLowerCase() == 'lora') {
        await DamageNodeDB.instance.deleteLoRANode(
          deviceId,
          projectId,
          deviceType,
        );
      }
    } catch (e) {
      throw Exception('Failed to delete nodes: $e');
    }
  }

  Future<bool> addMaterialReport(
    List<MaterialReportModel> checklist,
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
            ..projectId = projectId
            ..image = null
            ..isSaved = "Save Offline Data!";
          res = await MaterialReportDB.instance.insertOrUpdate(data);
        }
      }
    } catch (e) {
      res = false;
      debugPrint('Error While Inserting Checklist Data: $e');
    }
    return res;
  }

  Future<bool> deleteMaterialReport(
    List<MaterialReportModel> report,
    int projectId,
    String deviceType,
  ) async {
    try {
      for (var report in report) {
        MaterialReportDB.instance.deleteRectificationReport(
          report.deviceId!,
          projectId,
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error While Deleting ECM Report: $e');
      return false;
    }
  }
}
