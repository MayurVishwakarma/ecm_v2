// ignore_for_file: file_names, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers, deprecated_member_use, camel_case_types

import 'package:easy_localization/easy_localization.dart';
import '../../../../../Core/Models/Damage/InfoReportMasterModel.dart';
import '../../../../../Core/Providers/AuthProvider.dart';
import '../../../../../Core/Providers/DamageProvider.dart';
import '../../../../../Utils/Themes/color_manager.dart';
import '../../../../../Widgets/Damage/DamageImagePicker.dart';
import '../../../../../Widgets/POP-Ups/SubmitDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class infoReports extends StatefulWidget {
  const infoReports({super.key});

  @override
  State<infoReports> createState() => _infoReportsState();
}

class _infoReportsState extends State<infoReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = Provider.of<DamageProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final source = dp.source;
      dp.getInfoReport(
        deviceId: dp.getDeviceIdBySource(source),
        source: source!,
        projectId: ap.selectedProject!.id!,
        type: 1,
        langCode: context.locale.languageCode,
      );
      // dp.toggleTranslation(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DamageProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dp.infoReports != null &&
              dp.infoReports!.isNotEmpty &&
              dp.isLoad == false)
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: dp.informationProcess.map((subProcess) {
                        var filteredItems = dp.infoReports!
                            .where(
                              (item) => item.type!.toLowerCase() != 'image',
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
                              subProcess.tr().toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
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
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.2,
                              ),
                            ),
                            collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 1.2,
                              ),
                            ),
                            children: () {
                              Map<int, int> subProcessCounters = {};
                              return filteredItems.map((item) {
                                int? subProcessId;

                                subProcessCounters[subProcessId ?? 0] =
                                    (subProcessCounters[subProcessId] ?? 0) + 1;

                                return buildChecklistItem(
                                  item,
                                  subProcessCounters[subProcessId] ?? 0,
                                  dp.isEdit,
                                );
                              }).toList();
                            }(),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    if (dp.infoReports != null &&
                        dp.infoReports!.isNotEmpty &&
                        dp.infoReports!
                            .where((e) => e.type?.toLowerCase() == 'image')
                            .isNotEmpty)
                      DamageImagePicker(isEdit: dp.isEdit),
                    SizedBox(height: 16),
                    // if (dp.isSubmit(
                    //   ap.isManager,
                    //   p,
                    //   dp.infoReports?.first.approvedStatus,
                    // ))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (dp.infoReports != null &&
                            dp.infoReports!.isNotEmpty)
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: dp.isEdit
                                  ? () async {
                                      await showDamageSubmitDialog(context);
                                    }
                                  : () => showEditSnack(),
                              child: const Text('Submit'),
                            ),
                          ),
                        // if (dp.infoReports != null &&
                        //     dp.infoReports!.isNotEmpty)
                        //   SizedBox(
                        //     height: 50,
                        //     width: 150,
                        //     child: ElevatedButton(
                        //       onPressed: () async {
                        //         await showOfflineSubmitDialog(
                        //           context,
                        //           dp.infoReports!,
                        //         );
                        //       },
                        //       style: ElevatedButton.styleFrom(
                        //         backgroundColor: ColorManager.cantaloupe,
                        //         foregroundColor: ColorManager.pureWhite,
                        //       ),
                        //       child: Text('Save Offline'),
                        //     ),
                        //   ),
                      ],
                    ),

                    /*if (dp.isApproved(
                            ap.isManager,
                            p,
                            dp.infoReports?.first.approvedStatus,
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
                                        dp.infoReports!,
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
                                        dp.infoReports!,
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
                            ),*/
                    if (dp.infoReports
                            ?.where((item) => item.reportedBy != null)
                            .isNotEmpty ??
                        false)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(8.0),
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
                            Text('${'By'.tr()} : ${dp.workedBy ?? ''}'),
                            Text(
                              '${'On'.tr()} : ${dp.getDateFormated(dp.infoReports!.first.reportedOn)}',
                            ),
                            Text(
                              '${'Remarks'.tr()} : ${dp.infoReports!.first.remark ?? ''}',
                            ),
                          ],
                        ),
                      ),
                    /* if (dp.infoReports
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
                                    dp
                                        .approvedTitle(
                                          p,
                                          dp.infoReports?.first.approvedStatus,
                                        )
                                        .tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${'By'.tr()} : ${dp.approvedBy ?? 'Unknown'}',
                                  ),
                                  Text(
                                    '${'On'.tr()} : ${dp.getDateFormated(dp.infoReports!.first.approvedOn)}',
                                  ),
                                  Text(
                                    '${'Remarks'.tr()} : ${dp.infoReports!.first.approvalRemark ?? 'No Remark Available'}',
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 50),*/
                  ],
                ),
              ),
            ),
          if (dp.isLoad)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: ColorManager.ecoGreen),
              ),
            ),
          if (dp.infoReports == null && dp.isLoad == false)
            Center(
              child: Text(
                'No data available for this process',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  void showEditSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Please first enable edit button',
          style: TextStyle(
            color: ColorManager.pureWhite,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildChecklistItem(InfoReportModel item, int index, bool isEdit) {
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
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // ---------- Description ----------
            Expanded(
              flex: 2,
              child: Text(
                item.infoDescription ?? '',
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),

            const SizedBox(width: 20),

            // ---------- Boolean ----------
            Expanded(
              flex: 0,
              child: Checkbox(
                activeColor: Colors.white30,
                checkColor: Colors.red,
                value: item.value == '1',
                onChanged: (isEdit)
                    ? (value) {
                        setState(() {
                          item.value = value! ? '1' : '';
                        });
                      }
                    : (ap.isManager
                          ? (_) => showManagerSnack()
                          : (_) => showEditSnack()), // disable if not edit
              ),
            ),
          ],
        ),
      ),
    );
  }
}
