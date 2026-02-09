// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import '../../../Core/Providers/AuthProvider.dart';
import '../../../Utils/Themes/color_manager.dart';
import '../../../Utils/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  late Timer _timer;
  @override
  void initState() {
    final dp = Provider.of<AuthProvider>(context, listen: false);
    _timer = Timer(const Duration(seconds: 1), () {
      dp.getDataFromSharedPreferences(context, Keys.user);
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /*
  @override
  void initState() {
    super.initState();
    _navigateToInitialScreen();
  }

  Future<void> _navigateToInitialScreen() async {
    Widget targetScreen = const LoginScreen();

    try {
      final preferences = await SharedPreferences.getInstance();
      final userString = preferences.getString('UserDetails');
      if (userString != null && userString.isNotEmpty) {
        final user = UserMasterModel.fromJson(jsonDecode(userString));
        if ((user.fName?.isNotEmpty ?? false)) {
          targetScreen = const ProjectMenu();
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => targetScreen),
        (_) => false,
      );
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final theme = ThemeManager().lightThemeData;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/saisanket_Logo.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),
            Text(
              "Erection Commission & Maintenance",
              style: theme.textTheme.displayMedium?.copyWith(
                color: ColorManager.pureWhite,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Precision irrigation for progressive farming",
              style: theme.textTheme.titleMedium?.copyWith(
                color: ColorManager.pureWhite,
              ),
            ),
            Text(
              "Version ${ap.versionNO}",
              style: theme.textTheme.titleSmall?.copyWith(
                color: ColorManager.pureWhite,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Created by\nSaisanket Automation Pvt. Ltd.",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ColorManager.pureWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
