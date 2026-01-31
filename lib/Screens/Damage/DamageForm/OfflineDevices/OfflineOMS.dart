// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Database/DamageDBHelper.dart';
import 'package:ecm_v2/Core/Models/Damage/DamageNodeMasterModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/DamageProvider.dart';
import 'package:ecm_v2/Screens/Damage/DamageForm/OfflineReports/OfflineDamageReportManager.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/TableRowBuilder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineDamageOms extends StatefulWidget {
  static const String routeName = '/offlineDamageOms';
  const OfflineDamageOms({super.key});

  @override
  State<OfflineDamageOms> createState() => _OfflineOmsState();
}

class _OfflineOmsState extends State<OfflineDamageOms> {
  List<DamageNodeModel>? nodes;
  TextEditingController searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    getDamageNodes(projectId: ap.selectedProject!.id!);
    super.initState();
  }

  bool electricalAsc = true; // sorting flag for Electrical
  bool mechanicalAsc = true; // sorting flag for Mechanical
  String? _sortColumn;

  void sortByElectrical() {
    setState(() {
      electricalAsc = !electricalAsc;
      _sortColumn = "electrical";
      nodes?.sort((a, b) {
        final aVal = int.tryParse(a.electrical.toString()) ?? 0;
        final bVal = int.tryParse(b.electrical.toString()) ?? 0;
        return electricalAsc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
  }

  void sortByMechanical() {
    setState(() {
      mechanicalAsc = !mechanicalAsc;
      _sortColumn = "mechanical";
      nodes?.sort((a, b) {
        final aVal = int.tryParse(a.mechanical.toString()) ?? 0;
        final bVal = int.tryParse(b.mechanical.toString()) ?? 0;
        return mechanicalAsc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
      });
    });
  }

  Future<void> getDamageNodes({required int projectId, String deviceType = 'OMS'}) async {
    var result = await DamageNodeDB.instance.fetchNodeByDeviceType(
      deviceType,
      projectId,
    );
    // var result = await DamageNodeDB.instance.fetchAll();
    setState(() {
      nodes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final dp = Provider.of<DamageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(context, 'Offline-OMS', ap.selectedProject),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      getDamageNodes(projectId: ap.selectedProject!.id!);
                      return;
                    }
                    nodes = nodes!
                        .where(
                          (node) => node.chakNo!.toLowerCase().contains(
                            value.toLowerCase(),
                          ),
                        )
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  isDense: true,
                  labelText: 'Search by Chak No.',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  suffixIcon: Icon(Icons.search, size: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                // columnWidths: {
                //   0: FixedColumnWidth(130), // Chak No. column fixed width
                //   1: FixedColumnWidth(150), // Chak No. column fixed width
                //   2: FixedColumnWidth(150), // Chak No. column fixed width
                // },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      // color: ColorManager.ecoGreen,
                      // border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'ChakNo'.tr(),
                              style: TextStyle(
                                // color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            /*Text(
                                  '(Distri-Area)'.tr(),
                                  style: TextStyle(
                                    // color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              */
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => sortByElectrical(),
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Electrical".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  if (_sortColumn == "electrical")
                                    Icon(
                                      electricalAsc
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: 16,
                                    )
                                  else
                                    Icon(
                                      Icons.sort_rounded,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                  // Icon(
                                  //   electricalAsc
                                  //       ? Icons.arrow_upward_rounded
                                  //       : Icons.arrow_downward_rounded,
                                  //   size: 18,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => sortByMechanical(),
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mechanical".tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  if (_sortColumn == "mechanical")
                                    Icon(
                                      mechanicalAsc
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: 16,
                                    )
                                  else
                                    Icon(
                                      Icons.sort_rounded,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: Colors.grey.shade300),

                    children: [
                      ...(nodes?.where(
                                (e) => (e.chakNo ?? '').contains(
                                  searchQuery ?? '',
                                ),
                              ) ??
                              [])
                          .map((item) {
                            return TableRow(
                              decoration: BoxDecoration(
                                color: item.isSaved == 1
                                    ? Colors.lightGreen.withOpacity(0.3)
                                    : null,
                                // border: Border.all(color: Colors.grey.shade300),
                              ),
                              children: [
                                // Wrap first cell
                                TableRowBuild(
                                  child: Column(
                                    children: [
                                      Text(
                                        dp.getNodeName(dp.source!, item).trim(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      if (dp.source != 'LORA')
                                        Text(
                                          "(${item.areaName} - ${item.description})",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.blue,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      if (dp.source == 'LORA')
                                        Text(
                                          "(${item.gatewayNo?.trim()})",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.blue,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                    ],
                                  ),
                                  onTap: () {
                                    dp.updateSelectedNode(item);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      OfflineDamageManager.routeName,
                                      (route) => true,
                                    );
                                  },
                                ),
                                TableRowBuild(
                                  child: dp.getDamageStatusBar(
                                    'Electronical',
                                    (int.tryParse(item.electrical.toString()) ??
                                        0),
                                  ),
                                  onTap: () {
                                    dp.updateSelectedNode(item);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      OfflineDamageManager.routeName,
                                      (route) => true,
                                    );
                                  },
                                ),
                                TableRowBuild(
                                  child: dp.getDamageStatusBar(
                                    'Mechanical',
                                    (int.tryParse(item.mechanical.toString()) ??
                                        0),
                                  ),
                                  onTap: () {
                                    dp.updateSelectedNode(item);
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      OfflineDamageManager.routeName,
                                      (route) => true,
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () async {
                  DamageNodeDB.instance.deleteNode();
                  getDamageNodes(
                    projectId: ap.selectedProject!.id!,
                    deviceType: 'OMS',
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.hotCoral,
                ),
                child: Text('Delete Nodes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
