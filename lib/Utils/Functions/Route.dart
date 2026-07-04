import '../../../Screens/Auth/LoginScreen.dart';
import '../../../Screens/Auth/ProjectList.dart';
import '../../../Screens/Auth/ProjectMenu.dart';
import '../../../Screens/Auth/SplashScreen.dart';
import '../../../Screens/Damage/DamageForm/OfflineDevices/OfflineOMS.dart';
import '../../../Screens/Damage/DamageForm/OfflineReports/OfflineDamageReportManager.dart';
import '../../../Screens/Damage/DamageForm/Reports/DamageManager.dart';
import '../../../Screens/Damage/DamageHistory/Report/DamageHistoryReport.dart';
import '../../../Screens/Damage/DamageHistory/Report/DamageHistoryReportList.dart';
import '../../../Screens/Damage/DamageStatus/Report/DamageStatusReport.dart';
import '../../../Screens/Damage/InformationReport/Reports/InformationReport.dart';
import '../../../Screens/Damage/InformationReport/Reports/InfromationReportList.dart';
import '../../../Screens/Damage/IssueReport/Reports/IssueReportList.dart';
import '../../../Screens/Damage/MaterialConsumption/Report/MaterialDetailReport.dart';
import '../../../Screens/Damage/MaterialConsumption/Report/MaterialReportList.dart';
import '../../../Screens/Damage/RectificationForm/Reports/RectificationReport.dart';
import '../../../Screens/ENC/ECMTabBarPage.dart';
import '../../Screens/ENC/OfflineDevices/Offline_ams.dart';
import '../../Screens/ENC/OfflineDevices/Offline_lora.dart';
import '../../Screens/ENC/OfflineDevices/Offline_oms.dart';
import '../../Screens/ENC/OfflineDevices/Offline_rms.dart';
import '../../../Screens/ENC/Report-History/ReportHistory.dart';
// import '../../../Screens/ENC/Reports/ECMReport.dart';
import '../../../Screens/ENC/Reports/OfflineECMReport.dart';
import '../../../Screens/ENC/Reports/OneECMReport.dart';
import '../../../Screens/RoutineCheck/Reports/RoutineReport.dart';
import '../../../Screens/Setting/Setting.dart';
import '../../../Screens/Setting/Terms&Condition.dart';
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
      // case EcmReports.routeName:
      //   return MaterialPageRoute(builder: (context) => const EcmReports());
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
