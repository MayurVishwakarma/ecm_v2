// ignore_for_file: deprecated_member_use

import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Screens/Maintainance/DisnetScreen.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MaintenanceTool extends StatefulWidget {
  const MaintenanceTool({super.key});

  @override
  State<MaintenanceTool> createState() => _MaintenanceToolState();
}

class _MaintenanceToolState extends State<MaintenanceTool> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(context, 'Maintenance Tool', ap.selectedProject),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              elevation: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: ListTile(
                  leading: Image.asset('assets/images/global-network.png'),
                  title: Text(
                    'Disnet',
                    style: theme
                        .textTheme
                        .bodyLarge, // uses ThemeManager text styles
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisnetScreen()),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
              elevation: 5,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: ListTile(
                  leading: Image.asset('assets/images/pump.png'),
                  title: Text(
                    'Pumping Station & BPT',
                    style: theme
                        .textTheme
                        .bodyLarge, // uses ThemeManager text styles
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.info,
                      text: 'Page Under Construction',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
