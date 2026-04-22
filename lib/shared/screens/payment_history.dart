import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  final double ratePerKm = 7.0;

  // Dummy monthly data (replace with Firebase later)
  List<Map<String, dynamic>> get monthlyData => [
    {"month": DateTime(2026, 3), "totalKm": 1240},
    {"month": DateTime(2026, 2), "totalKm": 980},
    {"month": DateTime(2026, 1), "totalKm": 1500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment History")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: monthlyData.length,
        itemBuilder: (context, index) {
          final data = monthlyData[index];

          final DateTime monthDate = data["month"];
          final double totalKm = (data["totalKm"] as num).toDouble();
          final double totalAmount = totalKm * ratePerKm;

          final String monthName = DateFormat.yMMMM().format(
            monthDate,
          ); // March 2026

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),

              // LEFT SIDE
              title: Text(
                monthName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text("Total Distance: ${totalKm.toStringAsFixed(0)} km"),
                  Text("Rate: ₹${ratePerKm.toStringAsFixed(0)} / km"),
                ],
              ),

              // RIGHT SIDE (Amount)
              trailing: Text(
                "₹${totalAmount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),

              onTap: () {
                // Optional: open detailed breakdown later
              },
            ),
          );
        },
      ),
    );
  }
}
