// import '../../../../Core/Providers/AuthProvider.dart';
// import '../../../../Widgets/CustomAppBar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MaterialManager extends StatefulWidget {
//   const MaterialManager({super.key});

//   @override
//   State<MaterialManager> createState() => _MaterialManagerState();
// }

// class _MaterialManagerState extends State<MaterialManager> {
//   @override
//   Widget build(BuildContext context) {
//     final ap = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: customECMAppbar(
//           context,
//           "Material Consumption",
//           ap.selectedProject,
//         ),
//       ),
//       body: Center(
//         child: Text("Selected Project: ${ap.selectedProject?.projectName}"),
//       ),
//     );
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import '../../../../Core/Providers/AuthProvider.dart';
import '../../../../Core/Providers/DamageProvider.dart';
import '../../../../Screens/Damage/MaterialConsumption/Devices/OMS.dart';
import '../../../../Screens/Damage/MaterialConsumption/Devices/AMS.dart';
import '../../../../Screens/Damage/MaterialConsumption/Devices/RMS.dart';
import '../../../../Screens/Damage/MaterialConsumption/Devices/LORA.dart';
import '../../../../Widgets/CustomAppBar.dart';
import '../../../../Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MaterialManager extends StatefulWidget {
  const MaterialManager({super.key});

  @override
  State<MaterialManager> createState() => _MaterialManagerState();
}

class _MaterialManagerState extends State<MaterialManager> {
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

    final pages = [OmsDamage(), AMSMaterial(), RmsMaterial(), LoRamaterial()];
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

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final dp = Provider.of<DamageProvider>(context, listen: false);
    return DefaultTabController(
      length: _tabViews.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: _tabs,
            onTap: (index) {
              dp.updateSource(_tabNamesNew[index]);
            },
          ),
          title: customECMAppbar(
            context,
            "Material Consumption".tr(),
            ap.selectedProject,
          ),
          actions: [
            IconButton(
              onPressed: () {
                ChangeLanguage(context);
              },
              icon: const Icon(Icons.translate_outlined),
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
