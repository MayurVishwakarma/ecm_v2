// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names

// import '../../../Core/Models/MenuModel.dart';
import 'dart:convert';
import '../../../Screens/Damage/InformationReport/InformationTab.dart';
import '../../../Screens/Damage/IssueReport/IssueTab.dart';
import '../../../Screens/Damage/RectificationForm/RectificationTabBarPage.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/MenuModel.dart';
import '../../../Core/Models/ProjectDetailsModel.dart';
import '../../../Core/Models/ProjectUserModel.dart';
import '../../../Core/Models/UserMasterModel.dart';
import '../../../Core/Repositories/Auth-Repositories.dart';
import '../../../Screens/Auth/LoginScreen.dart';
import '../../../Screens/Auth/ProjectList.dart';
import '../../../Screens/Damage/DamageForm/DamageTabBarPage.dart';
import '../../../Screens/Damage/DamageHistory/DamageHistoryManager.dart';
import '../../../Screens/Damage/DamageMenuPage.dart';
import '../../../Screens/Damage/DamageStatus/DamageStatusTab.dart';
import '../../../Screens/Damage/MaterialConsumption/MaterialTab.dart';
import '../../../Core/Models/AreaMasterModel.dart';
import '../../../Core/Models/DistibutoryMasterModel.dart';
import '../../../Screens/ENC/ECMTabBarPage.dart';
import '../../../Screens/Maintainance/MaintainianceTool.dart';
import '../../../Screens/RoutineCheck/RoutineTabBarPage.dart';
import '../../../Utils/Themes/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

enum Keys { user }

class AuthProvider extends ChangeNotifier {
  final String versionNO = 'v0.1.8';
  UserMasterModel? _userDetails;
  ProjectUserDetailsModel? _projectUserDetails;
  List<ProjectDetailsModel>? _projectDetails;
  List<ProjectDetailsModel>? _backupList;
  ProjectDetailsModel? _selectedProject;
  bool _isManager = false;
  List<AreaMasterModel>? _area;
  AreaMasterModel? _selectedArea;
  List<DistibutoryMasterModel>? _distributory;
  DistibutoryMasterModel? _selectedDistributory;

  UserMasterModel? get userDetails => _userDetails;
  ProjectUserDetailsModel? get projectUserDetails => _projectUserDetails;
  List<ProjectDetailsModel>? get projectDetails => _projectDetails;
  List<ProjectDetailsModel>? get backupList => _backupList;
  ProjectDetailsModel? get selectedProject => _selectedProject;
  bool get isManager => _isManager;
  List<AreaMasterModel>? get area => _area;
  AreaMasterModel? get selectedArea => _selectedArea;
  List<DistibutoryMasterModel>? get distributory => _distributory;
  DistibutoryMasterModel? get selectedDistributory => _selectedDistributory;

  final List<MenuItem> menutabs = [
    MenuItem('ECM Tool', 'assets/images/ecm_2.png', EcmToolScreen()),
    MenuItem(
      'Damage/Rectification',
      'assets/images/rectification_1.png',
      DamageMenuPage(),
    ),
    MenuItem('Routine Check', 'assets/images/routine.png', RoutineTool()),
    /*MenuItem(
      'Site Survey Form',
      'assets/images/survey-from.png',
      SurveyToolScreen(),
    ),*/
    MenuItem('Maintenance', 'assets/images/maintenance.png', MaintenanceTool()),
    // MenuItem(
    //   'Production Overview',
    //   'assets/images/material-box.png',
    //   // ProductionToolScreen(),
    //   ProductionOverview(),
    // ),
  ];

