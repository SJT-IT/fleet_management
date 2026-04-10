import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text('''
Our Commitment to Your Privacy

1. Information We Collect
We collect personal information to provide and improve our services.

2. How We Use Information
Information is used to operate the app and communicate with users.

3. Data Sharing
We do not sell your data. We may share with trusted partners for app functionality.

4. Security
We implement reasonable measures to protect your information.

5. Your Rights
You can request access, correction, or deletion of your personal data.

Thank you for trusting us with your information!
''', style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
