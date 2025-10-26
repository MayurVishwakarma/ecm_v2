import 'package:ecm_v2/Core/Providers/AuthProvider.dart';
import 'package:ecm_v2/Widgets/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SurveyToolScreen extends StatefulWidget {
  const SurveyToolScreen({super.key});

  @override
  State<SurveyToolScreen> createState() => _SurveyToolScreenState();
}

class _SurveyToolScreenState extends State<SurveyToolScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: customECMAppbar(context, 'Site-Survey', ap.selectedProject),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Survey Tool Content"),
            Text('This is a placeholder for the survey tool functionality.'),
          ],
        ),
      ),
    );
  }
}
