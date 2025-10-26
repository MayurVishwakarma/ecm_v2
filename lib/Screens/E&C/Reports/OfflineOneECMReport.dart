// ignore_for_file: file_names, use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/ECMReportModel.dart';
import 'package:ecm_v2/Core/Models/ProcessMasterModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/ExpandableTiles.dart';
import 'package:ecm_v2/Widgets/E&C/EcmImagePicker.dart';
import 'package:ecm_v2/Widgets/POP-Ups/SubmitDialog.dart';
import 'package:ecm_v2/Widgets/E&C/ViewPDFWidget.dart';
import 'package:flutter/material.dart';
import 'package:ecm_v2/Core/Database/DBHelper.dart';
import 'package:provider/provider.dart';

class OfflineOneECMReport extends StatefulWidget {
  static const routeName = "/OfflineOneECMReports";
  const OfflineOneECMReport({super.key});

  @override
  State<OfflineOneECMReport> createState() => _OfflineOneECMReportState();
}

class _OfflineOneECMReportState extends State<OfflineOneECMReport> {
  List<ProcessMasterModel> process = [];
  List<EcmReportMasterModel> report = [];
  Set<String> subProcessNames = {};
  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    final ep = Provider.of<ProjectProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final result = await ProcessDB.instance.fetchByDevice(
      ep.source!,
      ap.selectedProject!.id!,
    );
    final reportResult = await ECMReportDB.instance.fetchEMCReport(
      ep.getDeviceIdBySource(ep.source!),
      result.where((e) => e.processId != 0).first.processId!,
      ep.source!,
      ap.selectedProject!.id!,
    );
    setState(() {
      process = result;
      report = reportResult;
      subProcessNames = reportResult
          .map((e) => e.subProcessName)
          .where((name) => name != null)
          .cast<String>()
          .toSet();
    });
  }

  void getReportByProcessId(
    int deviceId,
    processId,
    String deviceType,
    int projectId,
  ) async {
    final result = await ECMReportDB.instance.fetchEMCReport(
      deviceId,
      processId,
      deviceType,
      projectId,
    );
    setState(() {
      report = result;
      subProcessNames = result
          .map((e) => e.subProcessName)
          .where((name) => name != null)
          .cast<String>()
          .toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<ProjectProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    return DefaultTabController(
      length: process.where((device) => device.processId != 0).length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Offline ECM Report'),
          bottom: TabBar(
            indicatorColor: ColorManager.ecoGreen,
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: false,
            physics: NeverScrollableScrollPhysics(),
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorManager.ecoGreen, width: 2.5),
              ),
            ),
            tabs: process
                .where((e) => e.processId != 0)
                .map(
                  (e) => FittedBox(
                    child: Text(
                      e.processName!.replaceAll(' ', '\n'),
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
            onTap: (index) async {
              ep.updateSelectedReportProcess(
                process.where((p) => p.processId != 0).toList()[index],
              );
              getReportByProcessId(
                ep.getDeviceIdBySource(ep.source!),
                ep.selectedReportProcess!.processId!,
                ep.source!,
                ap.selectedProject!.id!,
              );
            },
          ),
          /*actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  ep.deleteReport(report, ap.selectedProject!.id!);
                  getReportByProcessId(
                    ep.getDeviceIdBySource(ep.source!),
                    ep.selectedReportProcess!.processId!,
                    ep.source!,
                    ap.selectedProject!.id!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Record deleted'),
                      backgroundColor: ColorManager.hotCoral,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete All'),
              ),
            ),
          ],*/
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: process.where((p) => p.processId != 0).map((p) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (report.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (subProcessNames.isNotEmpty)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: subProcessNames.map((subProcess) {
                                var filteredItems = report
                                    .where(
                                      (item) =>
                                          item.subProcessName == subProcess &&
                                          item.inputType != 'image',
                                    )
                                    .toList();
                                if (filteredItems.isEmpty) {
                                  return SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 5,
                                  ),
                                  child: ExpandableTile(
                                    title: Text(
                                      subProcess.toUpperCase(),
                                      softWrap: true,
                                    ),
                                    body: Column(
                                      children: () {
                                        Map<int, int> subProcessCounters = {};
                                        return filteredItems.map((item) {
                                          int? subProcessId;
                                          if (item.isBullet != 1) {
                                            subProcessId = item.subProcessId;
                                          }

                                          subProcessCounters[subProcessId ??
                                                  0] =
                                              (subProcessCounters[subProcessId] ??
                                                  0) +
                                              1;

                                          return _buildChecklistItem(
                                            item,
                                            subProcessCounters[subProcessId] ??
                                                0,
                                          );
                                        }).toList();
                                      }(),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          SizedBox(height: 16),
                          if (report.isNotEmpty)
                            EcmImagePicker(
                              // items: ep.checklistModel!
                              //     .where(
                              //       (item) =>
                              //           item.processId ==
                              //               ep
                              //                   .selectedReportProcess
                              //                   ?.processId &&
                              //           item.inputType == 'image',
                              //     )
                              //     .toList(),
                              isEdit: ep.isEdit(
                                ap.isManager,
                                ep.selectedReportProcess?.processName,
                                ep.checklistModel!.first.approvedStatus,
                              ),
                            ),
                          SizedBox(height: 16),
                          if (report.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await showSubmitDialog(context, report);
                                      await ep.deleteReport(
                                        report,
                                        ap.selectedProject!.id!,
                                      );
                                      await ep.deleteNode(
                                        ep.getDeviceIdBySource(ep.source!),
                                        ep.source!,
                                        ap.selectedProject!.id!,
                                      );
                                      getReportByProcessId(
                                        ep.getDeviceIdBySource(ep.source!),
                                        p.processId!,
                                        ep.source!,
                                        ap.selectedProject!.id!,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorManager.cantaloupe,
                                    ),
                                    child: const Text('Sync with server'),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      bool? confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Delete Confirmation',
                                            ),
                                            content: const Text(
                                              'Are you sure you want to delete this report?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.red, // Text color
                                                ),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (confirm == true) {
                                        await ep.deleteReport(
                                          report,
                                          ap.selectedProject!.id!,
                                        );
                                        await ep.deleteNode(
                                          ep.getDeviceIdBySource(ep.source!),
                                          ep.source!,
                                          ap.selectedProject!.id!,
                                        );

                                        getReportByProcessId(
                                          ep.getDeviceIdBySource(ep.source!),
                                          p.processId!,
                                          ep.source!,
                                          ap.selectedProject!.id!,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ),
                              ],
                            ),
                          if (report
                              .where((item) => item.workedOn != null)
                              .isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Submitted',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('By : ${report.first.workedBy}'),
                                  Text(
                                    'On : ${ep.getDateFormated(report.first.workedOn)}',
                                  ),
                                  Text(
                                    'Remarks : ${report.first.remark ?? ''}',
                                  ),
                                ],
                              ),
                            ),
                          if (report
                              .where((item) => item.approvedBy != null)
                              .isNotEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Approved',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('By : ${report.first.approvedBy}'),
                                  Text(
                                    'On : ${ep.getDateFormated(report.first.approvedOn)}',
                                  ),
                                  Text(
                                    'Remarks : ${report.first.approvalRemark ?? 'No Remark Available'}',
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                if (report.isEmpty)
                  Expanded(
                    child: Center(child: Text('No report available'.tr())),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  bool isEdit(AuthProvider ap, ProcessMasterModel p, int status) {
    return !ap.isManager &&
        ((!p.processName!.toLowerCase().contains('dry comm'))
            ? (status == 3 ? false : true)
            : (status == 2 ? false : true));
  }

  Widget _buildChecklistItem(EcmReportMasterModel item, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (item.isBullet != 1)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$index .",
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          if (item.isBullet == 1)
            Row(
              children: [
                SizedBox(width: 25),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.circle, size: 8, color: Colors.black),
                ),
              ],
            ),
          Expanded(
            flex: 2,
            child: Text(
              item.description!,
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 20),
          if ((item.inputType == 'text' || item.inputType == 'float') &&
              item.isBulletHeader != 1)
            Expanded(
              flex: 1,
              child: TextFormField(
                // enabled: isEdit(),
                initialValue: item.value,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.blue),
                  ),
                  suffixText: item.inputText?.isNotEmpty == true
                      ? item.inputText
                      : '',
                ),
                onChanged: (value) {
                  setState(() {
                    item.value = value;
                  });
                },
              ),
            ),
          if (item.inputType == 'boolean')
            Expanded(
              flex: 0,
              child: Checkbox(
                activeColor: Colors.white54,
                checkColor: Colors.green,
                value: item.value == 'OK',
                onChanged: /* isEdit()
                    ?*/ (value) {
                  setState(() {
                    item.value = value! ? 'OK' : '';
                  });
                },
                // : null,
              ),
            ),

          if (item.inputType == 'pdf')
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Image.asset("assets/images/pdf.png", cacheHeight: 25),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PdfWidget(report: item);
                    },
                  );
                },
              ),
            ),
          if (item.inputType == 'json')
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Image.asset(
                  "assets/images/pdf.png",
                  // height: 10,
                  cacheHeight: 25,
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PdfWidget(report: item);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
