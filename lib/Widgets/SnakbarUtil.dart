import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static showSnackBar({required BuildContext context, String? content}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content ?? ""),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
    ));
  }

  static showToastMessage({String? msg, required Color color}) {
    Fluttertoast.showToast(
        msg: msg ?? "", backgroundColor: color, timeInSecForIosWeb: 5);
  }
}
