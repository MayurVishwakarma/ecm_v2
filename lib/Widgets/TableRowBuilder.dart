import 'package:flutter/material.dart';

class TableRowBuild extends StatelessWidget {
  const TableRowBuild({
    super.key,
    required this.child,
    this.onTap, // 👈 custom tap handler
    this.padding = const EdgeInsets.all(8.0),
  });

  final Widget child;
  final VoidCallback? onTap; // 👈 allows you to pass different functions
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 👈 execute whatever function is passed
      child: Padding(padding: padding, child: child),
    );
  }
}
