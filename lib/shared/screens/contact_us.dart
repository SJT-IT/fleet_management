import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final String phone = '+91 87999 97206';
  final String email = 'sales@sjtev.com';
  final String mapsUrl = 'https://maps.app.goo.gl/7iZQyxMj15RTHshC6';

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
      appBar: AppBar(title: const Text("Contact Us")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "We’re here to help.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Whether you have a question, need support, or want to explore partnerships, "
              "our team is always ready to assist you. Feel free to reach out through any "
              "of the options below.",
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone),
              subtitle: const Text("Call us directly"),
              onTap: _launchPhone,
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              subtitle: const Text("Send us an email"),
              onTap: _launchEmail,
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Our Office"),
              subtitle: const Text("Click to find us on Google Maps"),
              onTap: _launchMaps,
            ),
          ],
        ),
      ),
    );
  }
}
