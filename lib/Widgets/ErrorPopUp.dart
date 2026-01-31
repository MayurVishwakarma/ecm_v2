// ignore_for_file: file_names

import 'package:flutter/material.dart';

Future<Future<dynamic>> getErrorPopUp(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("ERROR"),
        content: Text("Something Went Wrong!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
