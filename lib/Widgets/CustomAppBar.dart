// ignore_for_file: non_constant_identifier_names

import '../../../Core/Models/ProjectDetailsModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Row customAppbar(
  BuildContext context,
  String? title,
  ProjectDetailsModel? project,
) {
  final ap = Provider.of<AuthProvider>(context, listen: false);
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        ap.getStateImage(project?.state ?? '').toString(),
        height: 30,
        width: 30,
      ),
      SizedBox(width: 10),
      if (title != null && title.isNotEmpty)
        Text("${project?.projectName} - $title")
      else
        Text("${project?.projectName}"),
    ],
  );
}

Row customECMAppbar(
  BuildContext context,
  String? title,
  ProjectDetailsModel? project,
) {
  final ap = Provider.of<AuthProvider>(context, listen: false);
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
          Row(
            children: [
              Image.asset(
                ap.getStateImage(project?.state ?? '').toString(),
                height: 30,
                width: 30,
              ),
              SizedBox(width: 10),
              Text("${project?.projectName}"),
            ],
          ),
          Text(
            "($title)",
            style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),

      /*Image.asset(
        ap.getStateImage(project?.state ?? '').toString(),
        height: 30,
        width: 30,
      ),
      SizedBox(width: 10),
      if (title != null && title.isNotEmpty)
        Column(
          children: [
            Text("${project?.projectName}"),
            Text(
              "($title)",
              style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
            ),
          ],
        )
      else
        Text("${project?.projectName}"),
    */
    ],
  );
}

Row CommonAppbar(BuildContext context, String? title, String? res) {
  final ap = Provider.of<AuthProvider>(context, listen: false);
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(ap.getStateImage('').toString(), height: 30, width: 30),
      SizedBox(width: 10),
      if (title != null && title.isNotEmpty)
        Column(
          children: [
            Text("$res"),
            Text("($title)", style: TextStyle(fontSize: 12)),
          ],
        )
      else
        Text("$res"),
    ],
  );
}
