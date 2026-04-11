import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Conditions")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            _termsText,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

const String _termsText = '''
SJT Electric Vehicles
Terms & Conditions

--------------------------------------------

1. Acceptance of Terms

By accessing or using this application, you agree to be bound by these Terms & Conditions. If you do not agree, please do not use the application.

--------------------------------------------

2. Use of the Platform

This application is intended for managing and monitoring electric vehicle fleets under SJT systems.

Users agree to:
- Use the platform only for lawful purposes
- Not attempt to manipulate, bypass, or misuse system data
- Not interfere with system operations or other users

--------------------------------------------

3. User Roles & Access

The platform operates on a role-based system:

- Admin: Full access to system data, users, and fleet information
- Dealer: Access limited to assigned fleet and associated drivers
- Driver: Access limited to assigned vehicle and personal data

Access is granted based on authorization and may be revoked at any time.

--------------------------------------------

4. Data & Telemetry

The system collects and processes vehicle and user data, including but not limited to:
- Vehicle location and movement
- Battery and performance metrics
- Usage history and telemetry data
- User activity within the application

This data is used for:
- Fleet monitoring
- Operational efficiency
- Safety and diagnostics
- System analytics

--------------------------------------------

5. Account Responsibility

Users are responsible for:
- Maintaining confidentiality of login credentials
- All activities performed under their account
- Reporting unauthorized access immediately

--------------------------------------------

6. System Availability

We strive to maintain continuous availability of the platform but do not guarantee uninterrupted access.

Maintenance, updates, or technical issues may temporarily affect service.

--------------------------------------------

7. Limitations of Liability

SJT Electric Vehicles is not responsible for:
- Indirect or incidental damages
- Loss of data due to system failure or misuse
- Actions taken based on interpreted telemetry data

Users acknowledge that telemetry data may have minor delays or inaccuracies.

--------------------------------------------

8. Modifications

We may update or modify these Terms at any time. Continued use of the application implies acceptance of the updated terms.

--------------------------------------------

9. Termination

Access may be suspended or terminated if:
- Terms are violated
- Unauthorized activity is detected
- Required by system administrators

--------------------------------------------

10. Governing Law

These Terms are governed by the laws of India.
Jurisdiction: Pune, Maharashtra, India.

--------------------------------------------

11. Contact

For queries or support:
Email: info@sjtev.com
''';