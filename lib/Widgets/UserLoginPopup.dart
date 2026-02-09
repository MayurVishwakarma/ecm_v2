// ignore_for_file: file_names

import '../../../Core/Models/UserMasterModel.dart';
import '../../../Screens/Auth/ProjectList.dart';
import 'package:flutter/material.dart';

class UserLoginPopup extends StatelessWidget {
  final UserMasterModel user;

  const UserLoginPopup({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Image.asset('assets/images/SeLogo.png', height: 50)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to ECM',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '${user.fName} ${user.lName}',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Text(
            user.userType ?? "Not specified",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onHover: (value) {
                // Change the button color on hover
                value
                    ? ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                      )
                    : ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      );
              },
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Projectlist()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
              ),
              child: const Text('OK'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
