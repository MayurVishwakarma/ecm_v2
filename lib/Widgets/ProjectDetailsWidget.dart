// ignore_for_file: must_be_immutable, deprecated_member_use, file_names

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Models/ProjectDetailsModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Screens/Auth/ProjectMenu.dart';
import '../../../Utils/Themes/PageTransition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProjectDetailsWidget extends StatelessWidget {
  ProjectDetailsModel project;
  ProjectDetailsWidget({super.key, required this.project});
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: () {
            ap.updateSelectedProject(project);
            ap.getProjectUserDetailsByMobile(ap.userDetails?.mobileNo);
            Navigator.push(context, createRoute(ProjectMenu()));
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   ProjectMenu.routeName,
            //   (route) => true,
            // );
          },
          leading: Image.asset(
            cacheHeight: 150,
            alignment: Alignment.center,
            ap.getStateImage(project.state!.toLowerCase()).toString(),
          ),
          title: Text(project.projectName ?? ''),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (project.description != 'NA')
                Text(
                  (project.description ?? '').tr(),
                  style: const TextStyle(fontSize: 12),
                ),
              Text(
                "${project.state?.tr()} (CCA:${project.totalArea ?? '0'})",
                // style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectDetailsShimmerWidget extends StatelessWidget {
  const ProjectDetailsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          height: 80,
        ),
      ),
    );
  }
}
