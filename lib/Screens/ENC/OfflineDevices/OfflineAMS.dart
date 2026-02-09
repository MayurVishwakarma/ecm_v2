// ignore_for_file: strict_top_level_inference

import '../../../Core/Database/DBHelper.dart';
import '../../../Core/Models/EcmNodeMasterModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Utils/Themes/color_manager.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/ENC/NodeTableWidgetOffline.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineAms extends StatefulWidget {
  static const String routeName = '/offlineAms';
  const OfflineAms({super.key});

  @override
  State<OfflineAms> createState() => _OfflineAmsState();
}

class _OfflineAmsState extends State<OfflineAms> {
  List<EcmNodeListMasterModel>? ecmNodes;

  @override
  void initState() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    getEcmNodes(projectId: ap.selectedProject!.id!);
    super.initState();
  }

  Future<void> getEcmNodes({
    required int projectId,
    String deviceType = 'AMS',
  }) async {
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
        title: customECMAppbar(context, 'Offline-AMS', ap.selectedProject),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ep.processList != null && ep.processList!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: {
                    0: FixedColumnWidth(130), // Chak No. column fixed width
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: ColorManager.ecoGreen),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'Chak NO.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(Distri-Area)',
                                style: TextStyle(
                                  color: Colors.white,
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
                                  process.processName!,
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
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
