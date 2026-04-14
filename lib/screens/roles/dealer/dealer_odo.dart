import 'package:flutter/material.dart';

class DealerOdoScreen extends StatelessWidget {
  const DealerOdoScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case "Running":
        return Colors.green;
      case "Maintenance":
        return Colors.orange;
      case "Broken":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  final List<Map<String, String>> vehicles = const [
    {
      "driver": "Amit Sharma",
      "number": "MH12AB1234",
      "model": "Tata Ace",
      "status": "Running",
    },
    {
      "driver": "Rahul Patil",
      "number": "MH14XY5678",
      "model": "Mahindra Bolero",
      "status": "Maintenance",
    },
    {
      "driver": "Suresh Kumar",
      "number": "MH09CD9988",
      "model": "Ashok Leyland",
      "status": "Broken",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dealer Vehicles"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final v = vehicles[index];
          final color = _statusColor(v["status"]!);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color..withAlpha(40),
                child: Icon(Icons.local_shipping, color: color),
              ),
              title: Text(
                v["number"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Driver: ${v['driver']}"),
                  Text("Model: ${v['model']}"),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  v["status"]!,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                // Later: navigate to VehicleDetailScreen(vehicleId)
              },
            ),
          );
        },
      ),
    );
  }
}
