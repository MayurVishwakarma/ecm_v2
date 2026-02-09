// ignore_for_file: file_names, deprecated_member_use

import '../../../Core/Providers/DamageProvider.dart';
import '../../../Screens/Damage/DamageForm/Reports/DamageManager.dart';
import 'package:flutter/material.dart';

class NodeTableWidget extends StatelessWidget {
  const NodeTableWidget({super.key, required this.dp});

  final DamageProvider dp;
  // Widget buildRowCell(
  //     BuildContext context,
  //     DamageProvider provider,
  //     dynamic item,
  //     Widget child,
  //   ) {
  //     return GestureDetector(
  //       onTap: () {
  //         provider.updateSelectedNode(item);
  //         Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           DamageManager.routeName,
  //           (route) => true,
  //         );
  //       },
  //       child: Padding(padding: const EdgeInsets.all(8.0), child: child),
  //     );
  //   }

  Widget _buildRowCell(
    BuildContext context,
    DamageProvider provider,
    dynamic item,
    Widget child,
  ) {
    return GestureDetector(
      onTap: () {
        provider.updateSelectedNode(item);
        Navigator.pushNamedAndRemoveUntil(
          context,
          DamageManager.routeName,
          (route) => true,
        );
      },
      child: Padding(padding: const EdgeInsets.all(8.0), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.grey.shade300),
        // columnWidths: {
        //   0: FixedColumnWidth(130), // Chak No. column fixed width
        //   1: FixedColumnWidth(150),
        //   2: FixedColumnWidth(150),
        // },
        children: [
          ...(dp.nodeList ?? []).map((item) {
            return TableRow(
              decoration: BoxDecoration(
                color: item.isSaved == 1
                    ? Colors.lightGreen.withOpacity(0.3)
                    : null,
                // border: Border.all(color: Colors.grey.shade300),
              ),
              children: [
                // Wrap first cell
                _buildRowCell(
                  context,
                  dp,
                  item,
                  Column(
                    children: [
                      Text(
                        dp.getNodeName(dp.source!, item).trim(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      if (dp.source != 'LORA')
                        Text(
                          "(${item.areaName} - ${item.description})",
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      if (dp.source == 'LORA')
                        Text(
                          "(${item.gatewayNo?.trim()})",
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
                // Other process cells
                _buildRowCell(
                  context,
                  dp,
                  item,
                  dp.getDamageStatusBar('Electronical', (item.electrical ?? 0)),
                ),
                _buildRowCell(
                  context,
                  dp,
                  item,
                  dp.getDamageStatusBar('Mechanical', (item.mechanical ?? 0)),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
