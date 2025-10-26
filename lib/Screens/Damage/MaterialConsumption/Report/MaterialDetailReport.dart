// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialHistoryReport extends StatefulWidget {
  static const routeName = "/MaterialHistoryReport";
  const MaterialHistoryReport({super.key});

  @override
  State<MaterialHistoryReport> createState() => _MaterialHistoryReportState();
}

class _MaterialHistoryReportState extends State<MaterialHistoryReport> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final dp = Provider.of<DamageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          '${dp.getNodeName(dp.source!, dp.selectedMaterialNode!)} ${'History'.tr()} ${'Report'.tr()}',
          ap.selectedProject,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ChangeLanguage(context);
            },
            icon: Icon(Icons.translate_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (dp.materialHistoryReport?.electRectifyList != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF4FAD55)),
                  color: Color(0xFF4FAD55).withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Electrical'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text(
                      "${dp.materialHistoryReport!.electRectifyList?.replaceAll(',', '\n')}",
                    ),
                  ],
                ),
              ),
            if (dp.materialHistoryReport?.mechRectifyList != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFFFA722)),
                  color: Color(0xFFFFA722).withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mechanical'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text(
                      "${dp.materialHistoryReport!.mechRectifyList?.replaceAll(',', '\n')}",
                    ),
                  ],
                ),
              ),
            if (dp.materialHistoryReport?.tubRectifyList != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFFFA722)),
                  color: Color(0xFFFFA722).withOpacity(0.1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tubing'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text(
                      "${dp.materialHistoryReport!.tubRectifyList?.replaceAll(',', '\n')}",
                    ),
                  ],
                ),
              ),

            if (dp.materialHistoryReport?.mechRectifyList == null &&
                dp.materialHistoryReport?.electRectifyList == null &&
                dp.materialHistoryReport?.tubRectifyList == null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF4FAD55)),
                  color: Color(0xFF4FAD55).withOpacity(0.1),
                ),
                child: Center(child: Text('No Damage Reported')),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Submitted'.tr(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${'By'.tr()} : ${dp.materialHistoryReport?.username ?? '-'}',
                  ),
                  Text(
                    '${'On'.tr()} : ${dp.getDateFormated(dp.materialHistoryReport?.reportedOn)}',
                  ),
                  Text(
                    '${'Remarks'.tr()} : ${dp.materialHistoryReport?.remark ?? ''}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
