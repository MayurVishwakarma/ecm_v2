// ignore_for_file: avoid_print

import 'package:easy_localization/easy_localization.dart';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ConnectivityProvider.dart';
import '../../../Widgets/CustomAppBar.dart';
import '../../../Widgets/Drawer.dart';
import '../../../Widgets/POP-Ups/ChangeLanguage.dart';
import '../../../Widgets/ProjectDetailsWidget.dart';
import '../../../Widgets/nointernet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Projectlist extends StatefulWidget {
  static const routeName = "/projectList";
  const Projectlist({super.key});

  @override
  State<Projectlist> createState() => _ProjectlistState();
}

class _ProjectlistState extends State<Projectlist> {
  late TextEditingController searchController;
  @override
  initState() {
    super.initState();
    searchController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getLatestVersion(context, isMain: true);
    if (authProvider.userDetails != null) {
      authProvider.getProjectListByUserId(authProvider.userDetails!.userid);
    } else {
      //print("User details are not available");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: CommonAppbar(context, '', 'Dashboard'.tr()),
        actions: [
          IconButton(
            onPressed: () {
              ChangeLanguage(context);
            },
            icon: const Icon(Icons.translate_outlined),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          ap.updateProjectDetails([]);
          ap.getProjectListByUserId(ap.userDetails!.userid);
        },
        child: Consumer2<AuthProvider, ConnectivityProvider>(
          builder: (context, ap, cp, child) {
            return cp.isOnline
                ? GestureDetector(
                    onTap: () =>
                        FocusScope.of(context).requestFocus(FocusNode()),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: searchController,
                              onChanged: (value) => ap.filterProjects(
                                value,
                                ap.projectDetails ?? [],
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Search by Project or State',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                suffixIcon: Icon(Icons.search, size: 30),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: ap.backupList?.length,
                              itemBuilder: (context, index) {
                                if (ap.backupList != null) {
                                  return ProjectDetailsWidget(
                                    project: ap.backupList![index],
                                  );
                                } else {
                                  return ProjectDetailsShimmerWidget();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: NoInternetWidget());
          },
        ),
      ),

      /*Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (authProvider.projectDetails != null &&
              authProvider.projectDetails!.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: authProvider.projectDetails!.length,
                itemBuilder: (context, index) {
                  final project = authProvider.projectDetails![index];
                  return ProjectDetailsTile(project: project);
                },
              ),
            )
          else
            const Center(child: Text('No projects available')),
        ],
      ),*/
    );
  }
}
