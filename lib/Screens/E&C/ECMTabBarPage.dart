import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/E&C/EcmStatusCountDailog.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Devices/AMS.dart';
import 'Devices/LoRa.dart';
import 'Devices/OMS.dart';
import 'Devices/RMS.dart';

class EcmToolScreen extends StatefulWidget {
  static const routeName = "/EcmToolScreen";
  const EcmToolScreen({super.key});

  @override
  State<EcmToolScreen> createState() => _EcmToolScreenState();
}

class _EcmToolScreenState extends State<EcmToolScreen> {
  late List<Widget> _tabs;
  late List<Widget> _tabViews;
  late List<String> _tabNamesNew;

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  void _initTabs() {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    final pages = [OmsPage(), AmsPage(), RmsPage(), LoraPage()];
    final tabNames = ["OMS".tr(), "AMS".tr(), "RMS".tr(), "LORA".tr()];

    _tabs = [];
    _tabViews = [];
    _tabNamesNew = [];

    final positions = <int>[];
    final ecString = ap.selectedProject?.ecString ?? "";

    for (int i = 0; i < ecString.length; i++) {
      if (ecString[i] == '1' && i < tabNames.length && i < pages.length) {
        positions.add(i);
        _tabs.add(Tab(text: tabNames[i]));
        _tabNamesNew.add(tabNames[i]);
        _tabViews.add(pages[i]);
      }
    }
  }

  Future<void> showStatusCount() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final pp = Provider.of<ProjectProvider>(context, listen: false);
    pp.updateEcmStatusCount(null);

    await pp.getEcmStatusCount(
      projectId: int.tryParse(ap.selectedProject!.id.toString()),
      area: (ap.selectedArea?.areaId).toString(),
      distributory: (ap.selectedDistributory?.id).toString(),
      process: 'all',
      subProcess: 'all',
      source: pp.source ?? 'OMS', // <-- Use currently selected source
    );

    if (!mounted) return;

    await showDialog(context: context, builder: (_) => EcmStatusCountDialog());
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final pp = Provider.of<ProjectProvider>(context, listen: false);
    return DefaultTabController(
      length: _tabViews.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _tabs,
            onTap: (index) {
              pp.updateSource(_tabNamesNew[index]);
            },
          ),
          title: customECMAppbar(context, 'ECM Tool'.tr(), ap.selectedProject),
          actions: [
            IconButton(
              onPressed: () {
                ChangeLanguage(context);
              },
              icon: const Icon(Icons.translate_outlined),
            ),
            IconButton(
              onPressed: showStatusCount,
              icon: Icon(Icons.info, color: ColorManager.hotCoral),
            ),
          ],
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _tabViews,
        ),
      ),
    );
  }
}
