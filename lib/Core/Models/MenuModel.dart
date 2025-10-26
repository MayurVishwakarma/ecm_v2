import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String imagePath;
  final Widget target;
  final IconData? icon; // optional icon field
  MenuItem(this.title, this.imagePath, this.target, {this.icon});
}
