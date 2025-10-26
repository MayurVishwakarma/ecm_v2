// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:ecm_v2/Core/Models/MenuModel.dart';
import 'package:flutter/material.dart';

class MenuTileWidget extends StatelessWidget {
  const MenuTileWidget({super.key, required this.menuItem});
  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // pull current theme

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        elevation: 5,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: ListTile(
            leading: Image.asset(menuItem.imagePath),
            title: Text(
              menuItem.title.tr(),
              style: theme.textTheme.bodyLarge, // uses ThemeManager text styles
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => menuItem.target),
              );
            },
          ),
        ),
      ),
    );
  }
}
