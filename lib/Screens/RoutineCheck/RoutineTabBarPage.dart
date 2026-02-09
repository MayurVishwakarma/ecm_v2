import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/RoutineProvider.dart';
import '../../../Screens/RoutineCheck/Devices/AMS.dart';
import '../../../Screens/RoutineCheck/Devices/LORA.dart';
import '../../../Screens/RoutineCheck/Devices/OMS.dart';
import '../../../Screens/RoutineCheck/Devices/RMS.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoutineTool extends StatefulWidget {
  const RoutineTool({super.key});

  @override
  State<RoutineTool> createState() => _RoutineToolState();
}

class _RoutineToolState extends State<RoutineTool> {
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

    final pages = [OmsRoutine(), AmsRoutine(), RmsRoutine(), LoRaRoutine()];
    final tabNames = ["OMS".tr(), "AMS".tr(), "RMS".tr(), "LORA".tr()];

    _tabs = [];
    _tabViews = [];
    _tabNamesNew = [];

    final positions = <int>[];
    final rcString = ap.selectedProject?.rcString ?? "";

    for (int i = 0; i < rcString.length; i++) {
      if (rcString[i] == '1' && i < tabNames.length && i < pages.length) {
        positions.add(i);
        _tabs.add(Tab(text: tabNames[i]));
        _tabNamesNew.add(tabNames[i]);
        _tabViews.add(pages[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final rp = Provider.of<RoutineProvider>(context);
    return DefaultTabController(
      length: _tabViews.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _tabs,
            onTap: (index) {
              rp.updateSource(_tabNamesNew[index]);
            },
          ),

          title: customECMAppbar(context, 'Routine Check', ap.selectedProject),
          actions: [
            IconButton(
              onPressed: () {
                ChangeLanguage(context);
              },
              icon: Icon(Icons.translate_outlined),
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