  final List<MenuItem> damagetabs = [
    MenuItem(
      'Damage Form',
      'assets/images/damage-form.png',
      DamageTabBarTool(),
    ),
    MenuItem(
      'Rectification Form',
      'assets/images/repair.png',
      RectificationTabBarTool(),
    ),
    MenuItem(
      'Damage Status',
      'assets/images/status-report.png',
      DamageStatusManager(),
    ),
    MenuItem(
      'Damage History',
      'assets/images/damage-history.png',
      DamageHistoryManager(),
    ),
    MenuItem(
      'Material Consumption',
      'assets/images/material-box.png',
      MaterialManager(),
    ),
    MenuItem(
      'Information Report',
      'assets/images/infomation-report.png',
      InformationManager(),
    ),
    MenuItem('Issue Report', 'assets/images/issue-report.png', IssueManager()),
  ];

  void setUserDetails(UserMasterModel? userDetails) {
    _userDetails = userDetails;
    if (userDetails != null) {
      _isManager =
          userDetails.designation!.toLowerCase().contains('manager') ||
          userDetails.designation!.toLowerCase().contains('admin');
    }
    notifyListeners();
  }

  void setProjectUserDetails(ProjectUserDetailsModel? projectUserDetails) {
    _projectUserDetails = projectUserDetails;
    notifyListeners();
  }

  void updateProjectDetails(List<ProjectDetailsModel>? projectDetails) {
    _projectDetails = projectDetails;
    notifyListeners();
  }

  void updateSelectedProject(ProjectDetailsModel? project) {
    _selectedProject = project;
    notifyListeners();
  }

  void clearUserDetails() {
    _userDetails = null;
    notifyListeners();
  }

