import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverSearchScreen extends StatefulWidget {
  const DriverSearchScreen({super.key});

  @override
  State<DriverSearchScreen> createState() => _DriverSearchScreenState();
}

class _DriverSearchScreenState extends State<DriverSearchScreen> {
  final user = FirebaseAuth.instance.currentUser;

  final String vehicleId = "MH12AB1234";

  Color _typeColor(String type) {
    switch (type) {
      case "Alarm":
        return Colors.red;
      case "Maintenance":
        return Colors.orange;
      case "Info":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case "Alarm":
        return Icons.warning_amber_rounded;
      case "Maintenance":
        return Icons.build;
      case "Info":
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  // 🔹 Simulated notifications (latest first ideally)
  final List<Map<String, dynamic>> notifications = [
    {
      "type": "Alarm",
      "message": "Engine overheating!",
      "time": "2 min ago",
      "isNew": true,
    },
    {
      "type": "Maintenance",
      "message": "Service due in 2 days",
      "time": "1 hour ago",
      "isNew": true,
    },
    {
      "type": "Info",
      "message": "Trip completed successfully",
      "time": "Yesterday",
      "isNew": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications"), centerTitle: true),
      body: Column(
        children: [
          // 🔹 Vehicle header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicleId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(user?.email ?? "", style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),

          // 🔹 Notification list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                final color = _typeColor(n["type"]);

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 6,
                      ),
                    ],
                    // 🔥 Highlight critical alarms
                    border: n["type"] == "Alarm"
                        ? Border.all(color: Colors.red, width: 1.5)
                        : null,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withAlpha(40),
                      child: Icon(_typeIcon(n["type"]), color: color),
                    ),

                    title: Text(
                      n["message"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    subtitle: Text(n["time"]),

                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🔴 Unread dot
                        if (n["isNew"])
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          n["type"],
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    onTap: () {
                      // 👉 Navigate to ODO / detail screen if needed
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
