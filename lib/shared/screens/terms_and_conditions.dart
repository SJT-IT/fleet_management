import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Conditions")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '''
Welcome to Our App!

1. Acceptance of Terms
By using this app, you agree to our terms and conditions.

2. Use of the App
You must use this app in compliance with all applicable laws.

3. Intellectual Property
All content and materials are owned by the company.

4. Limitation of Liability
We are not responsible for any damages resulting from app use.

5. Modifications
We may update these terms at any time.

Thank you for using our app!
''',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}