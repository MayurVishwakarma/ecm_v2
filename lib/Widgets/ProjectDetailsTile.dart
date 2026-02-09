import '../../../Core/Models/ProjectDetailsModel.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Screens/Auth/ProjectMenu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProjectDetailsTile extends StatelessWidget {
  const ProjectDetailsTile({super.key, required this.project});

  final ProjectDetailsModel project;

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 201, 222, 240),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1.5),
              blurRadius: 1.0,
              spreadRadius: 0.4,
            ),
          ],
          borderRadius: BorderRadius.circular(3.5),
        ),
        child: ListTile(
          // tileColor: Colors.blue[50],
          splashColor: Colors.blue[100],
          onTap: () async {
            ap.updateSelectedProject(project);
            // Navigate to the ProjectMenu screen
            Navigator.pushNamedAndRemoveUntil(
              context,
              ProjectMenu.routeName,
              (route) => true,
            );
          },
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(3.5),
          ),
          leading: SizedBox(
            height: 80,
            // width: 80,
            child: Image.asset(ap.getStateImage(project.state!.toLowerCase())!),
          ),
          title: Text(
            project.projectName ?? '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (project.description != 'NA')
                Text(
                  project.description ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              Text(
                "${project.state} (CCA:${project.totalArea ?? '0'})",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
