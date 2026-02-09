import 'package:easy_localization/easy_localization.dart';
import '../../../../Core/Providers/AuthProvider.dart';
import '../../../../Core/Providers/DamageProvider.dart';
import '../../../../Screens/Damage/MaterialConsumption/Report/MaterialDetailReport.dart';
import '../../../../Utils/Themes/color_manager.dart';
import '../../../../Widgets/CustomAppBar.dart';
import '../../../../Widgets/Damage/MaterialHistoryTileWidget.dart';
import '../../../../Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialReportList extends StatefulWidget {
  static const routeName = '/MaterialReportList';
  const MaterialReportList({super.key});

  @override
  State<MaterialReportList> createState() => _MaterialReportListState();
}

class _MaterialReportListState extends State<MaterialReportList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dp = Provider.of<DamageProvider>(context, listen: false);
      final ap = Provider.of<AuthProvider>(context, listen: false);
      final source = dp.source;

      dp.getMaterialHistory(
        deviceId: dp.getMaterialDeviceIdBySource(source),
        source: source!,
        projectId: ap.selectedProject!.id!,
      );
      dp.toggleTranslation(context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final dp = Provider.of<DamageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          '${dp.getNodeName(dp.source!, dp.selectedMaterialNode!)} Material History',
          ap.selectedProject,
        ),
        actions: [
          IconButton(
            onPressed: () {
              ChangeLanguage(context);
            },
            icon: Icon(Icons.translate_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          if (dp.source != 'LORA')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${dp.selectedMaterialNode?.areaName}"),
                      Text("${dp.selectedMaterialNode?.description}"),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          if (dp.materialHistory != null &&
              dp.materialHistory!.isNotEmpty &&
              dp.isLoad == false)
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: ListView.builder(
                  itemCount: dp.materialHistory?.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = dp.materialHistory?[index];
                    return InkWell(
                      onTap: () {
                        dp.updateMaterialHistoryReport(item);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          MaterialHistoryReport.routeName,
                          (route) => true,
                        );
                      },
                      child: MatrialHistoryTile(item: item),
                    );
                  },
                ),
              ),
            ),
          if (dp.isLoad)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(color: ColorManager.ecoGreen),
              ),
            ),
          if (dp.materialHistory == null && dp.isLoad == false)
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
}
