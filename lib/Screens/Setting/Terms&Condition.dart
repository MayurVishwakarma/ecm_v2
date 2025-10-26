import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  static const String routeName = '/terms-and-conditions';
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _termsAndConditionsText,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _termsAndConditionsText = """
Welcome to Errection Commissioning & Maintenance App!

Please read these Terms and Conditions ("Terms", "Terms and Conditions") carefully before using the Errection Commissioning & Maintenance mobile application (the "Service") operated by us.

By accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the Terms, then you may not access the Service.

1. Use of the App
The app is intended to assist farmers and users in managing irrigation systems effectively.

You agree to use the app only for lawful purposes and in a way that does not infringe the rights of others or restrict their use of the app.

2. Accounts and Security
You may need to create an account to access certain features of the app.

You are responsible for maintaining the confidentiality of your account information.

We are not liable for any loss or damage arising from unauthorized use of your account.

3. Data and Privacy
We may collect limited data necessary for app functionality, including device and usage information.

We are committed to protecting your privacy. Please refer to our [Privacy Policy] for more details.

4. Intellectual Property
All content included in the app, such as logos, designs, text, graphics, and images, are owned by or licensed to us.

You agree not to copy, reproduce, or distribute any part of the app without our prior written consent.

5. Updates and Changes
We may update the app, its features, or these Terms from time to time.

Continued use of the app after any changes indicates your acceptance of the updated Terms.

6. Limitation of Liability
We strive to provide accurate and reliable information, but we do not guarantee the app will be error-free or always available.

We are not liable for any indirect, incidental, or consequential damages arising from your use of the app.

7. Termination
We reserve the right to suspend or terminate your access to the app at any time, without prior notice or liability, for any reason.

8. Governing Law
These Terms shall be governed and construed in accordance with the laws of India, without regard to its conflict of law provisions.

9. Contact Us
If you have any questions about these Terms, please contact us at:

📧 support@saisanketautomation.com
📍 Saisanket Automation Private Limited, India
""";
