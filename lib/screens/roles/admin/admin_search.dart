import 'package:fleet_management/screens/roles/dealer/dealer_odo.dart';
import 'package:flutter/material.dart';

class AdminSearchScreen extends StatefulWidget {
  const AdminSearchScreen({super.key});

  @override
  State<AdminSearchScreen> createState() => _AdminSearchScreenState();
}

class _AdminSearchScreenState extends State<AdminSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Dummy dealer data (replace with Firestore)
  final List<Map<String, String>> allDealers = [
    {
      "id": "dealer_001",
      "name": "Pune Fleet Services",
      "location": "Pune",
    },
    {
      "id": "dealer_002",
      "name": "Mumbai Transport Hub",
      "location": "Mumbai",
    },
    {
      "id": "dealer_003",
      "name": "Nashik Logistics",
      "location": "Nashik",
    },
  ];

  List<Map<String, String>> filteredDealers = [];

  @override
  void initState() {
    super.initState();
    filteredDealers = allDealers;
  }

  void _filterDealers(String query) {
    final results = query.isEmpty
        ? allDealers
        : allDealers.where((d) {
            final name = d["name"]!.toLowerCase();
            final location = d["location"]!.toLowerCase();

            return name.contains(query.toLowerCase()) ||
                location.contains(query.toLowerCase());
          }).toList();

    setState(() {
      filteredDealers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Dealer"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔹 Search bar
            TextField(
              controller: _searchController,
              onChanged: _filterDealers,
              decoration: InputDecoration(
                hintText: "Search dealer...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Dealer list
            Expanded(
              child: filteredDealers.isEmpty
                  ? const Center(child: Text("No dealers found"))
                  : ListView.builder(
                      itemCount: filteredDealers.length,
                      itemBuilder: (context, index) {
                        final d = filteredDealers[index];

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.business),
                            ),

                            title: Text(
                              d["name"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(d["location"]!),

                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                            onTap: () {
                              // 🔥 Navigate to Dealer Vehicles Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DealerOdoScreen(
                                    dealerId: d["id"]!,
                                    dealerName: d["name"]!,
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