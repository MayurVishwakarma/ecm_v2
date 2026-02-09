// ignore_for_file: file_names, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously, prefer_final_fields, no_leading_underscores_for_local_identifiers, deprecated_member_use, unnecessary_null_comparison

import 'package:easy_localization/easy_localization.dart';
import '../../../../../Core/Database/DamageDBHelper.dart';
import '../../../../../Core/Models/Damage/DamageReportModel.dart';
import '../../../../../Core/Providers/AuthProvider.dart';
import '../../../../../Core/Providers/DamageProvider.dart';
import '../../../../../Utils/Themes/color_manager.dart';
import '../../../../../Widgets/Damage/DamageImagePicker.dart';
import '../../../../../Widgets/POP-Ups/SubmitDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineDamageReport extends StatefulWidget {
  const OfflineDamageReport({super.key});

  @override
  State<OfflineDamageReport> createState() => _DamageReportsState();
}

class _DamageReportsState extends State<OfflineDamageReport> {
  List<DamageReportModel> report = [];
  // Set<String> subProcessNames = {};
  @override
  void initState() {
    super.initState();

    loadData();
  }

  void loadData() async {
    final dp = Provider.of<DamageProvider>(context, listen: false);
    final ap = Provider.of<AuthProvider>(context, listen: false);

    final reportResult = await DamageReportDB.instance.fetchDamageReport(
      dp.getDeviceIdBySource(dp.source!),
      dp.source!,
      ap.selectedProject!.id!,
    );
    setState(() {
      report = reportResult;
    });
  }

  void getReportByProcessId(
    int deviceId,
    String deviceType,
    int projectId,
  ) async {
    final result = await DamageReportDB.instance.fetchDamageReport(
      deviceId,
      deviceType,
      projectId,
    );
    setState(() {
      report = result;
    });
  }

  /*@override
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
*/
  @override
  Widget build(BuildContext context) {
    final dp = Provider.of<DamageProvider>(context);
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (report.isNotEmpty && dp.isLoad == false)
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: dp.damageProcess.map((subProcess) {
                        var filteredItems = report
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
                    if (report.isNotEmpty &&
                        report
                            .where((e) => e.type?.toLowerCase() == 'image')
                            .isNotEmpty)
                      DamageImagePicker(isEdit: false),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: dp.isEdit
                                ? () async {
                                    await showDamageSubmitDialog(context);
                                    await dp.deleteReport(
                                      report,
                                      ap.selectedProject!.id!,
                                      dp.source!,
                                    );
                                    await dp.deleteNode(
                                      dp.getDeviceIdBySource(dp.source!),
                                      dp.source!,
                                      ap.selectedProject!.id!,
                                    );
                                    getReportByProcessId(
                                      dp.getDeviceIdBySource(dp.source!),
                                      dp.source!,
                                      ap.selectedProject!.id!,
                                    );
                                  }
                                : () => showEditSnack(),
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
                                    title: const Text('Delete Confirmation'),
                                    content: const Text(
                                      'Are you sure you want to delete this report?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
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
                                await dp.deleteReport(
                                  report,
                                  ap.selectedProject!.id!,
                                  dp.source!,
                                );
                                await dp.deleteNode(
                                  dp.getDeviceIdBySource(dp.source!),
                                  dp.source!,
                                  ap.selectedProject!.id!,
                                );

                                getReportByProcessId(
                                  dp.getDeviceIdBySource(dp.source!),
                                  dp.source!,
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
                    if (report.where((item) => item.userId != null).isNotEmpty)
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
                              '${'On'.tr()} : ${dp.getDateFormated(report.first.datetime)}',
                            ),
                            Text(
                              '${'Remarks'.tr()} : ${report.first.remark ?? ''}',
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
          if (report == null && dp.isLoad == false)
            Center(
              child: Text(
                'No data available for this process',
                style: TextStyle(fontSize: 16),
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

            // ---------- Image ----------
            /*            if (item.value == '1')
              Expanded(
                flex: 0,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {
                    const double imageSize = 50;

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(8),
                        content: ListTile(
                          trailing: SizedBox(
                            width: imageSize,
                            height: imageSize,
                            child: item.imageByteArray != null
                                ? InkWell(
                                    // onTap: () => _previewAlert(item),
                                    child: Image.memory(
                                      item.imageByteArray!,
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : InkWell(
                                    // onTap: () => _uploadAlert(item),
                                    child: Image.asset(
                                      'assets/images/upload-image.png',
                                      width: imageSize,
                                      height: imageSize,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.damage ?? '',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (item.imageByteArray != null)
                                Text(
                                  "Size: ${(item.imageByteArray!.lengthInBytes / 1024).toStringAsFixed(2)} KB",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
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
