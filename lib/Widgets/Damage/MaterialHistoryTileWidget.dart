// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/Damage/MaterialHistoryModel.dart';
import 'package:flutter/material.dart';

class MatrialHistoryTile extends StatelessWidget {
  const MatrialHistoryTile({super.key, required this.item});

  final MaterialHistoryModel? item;

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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF82C9FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('dd MMM, yyyy').format(item!.reportedOn!),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      "${'Electrical'.tr()}: ${item?.electRectifyList?.split(',').length ?? 0}",
                    ),
                    backgroundColor: Color(0xFF4FAD55).withOpacity(0.1),
                    labelStyle: TextStyle(color: Color(0xFF4FAD55)),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      "${'Mechanical'.tr()}: ${item?.mechRectifyList?.split(',').length ?? 0}",
                    ),
                    backgroundColor: Color(0xFFFFA722).withOpacity(0.1),
                    labelStyle: TextStyle(color: Color(0xFFFFA722)),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      "${'Tubing'.tr()}: ${item?.tubRectifyList?.split(',').length ?? 0}",
                    ),
                    backgroundColor: Color.fromARGB(
                      255,
                      34,
                      111,
                      255,
                    ).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 34, 111, 255),
                    ),
                  ),
                ],
              ),

              Divider(),

              // Remark
              Row(
                children: [
                  Text(
                    "${"Remarks".tr()} :",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(" ${item?.remark ?? '-'}"),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "Reported By : ",
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
