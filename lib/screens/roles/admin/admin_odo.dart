import 'package:fleet_management/screens/roles/dealer/dealer_odo.dart';
import 'package:flutter/material.dart';

class AdminOdoScreen extends StatelessWidget {
  const AdminOdoScreen({super.key});

  final List<Map<String, String>> dealers = const [
    {"id": "d1", "name": "Metro Motors", "status": "Active"},
    {"id": "d2", "name": "City Fleet Services", "status": "Closed"},
    {"id": "d3", "name": "Prime Auto Dealers", "status": "Maintenance"},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case "Active":
        return Colors.green;
      case "Maintenance":
        return Colors.orange;
      case "Closed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Dealers List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dealers.length,
        itemBuilder: (context, index) {
          final dealer = dealers[index];
          final statusColor = _statusColor(dealer["status"]!);

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent.withAlpha(25),
                child: const Icon(Icons.business, color: Colors.blueAccent),
              ),

              title: Text(
                dealer["name"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        dealer["status"]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Dealer ID: ${dealer["id"]}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DealerOdoScreen(
                      dealerId: dealer["id"]!,
                      dealerName: dealer["name"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
