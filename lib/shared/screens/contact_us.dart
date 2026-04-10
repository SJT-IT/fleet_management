import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final String phone = '+91 87999 97206';
  final String email = 'sales@sjtev.com';
  final String mapsUrl = 'https://maps.app.goo.gl/7iZQyxMj15RTHshC6';
  Uri get emailUri =>
      Uri.parse('mailto:$email?subject=${Uri.encodeComponent('Contact Us')}');

  const ContactUsScreen({super.key});

  // Launch phone dialer
  Future<void> _launchPhone() async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // Launch email client
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse(
      'mailto:$email?subject=${Uri.encodeComponent('Contact Us')}',
    );

    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  // Launch Google Maps
  Future<void> _launchMaps() async {
    final Uri url = Uri.parse(mapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(phone),
              onTap: _launchPhone,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(email),
              onTap: _launchEmail,
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("Our Office"),
              onTap: _launchMaps,
            ),
          ],
        ),
      ),
    );
  }
}