  Future<void> getUserLogin(
    String? loginId,
    String? password,
    BuildContext context,
  ) async {
    try {
      var user = await userLogin(loginId, password);
      setUserDetails(user);
      storeDataSharedPreferences(Keys.user, jsonEncode(user));
      if (user.pwd == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Welcome ${user.fName} you have logged in successfully into ECM.",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            backgroundColor: Colors.green.shade700,
          ),
        );
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Projectlist()),
          (route) => false,
        );
      } else {
        //print("Login failed: User details are null");
      }
    } catch (e) {
      //print("Error during user login: $e");
      rethrow;
    }
  }

  Future<void> getProjectUserDetailsByMobile(String? mobileNumber) async {
    try {
      int projectId = int.tryParse(_selectedProject?.id.toString() ?? "0") ?? 0;
      var projectUserDetails = await fetchProjectUserDetails(
        mobileNumber: mobileNumber,
        projectId: projectId,
      );
      setProjectUserDetails(projectUserDetails);
    } catch (e) {
      //print("Error fetching project user details: $e");
      rethrow; // Propagate the error
    }
  }

  Future<void> getProjectListByUserId(int? userId) async {
    try {
      var projects = await fetchProjectDetails(userId);
      updateProjectDetails(projects);
      _backupList = projects;
    } catch (e) {
      //print("Error fetching project details: $e");
      rethrow; // Propagate the error
    }
  }

  void filterProjects(String query, List<ProjectDetailsModel> projects) {
    _backupList = query.isEmpty
        ? projects
        : projects
              .where(
                (e) =>
                    e.projectName!.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    e.state!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    notifyListeners();
  }

  void updateArea(List<AreaMasterModel>? area) {
    _area = area;
    if (area != null && area.isNotEmpty) {
      _selectedArea ??= area.first; // auto select first only if not set
    }
    notifyListeners();
  }

  void updateDistributory(List<DistibutoryMasterModel>? distributory) {
    _distributory = distributory;
    if (distributory != null && distributory.isNotEmpty) {
      _selectedDistributory ??= distributory.first;
    }
    notifyListeners();
  }

  void updateSelectedArea(AreaMasterModel? area) {
    _selectedArea = area;

    notifyListeners();
  }

  void updateSelectedDistributory(DistibutoryMasterModel? distributory) {
    _selectedDistributory = distributory;
    notifyListeners();
  }

  Future<void> getAreaList(int? projectId) async {
    try {
      var result = await getAreaMaster(projectId);
      updateArea(result);
    } catch (e) {
      throw Exception('Failed to fetch area list: $e');
    }
  }

  Future<void> getDistributoryList(String? areaId, int? projectId) async {
    try {
      var result = await getDistibutoryMaster(areaId, projectId);
      updateDistributory(result);
    } catch (e) {
      throw Exception('Failed to fetch distributory list: $e');
    }
  }

  Future<void> getLatestVersion(
    BuildContext context, {
    bool isMain = true,
  }) async {
    try {
      var result = await getAppVersion('Mobile');

      if (result?.version == versionNO) {
        if (!isMain) {
          _showResponsiveDialog(
            context,
            title: 'Latest Version',
            content: 'You are using the latest version ${result?.version}',
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        }
      } else {
        await wrongVersion(context);
      }
    } catch (e) {
      // //print("Error during version check: $e");
      await wrongVersion(context);
      throw Exception("Failed to Call API : $e");
    }
  }

  Future<dynamic> wrongVersion(BuildContext context) {
    return _showResponsiveDialog(
      context,
      title: 'Update Available',
      content:
          'A new version of ECM is available.\n\n'
          'Please download the latest version for better performance.',
      actions: [
        TextButton(
          onPressed: () async {
            const url =
                "https://drive.google.com/drive/folders/1j7l1UJLSm3vmSSelRvHFQ_DjMoLEbCNG?usp=drive_link";

            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
            }
          },
          child: const Text('Download'),
        ),
      ],
    );
  }

  /// 🔹 Reusable responsive dialog
  Future<dynamic> _showResponsiveDialog(
    BuildContext context, {
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final maxWidth = isTablet ? 500.0 : size.width * 0.9;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, minWidth: 280),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                content,
                style: TextStyle(fontSize: isTablet ? 18 : 14),
              ),
              actions: actions,
            ),
          ),
        );
      },
    );
  }

  /*Future<void> getLatestVersion(BuildContext context) async {
    try {
      var result = await getAppVersion('Mobile');

      if (result?.version == versionNO) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Your are using the latest version',
              style: TextStyle(
                color: ColorManager.pureWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please download the latest ECM version for better performance ',
              style: TextStyle(
                color: ColorManager.pureWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please download the latest ECM version for better performance ',
            style: TextStyle(
              color: ColorManager.pureWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception("Failed to Call API :$e");
    }
  }
*/

  String? getStateImage(String state) {
    String? imagePath;
    try {
      switch (state.toLowerCase()) {
        case 'madhya pradesh':
          imagePath = 'assets/images/MPlogo.png';
          break;
        case 'odisha':
          imagePath = 'assets/images/odishalogo.png';
          break;
        case 'maharashtra':
          imagePath = 'assets/images/maharastraLogo.png';
          break;
        default:
          imagePath = 'assets/images/SeLogo.png';
      }
    } catch (e) {
      imagePath = 'assets/images/SeLogo.png';
    }

    return imagePath;
  }

  Future<bool> storeDataSharedPreferences(Keys key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final result = await sharedPreferences.setString(key.name, value);
    if (result == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getUserFromSharedPref() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final user = sharedPreferences.getString("user");
      if (user != null) {
        final newUserDetails = UserMasterModel.fromJson(jsonDecode(user));
        _userDetails = newUserDetails;
        _isManager =
            newUserDetails.designation!.toLowerCase().contains('manager') ||
            newUserDetails.designation!.toLowerCase().contains('admin');
        notifyListeners();
      }
    } catch (e) {
      //print(e);
    }
  }

  void getDataFromSharedPreferences(BuildContext context, Keys key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString(key.name) != null && context.mounted) {
      getUserFromSharedPref();
      Navigator.pushReplacementNamed(context, Projectlist.routeName);
    } else {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  Future<void> logout() async {
    _userDetails = null;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    notifyListeners();
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ALERT".tr()),
          backgroundColor: ColorManager.whiteA700,
          content: Text(
            "Do you really want to logout?".tr(),
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () => {
                logout(),
                Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.routeName,
                  (Route<dynamic> route) => false,
                ),
              },
              child: Text("Logout".tr().toUpperCase()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr().toUpperCase()),
            ),
          ],
        );
      },
    );
  }
}
