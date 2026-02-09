// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import '../../../../Core/Providers/AuthProvider.dart';
import '../../../../Core/Providers/DamageProvider.dart';
import '../../../../Widgets/CustomAppBar.dart';
import '../../../../Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InformationHistoryReport extends StatefulWidget {
  static const routeName = "/InformationHistoryReport";
  const InformationHistoryReport({super.key});

  @override
  State<InformationHistoryReport> createState() =>
      _InformationHistoryReportState();
}

class _InformationHistoryReportState extends State<InformationHistoryReport> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final dp = Provider.of<DamageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          '${dp.getNodeName(dp.source!, dp.selectedNode!)} ${'History'.tr()} ${'Report'.tr()}',
          ap.selectedProject,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ChangeLanguage(context);
            },
            icon: const Icon(Icons.translate_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            if (dp.informationHistoryReport?.informationList != null)
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
                      'Information'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    Text(
                      "${dp.informationHistoryReport!.informationList?.replaceAll(',', '\n')}",
                    ),
                  ],
                ),
              ),

            if (dp.informationHistoryReport?.informationList == null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF4FAD55)),
                  color: Color(0xFF4FAD55).withOpacity(0.1),
                ),
                child: Center(child: Text('No Damage Reported'.tr())),
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
                    '${'By'.tr()} : ${dp.informationHistoryReport?.username ?? '-'}',
                  ),
                  Text(
                    '${'On'.tr()} : ${dp.getDateFormated(dp.informationHistoryReport?.reportedOn)}',
                  ),
                  Text(
                    '${'Remarks'.tr()} : ${dp.informationHistoryReport?.remark ?? ''}',
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
