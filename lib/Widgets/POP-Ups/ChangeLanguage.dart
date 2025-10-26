// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future<dynamic> ChangeLanguage(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Select Language".tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            tileColor: context.locale.languageCode == 'en'
                ? Theme.of(context).cardColor
                : null,
            leading: const Icon(Icons.language),
            title: const Text("English"),
            onTap: () {
              context.setLocale(const Locale('en'));
              Navigator.pop(context); // close dialog
            },
          ),
          ListTile(
            tileColor: context.locale.languageCode == 'hi'
                ? Theme.of(context).cardColor
                : null,
            leading: const Icon(Icons.language),
            title: const Text("हिंदी"),
            onTap: () {
              context.setLocale(const Locale('hi'));
              
              Navigator.pop(context); // close dialog
            },
          ),
          ListTile(
            tileColor: context.locale.languageCode == 'mr'
                ? Theme.of(context).cardColor
                : null,
            leading: const Icon(Icons.language),
            title: const Text("मराठी"),
            onTap: () {
              context.setLocale(const Locale('mr'));
              Navigator.pop(context); // close dialog
            },
          ),
          ListTile(
            tileColor: context.locale.languageCode == 'or'
                ? Theme.of(context).cardColor
                : null,
            leading: const Icon(Icons.language),
            title: const Text("ଓଡ଼ିଆ"),
            onTap: () {
              context.setLocale(const Locale('or'));
              Navigator.pop(context); // close dialog
            },
          ),
        ],
      ),
    ),
  );
}
