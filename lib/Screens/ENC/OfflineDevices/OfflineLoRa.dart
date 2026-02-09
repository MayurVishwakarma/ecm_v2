import 'package:ecm_v2/Core/Database/DBHelper.dart';
import 'package:ecm_v2/Core/Models/EcmNodeMasterModel.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import '../../../Widgets/ENC/NodeTableWidgetOffline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineLoRa extends StatefulWidget {
  static const String routeName = '/offlineLoRa';
  const OfflineLoRa({super.key});


  @override
  State<OfflineLoRa> createState() => _OfflineLoRaState();
}

class _OfflineLoRaState extends State<OfflineLoRa> {
  List<EcmNodeListMasterModel>? ecmNodes;

  @override
  void initState() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    getEcmNodes(projectId: ap.selectedProject!.id!);
    super.initState();
  }

  Future<void> getEcmNodes({
    required int projectId,
    String deviceType = 'LORA',
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
        title: customECMAppbar(context, 'Offline-LORA', ap.selectedProject),
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
                                'Gateway Name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(Gateway No.)',
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
                    deviceType: 'LORA',
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
