import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetHelpScreen extends StatelessWidget {
  final String phone = '+91 94034 56546';
  final String email = 'help@sjtev.com';
  final String mapsUrl = 'https://maps.app.goo.gl/7iZQyxMj15RTHshC6';
  Uri get emailUri =>
      Uri.parse('mailto:$email?subject=${Uri.encodeComponent('Help Request')}');

  const GetHelpScreen({super.key});

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
      'mailto:$email?subject=${Uri.encodeComponent('Help Request')}',
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
      appBar: AppBar(title: Text("Get Help")),
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
