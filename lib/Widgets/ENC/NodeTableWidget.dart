// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/ProcessMasterModel.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Screens/ENC/Reports/OneECMReport.dart';
import 'package:flutter/material.dart';

class NodeTableWidget extends StatelessWidget {
  const NodeTableWidget({
    super.key,
    required this.projectProvider,
    required this.onReturn,
  });

  final ProjectProvider projectProvider;
  final VoidCallback onReturn;

  Widget _buildRowCell(
    BuildContext context,
    ProjectProvider provider,
    ProcessMasterModel? process,
    dynamic item,
    Widget child,
  ) {
    return GestureDetector(
      onTap: () async {
        // Run validation only if it's a process cell
        if (process != null) {
          bool allow = projectProvider.canProceed(process, item);

          if (allow) {
            provider.updateSelectedNode(item);
            provider.updateSelectedReportProcess(process);
            await Navigator.pushNamed(context, OneEcmReports.routeName);
            onReturn();
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   OneEcmReports.routeName,
            //   (route) => true,
            // );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${'Please complete previous process before going for '.tr()} ${process.processName?.tr().toLowerCase()}",
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                duration: const Duration(seconds: 5),
              ),
            );
          }
        }
      },
      child: Padding(padding: const EdgeInsets.all(8.0), child: child),
    );
  }

  /*Widget _buildRowCell(
    BuildContext context,
    ProjectProvider provider,
    ProcessMasterModel? process,
    dynamic item,
    Widget child,
  ) {
    return GestureDetector(
      onTap: () {
        provider.updateSelectedNode(item);
        provider.updateSelectedReportProcess(process);
        Navigator.pushNamedAndRemoveUntil(
          context,
          OneEcmReports.routeName,
          (route) => true,
        );
      },
      child: Padding(padding: const EdgeInsets.all(8.0), child: child),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(color: Colors.grey.shade300),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: FixedColumnWidth(130), // Chak No. column fixed width
        },
        children: [
          ...(projectProvider.nodeList ?? []).map((item) {
            return TableRow(
              children: [
                // Wrap first cell
                _buildRowCell(
                  context,
                  projectProvider,
                  projectProvider.processList
                      ?.where((element) => element.processId != 0)
                      .first,
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
                          style: TextStyle(fontSize: 10, color: Colors.blue),
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
                ...(projectProvider.processList ?? [])
                    .where((e) => e.processId != 0)
                    .map((process) {
                      return _buildRowCell(
                        context,
                        projectProvider,
                        process,
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
    );
  }
}
