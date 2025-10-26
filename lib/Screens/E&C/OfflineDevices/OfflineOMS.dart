import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Database/DBHelper.dart';
import 'package:ecm_v2/Core/Models/EcmNodeMasterModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/E&C/NodeTableWidgetOffline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineOms extends StatefulWidget {
  static const String routeName = '/offlineOms';
  const OfflineOms({super.key});

  @override
  State<OfflineOms> createState() => _OfflineOmsState();
}

class _OfflineOmsState extends State<OfflineOms> {
  List<EcmNodeListMasterModel>? ecmNodes;
  TextEditingController searchController = TextEditingController();
  String? searchQuery;

  @override
  void initState() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    getEcmNodes(projectId: ap.selectedProject!.id!);
    super.initState();
  }

  getEcmNodes({required int projectId, String deviceType = 'OMS'}) async {
    var result = await NodeDB.instance.fetchNodeByDeviceType(
      deviceType,
      projectId,
    );
    // var result = await NodeDB.instance.fetchAll();
    setState(() {
      ecmNodes = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final ep = Provider.of<ProjectProvider>(context);

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
                      getEcmNodes(projectId: ap.selectedProject!.id!);
                      return;
                    }
                    ecmNodes = ecmNodes!
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
                  labelText: 'Search by Chak No.'.tr(),
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

            if (ep.processList != null && ep.processList!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Table(
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: {
                    0: FixedColumnWidth(130), // Chak No. column fixed width
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: ColorManager.ecoGreen,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(Distri-Area)'.tr(),
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (var process in ep.processList!.where(
                          (e) => e.processId != 0,
                        ))
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              child: Text(
                                ep.ConvertLongtoShortString(
                                  process.processName!.tr(),
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: context.locale.languageCode != 'en'
                                      ? 12
                                      : 10,
                                  fontWeight: FontWeight.w500,
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
                child: NodeTableWidgetOffline(
                  projectProvider: ep,
                  nodes: ecmNodes!,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () async {
                  NodeDB.instance.deleteNode();
                  getEcmNodes(
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
