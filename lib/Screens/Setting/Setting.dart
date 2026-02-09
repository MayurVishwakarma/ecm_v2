// ignore_for_file: file_names, unused_local_variable, use_build_context_synchronously

import '../../../Core/Providers/AuthProvider.dart';
import '../../../Core/Providers/ConnectivityProvider.dart';
import '../../../Widgets/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  static const String routeName = '/setting';
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context);
    final cp = Provider.of<ConnectivityProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      drawer: AppDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/saisanket_Logo.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 10),
            Text(
              "Saisanket Automation Pvt. Ltd.",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Erection Commissioning & Maintenance",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Version ${ap.versionNO}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20),
              child: Text(
                '''SAISANKET group has been in the business of Water Management since 1999. We are Technology Integrators and Smart Solutions Providers for Pipe Flow Projects. Promoted by Milind Murudkar, a qualified Mechanical Engineer and a first-generation entrepreneur, Saisanket brings in world renowned Technologies from Israel, USA, France and many other leading countries and customizes them through our innovative in-house technologies to provide Smart Solutions to our Clients in diverse sectors such as Irrigation, Water Supply, Oil and Natural Gas.\n\nSaisanket is a technology-driven consultancy and EPC organization with a significant presence in the country. We specialize in water management and offer comprehensive design and automation integrated solutions for micro irrigation and pressurized irrigation piping network projects of any scale and complexity.\n\nSaisanket is committed for providing quality time bound services to the clients which is the very essence of Saisanket operations. A lifetime commitment to introduce modern, yet affordable, and viable technological solutions in all our product offerings has compelled us to be creative and innovative.''',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!cp.isOnline) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No internet connection')),
                  );
                  return;
                }
                ap.getLatestVersion(context, isMain: false);
              }, // You can handle update checking here
              child: const Text('Check for Updates'),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            Text(
              "Developed by Saisanket",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.email_outlined),
                  onPressed: _launchEmail,
                ),
                GestureDetector(
                  onTap: _launchEmail,
                  child: Text(
                    "Email: info@saisanket.com",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded),
                  onPressed: () => launchUrl(
                    Uri.parse("https://saisanket.com/"),
                    mode: LaunchMode.externalApplication,
                  ),
                ),
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse("https://saisanket.com/"),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(
                    "Website: www.saisanket.com",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@saisanket.com',
      query: 'subject=Support%20Request',
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email client')),
      );
    }
  }
}
