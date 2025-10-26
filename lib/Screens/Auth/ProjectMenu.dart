// ignore_for_file: unnecessary_underscores

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/Drawer.dart';
import 'package:ecm_v2/Widgets/MenuTileWidget.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectMenu extends StatefulWidget {
  static const routeName = "/projectMenu";
  const ProjectMenu({super.key});

  @override
  State<ProjectMenu> createState() => _ProjectMenuState();
}

class _ProjectMenuState extends State<ProjectMenu> {
  @override
  initState() {
    super.initState();
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.getAreaList(ap.selectedProject!.id);
    ap.getDistributoryList('all', ap.selectedProject!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (_, ap, __) =>
              customECMAppbar(context, 'Project Menu'.tr(), ap.selectedProject),
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
      drawer: const AppDrawer(),
      body: Consumer<AuthProvider>(
        builder: (_, ap, __) {
          final project = ap.selectedProject;
          final menuTabs = ap.menutabs;

          if (project == null) {
            return const Center(
              child: Text(
                'No project selected',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: menuTabs.length,
            itemBuilder: (_, index) {
              return MenuTileWidget(menuItem: menuTabs[index]);
            },
          );
        },
      ),
    );
  }
}
/*
class ProjectMenu extends StatelessWidget {
  static const routeName = "/projectMenu";
  const ProjectMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customAppbar(context, 'Project Menu', ap.selectedProject),
      ),
      drawer: const AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (ap.selectedProject != null)
            ...ap.menutabs.map((menuItem) {
              return MenuTileWidget(menuItem: menuItem);
            })
          else
            const Center(child: Text('No project selected')),
        ],
      ),
    );
  }
}
*/