// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void showSnackBar({required BuildContext context, String? content}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content ?? ""),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
    ));
  }

  static void showToastMessage({String? msg, required Color color}) {
    Fluttertoast.showToast(
        msg: msg ?? "", backgroundColor: color, timeInSecForIosWeb: 5);
  }
}
