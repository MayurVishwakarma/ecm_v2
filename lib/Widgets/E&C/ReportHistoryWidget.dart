import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/ReportHistoryModel.dart';
import 'package:ecm_v2/Core/Providers/ProjectProvider.dart';
import 'package:flutter/material.dart';

class ReportHistoryWidget extends StatelessWidget {
  const ReportHistoryWidget({
    super.key,
    required this.history,
    required this.ep,
  });

  final ReportHistoryModel? history;
  final ProjectProvider ep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: Column(
            children: [
              if (history?.changedOn != null)
                Row(
                  children: [
                    Text(
                      '${'Date'.tr()}: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MMM-dd').format(
                        history!.changedOn!.add(
                          Duration(hours: 5, minutes: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  Text(
                    '${'Process Name'.tr()} : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(history?.processName?.tr() ?? '-'),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${'Approve Status'.tr()} : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    ep.getApprovestatus(
                      history?.processName ?? '',
                      history?.approvedStatus ?? 0,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${'Submitted By'.tr()} : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(history?.username ?? '-'),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${'Remarks'.tr()} : ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      (history?.remark ?? '-'),
                      overflow: TextOverflow.clip,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
