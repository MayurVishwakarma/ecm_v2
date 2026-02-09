import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Screens/ENC/Reports/OfflineECMReport.dart';
import 'package:flutter/material.dart';

class NodeTableWidgetOffline extends StatelessWidget {
  const NodeTableWidgetOffline({
    super.key,
    required this.projectProvider,
    required this.nodes,
  });

  final ProjectProvider projectProvider;
  final List<dynamic> nodes;

  Widget _buildRowCell(
    BuildContext context,
    ProjectProvider provider,
    dynamic item,
    Widget child,
  ) {
    return GestureDetector(
      onTap: () {
        provider.updateSelectedNode(item);
        Navigator.pushNamedAndRemoveUntil(
          context,
          OfflineECMReport.routeName,
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
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: {
          0: FixedColumnWidth(130), // Chak No. column fixed width
        },
        children: [
          ...(() {
            final sortedNodes = nodes.toList();
            sortedNodes.sort((a, b) {
              return b.isSaved?.compareTo(a.isSaved ?? 0) ?? 0;
            });
            return sortedNodes.map((item) {
              return TableRow(
                decoration: BoxDecoration(
                  color: (item.isSaved == 1)
                      ? Colors.blue
                      : Theme.of(context).cardColor,
                ),
                children: [
                  // Wrap first cell
                  _buildRowCell(
                    context,
                    projectProvider,
                    item,
                    Column(
                      children: [
                        Text(
                          projectProvider
                              .getNodeName(projectProvider.source!, item)
                              .trim(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                        if (projectProvider.source != 'LORA')
                          Text(
                            "(${item.areaName} - ${item.description})",
                            style: TextStyle(
                              fontSize: 10,
                              color: item.isSaved != 1
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (projectProvider.source == 'LORA')
                          Text(
                            "(${item.gatewayNo?.trim()})",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),

                  // Other process cells
                  ...projectProvider.processList!
                      .where((e) => e.processId != 0)
                      .map((process) {
                        return _buildRowCell(
                          context,
                          projectProvider,
                          item,
                          projectProvider.getProcessStatusBar(
                            process.processName!,
                            projectProvider.getProStatus(
                              process.processName!,
                              item,
                            ),
                          ),
                        );
                      }),
                ],
              );
            });
          })(),
        ],
      ),
    );
    /*Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        columnWidths: {
          0: FixedColumnWidth(130), // Chak No. column fixed width
        },
        children: [
          ...nodes.map((item) {
            return TableRow(
              decoration: BoxDecoration(
                color: (item.isSaved == 1)
                    ? Colors.blue
                    : Theme.of(context).cardColor,
              ),
              children: [
                // Wrap first cell
                _buildRowCell(
                  context,
                  projectProvider,
                  item,
                  Column(
                    children: [
                      Text(
                        projectProvider
                            .getNodeName(projectProvider.source!, item)
                            .trim(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      if (projectProvider.source != 'LORA')
                        Text(
                          "(${item.areaName} - ${item.description})",
                          style: TextStyle(
                            fontSize: 10,
                            color: item.isSaved != 1
                                ? Colors.blue
                                : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (projectProvider.source == 'LORA')
                        Text(
                          "(${item.gatewayNo?.trim()})",
                          style: TextStyle(fontSize: 10, color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),

                // Other process cells
                ...projectProvider.processList!
                    .where((e) => e.processId != 0)
                    .map((process) {
                      return _buildRowCell(
                        context,
                        projectProvider,
                        item,
                        projectProvider.getProcessStatusBar(
                          process.processName!,
                          projectProvider.getProStatus(
                            process.processName!,
                            item,
                          ),
                        ),
                      );
                    }),
              ],
            );
          }),
        ],
      ),
    )*/
  }
}
