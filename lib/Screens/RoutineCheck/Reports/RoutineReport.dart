// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Routine/RoutineReportModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/RoutineProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/CustomCounter.dart';
import 'package:ecm_v2/Widgets/ENC/ViewPDFWidget.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:ecm_v2/Widgets/POP-Ups/SubmitDialog.dart';
import 'package:ecm_v2/Widgets/Routine/RoutineImageDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineReport extends StatefulWidget {
  static const routeName = '/RoutineReport';
  const RoutineReport({super.key});

  @override
  State<RoutineReport> createState() => _RoutineReportState();
}

class _RoutineReportState extends State<RoutineReport> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rp = Provider.of<RoutineProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final source = rp.source;

      rp.getReport(
        deviceId: rp.getDeviceIdBySource(source),
        projectId: ap.selectedProject!.id!,
        langCode: context.locale.languageCode,
      );
      rp.toggleTranslation(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final rp = Provider.of<RoutineProvider>(context);
    final node = rp.selectedNode;
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          '${node?.chakNo} Routine Report',
          ap.selectedProject,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ChangeLanguage(context);
              await rp.toggleTranslation(context.locale.languageCode);
            },
            icon: Icon(Icons.translate_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (rp.routineReport != null &&
              rp.routineReport!.isNotEmpty &&
              rp.isLoad == false)
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: rp.routineProcess!.map((subProcess) {
                        var filteredItems = rp.routineReport!
                            .where(
                              (item) =>
                                  item.processType == subProcess &&
                                  !item.processType!.toLowerCase().contains(
                                    'img'.tr(),
                                  ),
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
                                );
                              }).toList();
                            }(),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    if (rp.routineReport != null &&
                        rp.routineReport!.isNotEmpty &&
                        rp.routineReport!
                            .where(
                              (e) => e.processType?.toLowerCase() == 'image',
                            )
                            .isNotEmpty)
                      RoutineImageDialog(),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (rp.routineReport != null &&
                            rp.routineReport!.isNotEmpty)
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                await showRoutineSubmitDialog(context);
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        /*if (rp.routineReport != null &&
                            rp.routineReport!.isNotEmpty)
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () async {
                                await showOfflineSubmitDialog(
                                  context,
                                  rp.routineReport!,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.cantaloupe,
                                foregroundColor: ColorManager.pureWhite,
                              ),
                              child: Text('Save Offline'),
                            ),
                          ),
                      */
                      ],
                    ),
                    if (rp.routineReport
                            ?.where((item) => item.workedBy != null)
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
                              'Last routine check done'.tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${'By'.tr()} : ${rp.workedBy ?? ''}'),
                            Text(
                              '${'On'.tr()} : ${rp.getShortDateFormated(rp.routineReport!.first.workedOn)}',
                            ),
                            Text(
                              '${'Next Schedule'.tr()} : ${rp.getShortDateFormated(rp.routineReport!.first.nextScheduleDate)}',
                            ),
                            Text(
                              '${'Remarks'.tr()} : ${rp.routineReport!.first.remark ?? ''}',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (rp.isLoad)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: ColorManager.ecoGreen),
              ),
            ),
          if (rp.routineReport == null && rp.isLoad == false)
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

  // void showEditSnack() {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text(
  //         'Please first enable edit button',
  //         style: TextStyle(
  //           color: ColorManager.pureWhite,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       backgroundColor: Colors.red,
  //     ),
  //   );
  // }

  Widget buildChecklistItem(RoutineReportModel item, int index) {
    /*  final ap = Provider.of<AuthProvider>(context, listen: false);
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
*/
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
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
          if (item.inputType == 'text' || item.inputType == 'float')
            Expanded(
              flex: 1,
              child: DecimalNumberPickerField(
                initialValue: item.value,

                suffix: item.inputType,
                onChanged: (val) {
                  setState(() => item.value = val);
                },
              ),
            ),

          // ---------- Boolean ----------
          if (item.inputType == 'boolean')
            Expanded(
              flex: 0,
              child: Checkbox(
                activeColor: Colors.white30,
                checkColor: Colors.red,
                value: item.value == 'OK',
                onChanged: (value) {
                  setState(() {
                    item.value = value! ? 'OK' : '';
                  });
                },
              ),
            ),

          // ---------- PDF ----------
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

          // ---------- JSON ----------
          if (item.inputType == 'json')
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Image.asset("assets/images/pdf.png", cacheHeight: 25),
                onPressed: () {
                  // _handleJsonDialog(item);
                },
              ),
            ),
        ],
      ),
    );
  }
}
