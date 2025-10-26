import 'package:ecm_v2/Screens/Auth/LoginScreen.dart';
import 'package:ecm_v2/Screens/Auth/ProjectList.dart';
import 'package:ecm_v2/Screens/Auth/ProjectMenu.dart';
import 'package:ecm_v2/Screens/Auth/SplashScreen.dart';
import 'package:ecm_v2/Screens/Damage/DamageForm/OfflineDevices/OfflineOMS.dart';
import 'package:ecm_v2/Screens/Damage/DamageForm/OfflineReports/OfflineDamageReportManager.dart';
import 'package:ecm_v2/Screens/Damage/DamageForm/Reports/DamageManager.dart';
import 'package:ecm_v2/Screens/Damage/DamageHistory/Report/DamageHistoryReport.dart';
import 'package:ecm_v2/Screens/Damage/DamageHistory/Report/DamageHistoryReportList.dart';
import 'package:ecm_v2/Screens/Damage/DamageStatus/Report/DamageStatusReport.dart';
import 'package:ecm_v2/Screens/Damage/InformationReport/Reports/InformationReport.dart';
import 'package:ecm_v2/Screens/Damage/InformationReport/Reports/InfromationReportList.dart';
import 'package:ecm_v2/Screens/Damage/IssueReport/Reports/IssueReportList.dart';
import 'package:ecm_v2/Screens/Damage/MaterialConsumption/Report/MaterialDetailReport.dart';
import 'package:ecm_v2/Screens/Damage/MaterialConsumption/Report/MaterialReportList.dart';
import 'package:ecm_v2/Screens/Damage/RectificationForm/Reports/RectificationReport.dart';
import 'package:ecm_v2/Screens/E&C/ECMTabBarPage.dart';
import 'package:ecm_v2/Screens/E&C/OfflineDevices/OfflineAMS.dart';
import 'package:ecm_v2/Screens/E&C/OfflineDevices/OfflineLoRa.dart';
import 'package:ecm_v2/Screens/E&C/OfflineDevices/OfflineOMS.dart';
import 'package:ecm_v2/Screens/E&C/OfflineDevices/OfflineRMS.dart';
import 'package:ecm_v2/Screens/E&C/Report-History/ReportHistory.dart';
import 'package:ecm_v2/Screens/E&C/Reports/ECMReport.dart';
import 'package:ecm_v2/Screens/E&C/Reports/OfflineECMReport.dart';
import 'package:ecm_v2/Screens/E&C/Reports/OneECMReport.dart';
import 'package:ecm_v2/Screens/RoutineCheck/Reports/RoutineReport.dart';
import 'package:ecm_v2/Screens/Setting/Setting.dart';
import 'package:ecm_v2/Screens/Setting/Terms&Condition.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const Splashscreen());
      case Projectlist.routeName:
        return MaterialPageRoute(builder: (context) => const Projectlist());
      case ProjectMenu.routeName:
        return MaterialPageRoute(builder: (context) => const ProjectMenu());
      case EcmToolScreen.routeName:
        return MaterialPageRoute(builder: (context) => EcmToolScreen());
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case EcmReports.routeName:
        return MaterialPageRoute(builder: (context) => const EcmReports());
      case Setting.routeName:
        return MaterialPageRoute(builder: (context) => const Setting());
      case TermsAndConditionsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => const TermsAndConditionsPage(),
        );
      case OfflineECMReport.routeName:
        return MaterialPageRoute(
          builder: (context) => const OfflineECMReport(),
        );
      case OfflineOms.routeName:
        return MaterialPageRoute(builder: (context) => const OfflineOms());
      case OfflineAms.routeName:
        return MaterialPageRoute(builder: (context) => const OfflineAms());
      case OfflineRms.routeName:
        return MaterialPageRoute(builder: (context) => const OfflineRms());
      case OfflineLoRa.routeName:
        return MaterialPageRoute(builder: (context) => const OfflineLoRa());
      case ReportHistory.routeName:
        return MaterialPageRoute(builder: (context) => const ReportHistory());
      case OneEcmReports.routeName:
        return MaterialPageRoute(builder: (context) => const OneEcmReports());
      case DamageManager.routeName:
        return MaterialPageRoute(builder: (context) => const DamageManager());
      case DamageStatusReport.routeName:
        return MaterialPageRoute(
          builder: (context) => const DamageStatusReport(),
        );
      case DamageNodeHistory.routeName:
        return MaterialPageRoute(
          builder: (context) => const DamageNodeHistory(),
        );
      case DamageHistoryReport.routeName:
        return MaterialPageRoute(
          builder: (context) => const DamageHistoryReport(),
        );
      case MaterialReportList.routeName:
        return MaterialPageRoute(
          builder: (context) => const MaterialReportList(),
        );
      case MaterialHistoryReport.routeName:
        return MaterialPageRoute(
          builder: (context) => const MaterialHistoryReport(),
        );
      case RoutineReport.routeName:
        return MaterialPageRoute(builder: (context) => const RoutineReport());
      case OfflineDamageOms.routeName:
        return MaterialPageRoute(
          builder: (context) => const OfflineDamageOms(),
        );
      case OfflineDamageManager.routeName:
        return MaterialPageRoute(
          builder: (context) => const OfflineDamageManager(),
        );
      case InformationNodeHistory.routeName:
        return MaterialPageRoute(
          builder: (context) => const InformationNodeHistory(),
        );
      case InformationHistoryReport.routeName:
        return MaterialPageRoute(
          builder: (context) => const InformationHistoryReport(),
        );
      case IssueNodeHistory.routeName:
        return MaterialPageRoute(
          builder: (context) => const IssueNodeHistory(),
        );
      case RectificationReport.routeName:
        return MaterialPageRoute(
          builder: (context) => const RectificationReport(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(
            child: Text(
              'page not found!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
