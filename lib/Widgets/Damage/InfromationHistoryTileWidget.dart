// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/Damage/InfromationHistoryModel.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:flutter/material.dart';

class InfromationHistoryTile extends StatelessWidget {
  const InfromationHistoryTile({
    super.key,
    required this.item,
    required this.index,
  });

  final InformationHistoryModel? item;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColorManager.cantaloupe,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${'Attempt No'.tr()} : $index",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF82C9FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      DateFormat(
                        'dd MMM, yyyy\nHH:mm:ss aa',
                      ).format(item!.reportedOn!),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          "${'Information Count'.tr()}: ${item?.informationList?.split(',').length ?? 0}",
                        ),
                        backgroundColor: Color(0xFF4FAD55).withOpacity(0.1),
                        labelStyle: TextStyle(color: Color(0xFF4FAD55)),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(),

              // Remark
              Row(
                children: [
                  Text(
                    "${'Remarks'.tr()} :",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      " ${item?.remark ?? '-'}",
                      style: TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "${'Reported By'.tr()} : ",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    item?.username ?? '-',
                    style: TextStyle(color: Colors.grey[600]),
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
