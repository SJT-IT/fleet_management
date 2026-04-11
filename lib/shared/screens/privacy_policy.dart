import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            _privacyText,
            style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

const String _privacyText = '''
SJT Electric Vehicles
Privacy Policy

SJT Electric Vehicles (referred as “SJT”) is committed to protecting your privacy and security of your personal data.

We process your personal data in accordance with applicable laws and use it only as described in this Privacy Policy.

By accessing and using our website or application, you agree to this Privacy Policy.

--------------------------------------------

1. Personal Data We Collect

Personal data refers to information that identifies you such as:
- Name, age, gender
- Address, phone number, email
- Device information, IP address, location

We collect data when you:
- Register or use our services
- Apply for dealership/distributorship
- Contact support or fill forms
- Use our website or app features

We may also collect data from:
- Employers or partners
- Public sources
- Service providers

We also collect:
- Vehicle details (model, VIN, registration, warranty, etc.)
- Payment information (via secure gateways)
- Device and usage data (logs, cookies, activity)

--------------------------------------------

2. How We Use Your Data

We use your data to:
- Provide and improve services
- Respond to requests and support
- Send service updates and notifications
- Improve website/app performance
- Ensure security and prevent fraud
- Meet legal obligations

We may also use data for marketing communications, which you can opt out of at any time.

--------------------------------------------

3. Data Sharing

We may share your data with:
- Internal SJT teams
- Affiliates and group companies
- Authorized dealers and distributors
- Service providers (cloud, payment, support systems)
- Business partners for co-branded services
- Legal authorities when required by law

We do not sell your personal data for marketing purposes.

--------------------------------------------

4. Data Storage & Security

We take appropriate technical and organizational measures to protect your data.

This includes:
- Secure storage systems
- Access control restrictions
- Regular security reviews
- Encryption and monitoring where applicable

However, no system is 100% secure over the internet.

--------------------------------------------

5. Cookies

We use cookies to:
- Improve user experience
- Analyze usage
- Maintain sessions
- Personalize content

You can disable cookies in your browser settings, but some features may not work properly.

--------------------------------------------

6. Your Rights

You have the right to:
- Access your data
- Correct or update your data
- Request deletion of data
- Object to processing
- Withdraw consent
- Request data portability

To exercise these rights, contact us using the details below.

--------------------------------------------

7. Data Retention

We retain personal data only as long as necessary for:
- Legal obligations
- Business operations
- Service delivery

After that, data is securely deleted.

--------------------------------------------

8. Changes to This Policy

We may update this Privacy Policy from time to time.

We encourage users to review it periodically.

--------------------------------------------

9. Contact Information

SJT Electric Vehicles
Email: info@sjtev.com

Governing Law: India
Jurisdiction: Pune, India
''';
