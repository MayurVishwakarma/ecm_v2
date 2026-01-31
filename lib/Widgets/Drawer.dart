// ignore_for_file: file_names

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Screens/Auth/ProjectList.dart';
import 'package:ecm_v2/Screens/Setting/Profile.dart';
import 'package:ecm_v2/Screens/Setting/Setting.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/SeLogo.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.28,
                          child: Text(
                            'AppName'.tr(),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Version ${authProvider.versionNO}",
                          style: TextStyle(
                            fontSize: 10,
                            color: ColorManager.pureWhite,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              '${authProvider.userDetails!.fName} ${authProvider.userDetails!.lName}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text('${authProvider.userDetails!.designation}'),
          ),

          Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.dashboard_rounded,
                    // color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    'Dashboard'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      // color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Projectlist()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.person_sharp),
                  title: Text(
                    'Profile'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      // color: ColorManager.darkElm,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Profile()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.translate_rounded),
                  title: Text(
                    'Change Language'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      // color: ColorManager.darkElm,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    ChangeLanguage(context);
                  },
                ),
                /*                ListTile(
                  leading: const Icon(
                    Icons.info_rounded,
                    // color: ColorManager.darkElm,
                  ),
                  title: Text(
                    'Help'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      // color: ColorManager.darkElm,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RaiseComplaintScreen(),
                      ),
                    );
                  },
                ),
*/
                ListTile(
                  leading: const Icon(
                    Icons.info_rounded,
                    // color: ColorManager.darkElm,
                  ),
                  title: Text(
                    'About Us'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      // color: ColorManager.darkElm,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Setting()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: ColorManager.hotCoral,
                  ),
                  title: Text(
                    'Logout'.tr(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorManager.hotCoral,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () async {
                    authProvider.showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
          // const Divider(thickness: 1),
        ],
      ),
    );
  }
}
