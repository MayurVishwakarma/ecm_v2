// ignore_for_file: use_build_context_synchronously

import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ConnectivityProvider.dart';
import '../../../Core/Providers/DamageProvider.dart';
import '../../../Core/Providers/ProjectProvider.dart';
import '../../../Core/Providers/RoutineProvider.dart';
import '../../../Utils/Functions/Route.dart';
import 'package:provider/provider.dart';
import '../../../Utils/Themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('or'),
      ],
      path: 'assets/Languages',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _askPermissions(); // 🔥 ask right when app starts
  }

  Future<void> _askPermissions() async {
    // Example: request multiple permissions
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
      Permission.locationWhenInUse,
    ].request();

    // You can check specific status like:
    if (statuses[Permission.camera]!.isDenied) {
      debugPrint("Camera permission denied");
    }
    if (statuses[Permission.storage]!.isPermanentlyDenied ||
        (statuses[Permission.photos]?.isPermanentlyDenied ?? false)) {
      // 🚨 Show dialog asking user to open settings
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProjectProvider()),
        ChangeNotifierProvider(create: (context) => DamageProvider()),
        ChangeNotifierProvider(create: (context) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.onGenerateRoute,
        theme: ThemeManager().lightThemeData,
        darkTheme: ThemeManager().darkThemeData,
        themeMode: ThemeMode.system,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
