// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Screens/Setting/Setting.dart';
import 'package:ecm_v2/Screens/Setting/Terms&Condition.dart';
import 'package:ecm_v2/Utils/Themes/color_manager.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:ecm_v2/Widgets/POP-Ups/ChangeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final user = ap.userDetails;
    return Scaffold(
      appBar: AppBar(
        title: CommonAppbar(
          context,
          "${user?.fName!} ${user?.lName!}",
          'Profile'.tr(),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              child: Text(
                "${user?.fName?.substring(0, 1)}${user?.lName?.substring(0, 1)}",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.darkElm,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${user?.fName} ${user?.lName}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "+91 ${user?.mobileNo}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (user?.email != null)
              Text(
                "${user?.email}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            Text(
              "${user?.designation}",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 30),

            Container(
              // height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      ChangeLanguage(context);
                    },
                    title: Text(
                      "Change Language".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        Setting.routeName,
                        (route) => true,
                      );
                    },
                    title: Text(
                      "About Us".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        // color: ColorManager.darkElm,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        TermsAndConditionsPage.routeName,
                        (route) => true,
                      );
                    },
                    title: Text(
                      "Terms and Conditions".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        // color: ColorManager.darkElm,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    onTap: () async {
                      ap.showLogoutDialog(context);
                    },
                    title: Text(
                      "Logout".tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                        // color: ColorManager.darkElm,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
