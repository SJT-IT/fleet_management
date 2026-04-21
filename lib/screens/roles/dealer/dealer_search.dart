import 'package:fleet_management/shared/screens/odo_ui.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DealerSearchScreen extends StatefulWidget {
  const DealerSearchScreen({super.key});

  @override
  State<DealerSearchScreen> createState() => _DriverSearchScreenState();
}

class _DriverSearchScreenState extends State<DealerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

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

  // 🔹 Dummy data (Driver + Vehicle together)
  final List<Map<String, String>> allDrivers = [
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

  List<Map<String, String>> filteredDrivers = [];

  @override
  void initState() {
    super.initState();
    filteredDrivers = allDrivers;
  }

  void _filterDrivers(String query) {
    final results = query.isEmpty
        ? allDrivers
        : allDrivers.where((d) {
            final driver = d["driver"]!.toLowerCase();
            final number = d["number"]!.toLowerCase();
            return driver.contains(query.toLowerCase()) ||
                number.contains(query.toLowerCase());
          }).toList();

    setState(() {
      filteredDrivers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔹 Logged in user
            Text(
              "Logged in as: ${user?.email ?? "No Email"}",
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),

            // 🔹 Search bar
            TextField(
              controller: _searchController,
              onChanged: _filterDrivers,
              decoration: InputDecoration(
                hintText: "Search by driver or vehicle number...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Styled list (same pattern as your ODO UI)
            Expanded(
              child: filteredDrivers.isEmpty
                  ? const Center(child: Text("No results found"))
                  : ListView.builder(
                      itemCount: filteredDrivers.length,
                      itemBuilder: (context, index) {
                        final d = filteredDrivers[index];
                        final color = _statusColor(d["status"]!);

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withAlpha(40),
                              child: Icon(Icons.person, color: color),
                            ),

                            // 🔹 Vehicle number FIRST (important)
                            title: Text(
                              d["number"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Driver: ${d['driver']}"),
                                Text("Model: ${d['model']}"),
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
                                d["status"]!,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OdoUIScreen(
                                    vehicleId: d["number"]!,

                                    // 🔹 You can replace all this with real backend data later
                                    speed: 40,
                                    alarm: d["status"] == "Broken"
                                        ? "Fault Detected"
                                        : "No Alarm",
                                    soc: "75%",
                                    voltage: "48V",
                                    temp: "32°C",
                                    current: "12A",
                                    odometer: "1600 km",
                                    latitude: "18.5204",
                                    longitude: "73.8567",
                                    timestamp: "2026-04-21 12:30 PM",

                                    sliderValue: 0,
                                    maxSlider: 0,
                                    onSliderChanged: (value) {},

                                    prevMonthDistance: null,
                                    currentMonthDistance: null,
                                    runningMonthDistance: null,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
