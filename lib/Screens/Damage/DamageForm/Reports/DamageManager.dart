// ignore_for_file: file_names, use_build_context_synchronously, deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import '../../../../Core/Providers/AuthProvider.dart';
import '../../../../Core/Providers/DamageProvider.dart';
import '../../../../Screens/Damage/DamageForm/Reports/ReportMenu/DamageReport.dart';
import '../../../../Screens/Damage/DamageForm/Reports/ReportMenu/InformationReport.dart';
import '../../../../Screens/Damage/DamageForm/Reports/ReportMenu/IssueReport.dart';
import '../../../../Screens/Damage/DamageForm/Reports/ReportMenu/MaterialReport.dart';
import '../../../../Utils/Themes/color_manager.dart';
import '../../../../Widgets/CustomAppBar.dart';
import '../../../../Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DamageManager extends StatefulWidget {
  static const routeName = "/DamageManager";
  const DamageManager({super.key});

  @override
  State<DamageManager> createState() => _DamageManagerState();
}

class _DamageManagerState extends State<DamageManager> {
  late List<Widget> _tabs;
  late List<Widget> _tabViews;
  late List<String> _tabNamesNew;

  @override
  void initState() {
    super.initState();
    _initTabs();
  }

  void _initTabs() {
    final pages = [
      DamageReports(),
      MaterialReports(),
      infoReports(),
      issueReports(),
    ];
    final tabNames = [
      "Damage Form".tr(),
      "Material Consumption".tr(),
      "Information".tr(),
      "Issue".tr(),
    ];

    _tabs = [];
    _tabViews = [];
    _tabNamesNew = [];

    final positions = <int>[];
    final ecString = '1111';

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
    return DefaultTabController(
      length: _tabViews.length,
      child: Consumer2<AuthProvider, DamageProvider>(
        builder: (context, ap, dp, child) => Scaffold(
          appBar: AppBar(
            title: customECMAppbar(
              context,
              '${dp.getNodeName(dp.source!, dp.selectedNode!)} ${'Report'.tr()}',
              ap.selectedProject,
            ),
            bottom: TabBar(
              indicatorColor: ColorManager.ecoGreen,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: false,
              physics: NeverScrollableScrollPhysics(),
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: ColorManager.ecoGreen, width: 2.5),
                ),
              ),
              tabs: dp.damageMenus
                  .map(
                    (e) => FittedBox(
                      child: Text(
                        e.tr().replaceAll(' ', '\n'),
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onTap: (index) async {
                dp.updateSelectedMenu(dp.damageMenus[index]);
              },
            ),
            actions: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = MediaQuery.of(context).size.width > 600;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isTablet) // Show text only on bigger screens
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Text(
                            'Edit:',
                            style: TextStyle(fontSize: isTablet ? 16 : 12),
                          ),
                        ),

                      Switch(
                        value: dp.isEdit,

                        onChanged: (value) {
                          dp.updateIsEdit(value);
                        },
                        activeColor: Colors.blue.shade900,
                        inactiveThumbColor: Colors.red,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashRadius: 8,
                        thumbIcon: MaterialStateProperty.all(
                          Icon(dp.isEdit ? Icons.check : Icons.close),
                        ),
                      ),

                      IconButton(
                        tooltip: "Change Language",
                        onPressed: () async {
                          await ChangeLanguage(context);
                          await dp.toggleTranslation(
                            context.locale.languageCode,
                          );
                        },
                        icon: Icon(
                          Icons.translate_outlined,
                          size: isTablet ? 28 : 22,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],

            /*actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text('Edit:', style: TextStyle(fontSize: 16)),
                    Switch(
                      value: dp.isEdit,
                      onChanged: (value) {
                        dp.updateIsEdit(value);
                      },
                      activeColor: Colors.blue.shade900,
                      inactiveThumbColor: Colors.red,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  await ChangeLanguage(context);
                  await dp.toggleTranslation(context.locale.languageCode);
                },
                icon: Icon(Icons.translate_outlined),
              ),
            ],*/
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: _tabViews,
          ),
        ),
      ),
    );
  }
}
