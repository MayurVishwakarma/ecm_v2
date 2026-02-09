// ignore_for_file: file_names, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/ECMReportModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Screens/ENC/Report-History/ReportHistory.dart';
import '../../../Utils/Themes/color_manager.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/ENC/EcmImagePicker.dart';
import '../../../Widgets/POP-Ups/ChangeLanguage.dart';
import '../../../Widgets/POP-Ups/SubmitDialog.dart';
import '../../../Widgets/ENC/ViewPDFWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EcmReports extends StatefulWidget {
  static const routeName = "/EcmReports";
  const EcmReports({super.key});

  @override
  State<EcmReports> createState() => _EcmReportsState();
}

class _EcmReportsState extends State<EcmReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ep = Provider.of<ProjectProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final source = ep.source;
      final processes =
          ep.processList?.where((e) => e.processId != 0).toList() ?? [];
      ep.updateSelectedReportProcess(processes.first);
      ep.getECMReport(
        deviceId: ep.getDeviceIdBySource(source),
        processId: processes.first.processId!,
        source: source ?? 'OMS',
        projectId: ap.selectedProject!.id!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final ep = Provider.of<ProjectProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    final processes =
        ep.processList?.where((e) => e.processId != 0).toList() ?? [];
    return DefaultTabController(
      length: processes.length,
      child: Scaffold(
        appBar: AppBar(
          title: customECMAppbar(
            context,
            '${ep.getNodeName(ep.source!, ep.selectedNode!)} ${'Report'.tr()}',
            ap.selectedProject,
          ),
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
            tabs: processes
                .map(
                  (e) => FittedBox(
                    child: Text(
                      e.processName!.tr().replaceAll(' ', '\n'),
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
              ep.updateChecklistModel([]);
              ep.updateSelectedReportProcess(processes[index]);
              ep.getECMReport(
                deviceId: ep.selectedNode!.omsId!,
                processId: processes[index].processId!,
                source: ep.source!,
                projectId: ap.selectedProject!.id!,
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                ChangeLanguage(context);
              },
              icon: Icon(Icons.translate_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ReportHistory.routeName,
                  (route) => true,
                );
              },
              icon: const Icon(Icons.info, color: ColorManager.hotCoral),
            ),
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: processes.map((p) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ep.checklistModel != null &&
                    ep.checklistModel!.isNotEmpty &&
                    ep.isLoad == false)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if (ep.subProcessName != null)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: ep.subProcessName!.map((subProcess) {
                                var filteredItems = ep.checklistModel!
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
                                  child: ExpansionTile(
                                    title: Text(
                                      subProcess.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.15),
                                    collapsedBackgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 1.2,
                                      ),
                                    ),
                                    collapsedShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 1.2,
                                      ),
                                    ),
                                    children: () {
                                      Map<int, int> subProcessCounters = {};
                                      return filteredItems.map((item) {
                                        int? subProcessId;
                                        if (item.isBullet != 1) {
                                          subProcessId = item.subProcessId;
                                        }

                                        subProcessCounters[subProcessId ?? 0] =
                                            (subProcessCounters[subProcessId] ??
                                                0) +
                                            1;

                                        return buildChecklistItem(
                                          item,
                                          subProcessCounters[subProcessId] ?? 0,
                                          ep.isEdit(
                                            ap.isManager,
                                            p.processName,
                                            item.approvedStatus,
                                          ),
                                        );
                                      }).toList();
                                    }(),
                                  ),
                                  /*ExpandableTile(
                                    title: Text(
                                      subProcess.toUpperCase(),
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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

                                          return Column(
                                            children: [
                                              buildChecklistItem(
                                                item,
                                                subProcessCounters[subProcessId] ??
                                                    0,
                                                isEdit(
                                                  ap,
                                                  p,
                                                  item.approvedStatus,
                                                ),
                                              ),
                                              Divider(thickness: 2),
                                            ],
                                          );
                                        }).toList();
                                      }(),
                                    ),
                                  ),*/
                                );
                              }).toList(),
                            ),
                          SizedBox(height: 16),
                          if (ep.checklistModel != null &&
                              ep.checklistModel!.isNotEmpty &&
                              ep.checklistModel!
                                  .where((e) => e.inputType == 'image')
                                  .isNotEmpty)
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
                          if (ep.isSubmit(
                            ap.isManager,
                            p.processName,
                            ep.checklistModel?.first.approvedStatus,
                          ))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (ep.checklistModel != null &&
                                    ep.checklistModel!.isNotEmpty)
                                  SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showSubmitDialog(
                                          context,
                                          ep.checklistModel!,
                                        );
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ),
                                if (ep.checklistModel != null &&
                                    ep.checklistModel!.isNotEmpty)
                                  SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await showOfflineSubmitDialog(
                                          context,
                                          ep.checklistModel!,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorManager.cantaloupe,
                                        foregroundColor: ColorManager.pureWhite,
                                      ),
                                      child: Text('Save Offline'),
                                    ),
                                  ),
                              ],
                            ),
                          if (ep.isApproved(
                            ap.isManager,
                            p.processName,
                            ep.checklistModel?.first.approvedStatus,
                          ))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await showApproveDialog(
                                        context,
                                        ep.checklistModel!,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorManager.ecoGreen,
                                      foregroundColor: ColorManager.pureWhite,
                                    ),
                                    child: Text('Approve'.tr()),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await showCommentDialog(
                                        context,
                                        ep.checklistModel!,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorManager.cantaloupe,
                                      foregroundColor: ColorManager.pureWhite,
                                    ),
                                    child: Text('Comment'.tr()),
                                  ),
                                ),
                              ],
                            ),

                          if (ep.checklistModel
                                  ?.where((item) => item.workedOn != null)
                                  .isNotEmpty ??
                              false)
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
                                    'Submitted'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('${'By'.tr()} : ${ep.workedBy ?? ''}'),
                                  Text(
                                    '${'On'.tr()} : ${ep.getDateFormated(ep.checklistModel!.first.workedOn)}',
                                  ),
                                  Text(
                                    '${'Remarks'.tr()} : ${ep.checklistModel!.first.remark ?? ''}',
                                  ),
                                ],
                              ),
                            ),
                          if (ep.checklistModel
                                  ?.where((item) => item.approvedBy != null)
                                  .isNotEmpty ??
                              false)
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
                                    ep
                                        .approvedTitle(
                                          p.processName,
                                          ep
                                              .checklistModel
                                              ?.first
                                              .approvedStatus,
                                        )
                                        .tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${'By'.tr()} : ${ep.approvedBy ?? 'Unknown'}',
                                  ),
                                  Text(
                                    '${'On'.tr()} : ${ep.getDateFormated(ep.checklistModel!.first.approvedOn)}',
                                  ),
                                  Text(
                                    '${'Remarks'.tr()} : ${ep.checklistModel!.first.approvalRemark ?? 'No Remark Available'}',
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                if (ep.isLoad)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.ecoGreen,
                      ),
                    ),
                  ),
                if (ep.checklistModel == null && ep.isLoad == false)
                  Center(
                    child: Text(
                      'No data available for this process',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildChecklistItem(EcmReportMasterModel item, int index, bool isEdit) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    void showManagerSnack() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Managers are not allowed to change the report.',
            style: TextStyle(
              color: ColorManager.pureWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: ColorManager.hotCoral,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (item.isBullet != 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("$index ."),
              ),
            if (item.isBullet == 1)
              Row(
                children: const [
                  SizedBox(width: 30),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.circle, size: 8, color: Colors.black),
                  ),
                ],
              ),

            // ---------- Description ----------
            Expanded(
              flex: 2,
              child: Text(
                item.description ?? '',
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),

            const SizedBox(width: 20),

            // ---------- Text/Float ----------
            if ((item.inputType == 'text' || item.inputType == 'float') &&
                item.isBulletHeader != 1)
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    if (!isEdit && ap.isManager) {
                      showManagerSnack();
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: !isEdit, // disable input
                    child: TextFormField(
                      enabled: isEdit,
                      initialValue: item.value,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.blue),
                        ),
                        suffixText: item.inputText?.isNotEmpty == true
                            ? item.inputText
                            : '',
                      ),
                      onChanged: (value) {
                        setState(() => item.value = value);
                      },
                    ),
                  ),
                ),
              ),

            // ---------- Boolean ----------
            if (item.inputType == 'boolean')
              Expanded(
                flex: 0,
                child: Checkbox(
                  activeColor: Colors.greenAccent.shade200,
                  checkColor: Colors.green.shade900,
                  value: item.value == 'OK',
                  onChanged: (isEdit)
                      ? (value) {
                          setState(() {
                            item.value = value! ? 'OK' : '';
                          });
                        }
                      : (ap.isManager
                            ? (_) => showManagerSnack()
                            : null), // disable if not edit
                ),
              ),

            // ---------- PDF ----------
            if (item.inputType == 'pdf')
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: Image.asset("assets/images/pdf.png", cacheHeight: 25),
                  onPressed: () async {
                    if (!isEdit && ap.isManager) {
                      showManagerSnack();
                      return;
                    }
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PdfWidget(report: item);
                      },
                    );
                  },
                ),
              ),

            // ---------- JSON ----------
            if (item.inputType == 'json')
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: Image.asset("assets/images/pdf.png", cacheHeight: 25),
                  onPressed: () {
                    if (!isEdit && ap.isManager) {
                      showManagerSnack();
                      return;
                    }
                    // _handleJsonDialog(item);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
