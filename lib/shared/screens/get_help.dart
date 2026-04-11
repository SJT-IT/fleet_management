import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetHelpScreen extends StatelessWidget {
  final String phone = '+91 94034 56546';
  final String email = 'info@sjtev.com';
  final String mapsUrl = 'https://maps.app.goo.gl/7iZQyxMj15RTHshC6';

  const GetHelpScreen({super.key});

  Future<void> _launchPhone() async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri.parse(
      'mailto:$email?subject=${Uri.encodeComponent('Help Request')}',
    );
    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchMaps() async {
    final Uri url = Uri.parse(mapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Get Help")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Need assistance?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "We’re here to support you with any issues related to your vehicle, "
              "account, or app usage. Reach out anytime.",
              style: TextStyle(fontSize: 14, height: 1.4),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(phone),
              subtitle: const Text("Call support"),
              onTap: _launchPhone,
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
              subtitle: const Text("Email support"),
              onTap: _launchEmail,
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Our Office"),
              subtitle: const Text("Open in Google Maps"),
              onTap: _launchMaps,
            ),

            const SizedBox(height: 24),

            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            const FAQTile(
              question: "What is the warranty period?",
              answer:
                  "• 1,20,000 KM / 4 Years for Battery Packs and Motor\n"
                  "• 40,000 KM / 2 Years for other mechanical parts\n"
                  "• 20,000 KM / 1 Year for electrical/electronic parts\n"
                  "• Warranty is void if OEM vehicle conditions are violated",
            ),

            const FAQTile(
              question: "How does vehicle servicing work?",
              answer:
                  "• SJT provides service centers for electric drive parts\n"
                  "• Service schedule is mentioned in the owner manual\n"
                  "• Available in all major cities\n"
                  "• Roadside assistance available on call\n"
                  "• OEM workshops can service non-electric components",
            ),

            const FAQTile(
              question: "What is the cost of charging?",
              answer:
                  "• 7–8 km per 1 unit of electricity\n"
                  "• Approx. ₹1 per km running cost\n"
                  "• Potential savings of ₹1–2 lakh per year vs fuel",
            ),

            const FAQTile(
              question: "How do I charge the vehicle?",
              answer:
                  "• Any 15A single-phase socket supports charging\n"
                  "• 3.3kW AC: 80% charge in 6–8 hours\n"
                  "• 6.6kW fast charging (future support option)",
            ),

            const FAQTile(
              question: "How is battery handling and safety ensured?",
              answer:
                  "• Portable briefcase-style batteries (~18kg)\n"
                  "• Can be charged at home, office, or station\n"
                  "• Built-in safety: overcharge, voltage, thermal protection\n"
                  "• Do not expose batteries to rain or wet areas",
            ),

            const FAQTile(
              question: "How is vehicle driving experience?",
              answer:
                  "• Similar to a normal car\n"
                  "• Automated clutch for easier driving\n"
                  "• User manual and driving tips provided\n"
                  "• Designed for safe and efficient usage",
            ),

            const FAQTile(
              question: "What about luggage space?",
              answer:
                  "• Portable battery may occupy boot space\n"
                  "• Some storage available for small luggage\n"
                  "• Additional space available in rear/foot areas",
            ),

            const FAQTile(
              question: "Can I buy only the EV kit?",
              answer:
                  "• No, EV kits are not sold separately\n"
                  "• Vehicles are converted and delivered as complete units",
            ),

            const FAQTile(
              question: "What about battery replacement cost?",
              answer:
                  "• Battery prices are continuously reducing\n"
                  "• Fuel savings help offset replacement cost over time",
            ),
          ],
        ),
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(answer, style: const TextStyle(height: 1.4)),
        ),
      ],
    );
  }
}
