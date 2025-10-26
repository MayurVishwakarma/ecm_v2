// ignore_for_file: file_names, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Damage/MaterialReportModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ConnectivityProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomCounterNumbers.dart';
import 'package:ecm_v2/Widgets/Damage/DamageImagePicker.dart';
import 'package:ecm_v2/Widgets/POP-Ups/SubmitDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialReports extends StatefulWidget {
  const MaterialReports({super.key});

  @override
  State<MaterialReports> createState() => _MaterialReportsState();
}

class _MaterialReportsState extends State<MaterialReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = Provider.of<DamageProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final source = dp.source;
      dp.getMaterialReport(
        deviceId: dp.getDeviceIdBySource(source),
        source: source!,
        projectId: ap.selectedProject!.id!,
        langCode: context.locale.languageCode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DamageProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    final cp = Provider.of<ConnectivityProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dp.materialReport != null &&
              dp.materialReport!.isNotEmpty &&
              dp.isLoad == false)
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: dp.materialProcess.map((subProcess) {
                        var filteredItems = dp.materialReport!
                            .where(
                              (item) =>
                                  item.type == subProcess &&
                                  item.type!.toLowerCase() != 'image',
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
                    if (dp.materialReport != null &&
                        dp.materialReport!.isNotEmpty &&
                        dp.materialReport!
                            .where((e) => e.type?.toLowerCase() == 'image')
                            .isNotEmpty)
                      DamageImagePicker(isEdit: dp.isEdit),
                    SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (dp.materialReport != null &&
                            dp.materialReport!.isNotEmpty &&
                            cp.isOnline)
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: dp.isEdit
                                  ? () async {
                                      await showDamageSubmitDialog(context);
                                    }
                                  : () => showEditSnack(),
                              child: Text('Submit'.tr()),
                            ),
                          ),
                        if (dp.materialReport != null &&
                            dp.materialReport!.isNotEmpty &&
                            !cp.isOnline)
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                await showOfflineMaterialSubmitDialog(
                                  context,
                                  // dp.materialReport!,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.cantaloupe,
                                foregroundColor: ColorManager.pureWhite,
                              ),
                              child: Text('Save Offline'.tr()),
                            ),
                          ),
                      ],
                    ),
                    /*if (dp.isApproved(
                            ap.isManager,
                            p,
                            dp.materialReport?.first.approvedStatus,
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
                                        dp.materialReport!,
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
                                        dp.materialReport!,
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
*/
                    if (dp.materialReport
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
                              '${'On'.tr()} : ${dp.getDateFormated(dp.materialReport!.first.reportedOn)}',
                            ),
                            Text(
                              '${'Remarks'.tr()} : ${dp.materialReport!.first.remark ?? ''}',
                            ),
                          ],
                        ),
                      ),
                    /*  if (dp.materialReport
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
                                          dp.materialReport?.first.approvedStatus,
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
                                    '${'On'.tr()} : ${dp.getDateFormated(dp.materialReport!.first.approvedOn)}',
                                  ),
                                  Text(
                                    '${'Remarks'.tr()} : ${dp.materialReport!.first.approvalRemark ?? 'No Remark Available'}',
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
          if (dp.materialReport == null && dp.isLoad == false)
            Center(
              child: Text(
                'No data available for this process',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          if (cp.isOnline == false)
            Container(
              width: double.infinity,
              color: ColorManager.cantaloupe,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'You are offline. Some functionalities may be limited.'.tr(),
                style: TextStyle(
                  color: ColorManager.pureWhite,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
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

  Widget buildChecklistItem(MaterialReportModel item, int index, bool isEdit) {
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
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // ---------- Description ----------
            Expanded(
              flex: 2,
              child: Text(
                item.rectification ?? '',
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),

            const SizedBox(width: 20),

            // ---------- Boolean ----------
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => !isEdit
                    ? showEditSnack()
                    : ap.isManager
                    ? showManagerSnack()
                    : showEditSnack(),
                child: NumberPickerField(
                  initialValue: item.value,
                  isEdit: isEdit,
                  onChanged: (value) {
                    setState(() => item.value = value);
                  },
                ),
              ),
            ),
            /* Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if (!isEdit) {
                    ap.isManager ? showManagerSnack() : showEditSnack();
                  }
                  // if (!isEdit && ap.isManager) {
                  //   showManagerSnack();
                  // }
                },
                child: AbsorbPointer(
                  absorbing: !isEdit, // disable input
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: isEdit,

                      initialValue: item.value,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.green),
                        ),
                      ),
                      onChanged: isEdit
                          ? (value) {
                              setState(() => item.value = value);
                            }
                          : null,
                    ),
                  ),
                ),
              ),
            ),
         */
          ],
        ),
      ),
    );
  }

}
