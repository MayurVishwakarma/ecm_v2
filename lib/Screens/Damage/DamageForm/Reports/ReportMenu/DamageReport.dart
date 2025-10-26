// ignore_for_file: file_names, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageReportModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ConnectivityProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/Damage/DamageImagePicker.dart';
import 'package:ecm_v2/Widgets/POP-Ups/SubmitDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DamageReports extends StatefulWidget {
  const DamageReports({super.key});

  @override
  State<DamageReports> createState() => _DamageReportsState();
}

class _DamageReportsState extends State<DamageReports> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = Provider.of<DamageProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final source = dp.source;
      dp.updateSelectedMenu('Damage Form');
      dp.getDamageReport(
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
          if (dp.damageReport != null &&
              dp.damageReport!.isNotEmpty &&
              dp.isLoad == false)
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: dp.damageProcess.map((subProcess) {
                        var filteredItems = dp.damageReport!
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
                    if (dp.damageReport != null &&
                        dp.damageReport!.isNotEmpty &&
                        dp.damageReport!
                            .where((e) => e.type?.toLowerCase() == 'image')
                            .isNotEmpty)
                      DamageImagePicker(isEdit: dp.isEdit),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (dp.damageReport != null &&
                            dp.damageReport!.isNotEmpty &&
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
                        if (dp.damageReport != null &&
                            dp.damageReport!.isNotEmpty &&
                            !cp.isOnline)
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                await showOfflineDamageSubmitDialog(
                                  context,
                                  dp.damageReport!,
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
                    if (dp.damageReport
                            ?.where((item) => item.userId != null)
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
                              '${'On'.tr()} : ${dp.getDateFormated(dp.damageReport!.first.datetime)}',
                            ),
                            Text(
                              '${'Remarks'.tr()} : ${dp.damageReport!.first.remark ?? ''}',
                            ),
                          ],
                        ),
                      ),
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
          if (dp.damageReport == null && dp.isLoad == false)
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

  Widget buildChecklistItem(DamageReportModel item, int index, bool isEdit) {
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
                item.damage ?? '',
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),

            const SizedBox(width: 20),

            /*
            // ---------- Image ----------
            if (item.value == '1' || item.value == 'Yes')
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    final size = MediaQuery.of(context).size;
                    final double dialogSize =
                        size.width * 0.6; // Bigger on wide screens

                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        insetPadding: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 🔹 Top bar with close button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${item.damage}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // 🔹 Image area
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: dialogSize,
                                  maxHeight: dialogSize,
                                ),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      if (item.imageByteArray != null) {
                                        ImageDialogs.showPreviewAlert(
                                          context: context,
                                          model: item,
                                          isEdit: true,
                                          onRefresh: () => setState(() {}),
                                        );
                                      } else {
                                        ImageDialogs.showUploadAlert(
                                          context: context,
                                          imageItem: item,
                                          onRefresh: () => setState(() {}),
                                        );
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: item.imageByteArray != null
                                          ? Hero(
                                              tag:
                                                  "damage_${item.id}", // smooth animation
                                              child: Image.memory(
                                                item.imageByteArray!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(
                                              color: Colors.grey[200],
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.upload_file,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    "Tap to Upload",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),

                              // const SizedBox(height: 16),

                              // // 🔹 Action buttons (optional)
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              //   children: [
                              //     TextButton.icon(
                              //       icon: const Icon(
                              //         Icons.photo,
                              //         color: Colors.blue,
                              //       ),
                              //       label: const Text("Gallery"),
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //         ImageDialogs.showUploadAlert(
                              //           context: context,
                              //           imageItem: item,
                              //           onRefresh: () => setState(() {}),
                              //         );
                              //       },
                              //     ),
                              //     TextButton.icon(
                              //       icon: const Icon(
                              //         Icons.camera_alt,
                              //         color: Colors.green,
                              //       ),
                              //       label: const Text("Camera"),
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //         ImageDialogs.showUploadAlert(
                              //           context: context,
                              //           imageItem: item,
                              //           onRefresh: () => setState(() {}),
                              //         );
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            */
            // ---------- Boolean ----------
            if (item.inputType?.toLowerCase() == 'boolean')
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
                            if (!value) {
                              item.imagePath = null;
                              item.imageByteArray = null;
                              item.image = null;
                            }
                          });
                        }
                      : (ap.isManager
                            ? (_) => showManagerSnack()
                            : (_) => showEditSnack()), // disable if not edit
                ),
              ),
            // ---------- Yes/No ----------
            if (item.inputType?.toLowerCase() == 'bool')
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Yes',
                          groupValue: item.value,
                          onChanged: (isEdit)
                              ? (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      item.value = newValue;
                                    });
                                  }
                                }
                              : (ap.isManager
                                    ? (_) => showManagerSnack()
                                    : (_) => showEditSnack()),
                        ),
                        Text('Yes'),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'No',
                          groupValue: item.value,
                          activeColor: Colors.red,
                          onChanged: (isEdit)
                              ? (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      item.value = newValue;
                                    });
                                  }
                                }
                              : (ap.isManager
                                    ? (_) => showManagerSnack()
                                    : (_) => showEditSnack()),
                        ),
                        Text('No'),
                      ],
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
