// ignore_for_file: unnecessary_underscores

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/MenuTileWidget.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DamageMenuPage extends StatefulWidget {
  const DamageMenuPage({super.key});

  @override
  State<DamageMenuPage> createState() => _DamageMenuPageState();
}

class _DamageMenuPageState extends State<DamageMenuPage> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(
          context,
          'Damage/Rectification'.tr(),
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
      body: Consumer<AuthProvider>(
        builder: (_, ap, __) {
          final project = ap.selectedProject;
          final menuTabs = ap.damagetabs;

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
