import 'package:fleet_management/shared/screens/odo_ui.dart';
import 'package:flutter/material.dart';

class VehicleListScreen extends StatelessWidget {
  final String dealerId;
  final String dealerName;

  const VehicleListScreen({
    super.key,
    required this.dealerId,
    required this.dealerName,
  });

  List<Map<String, String>> getVehicles(String dealerId) {
    return [
      {
        "id": "v1",
        "name": "Tesla Model X",
        "driver": "John",
        "status": "Running",
      },
      {
        "id": "v2",
        "name": "BYD Atto 3",
        "driver": "Mike",
        "status": "Maintenance",
      },
      {
        "id": "v3",
        "name": "Tata Nexon EV",
        "driver": "Sara",
        "status": "Retired",
      },
    ];
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Running":
        return Colors.green;
      case "Maintenance":
        return Colors.orange;
      case "Retired":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = getVehicles(dealerId);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          dealerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final v = vehicles[index];
          final statusColor = _statusColor(v["status"]!);

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
                child: const Icon(
                  Icons.directions_car,
                  color: Colors.blueAccent,
                ),
              ),

              title: Text(
                v["name"]!,
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
                        v["status"]!,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Driver: ${v["driver"]}",
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
                    builder: (_) => OdoUIScreen(
                      vehicleId: v["id"]!,
                      speed: 45,
                      alarm: "no alarm",
                      soc: "100",
                      voltage: "99",
                      temp: "35",
                      current: "10",
                      odometer: "1200",
                      latitude: "18.5204",
                      longitude: "73.8567",
                      timestamp: DateTime.now().toString(),
                      sliderValue: 5,
                      maxSlider: 10,
                      onSliderChanged: (v) {},
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
