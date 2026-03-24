import 'package:fleet_management/screens/roles/admin.dart';
import 'package:fleet_management/screens/roles/dealer.dart';
import 'package:fleet_management/screens/roles/driver.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      return doc['role']; // e.g. "Admin", "Dealer", "Driver"
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final role = await getUserRole();

    if (!mounted) return;

    if (role == "Admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
    } else if (role == "Dealer") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DealerScreen()),
      );
    } else if (role == "Driver") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DriverScreen()),
      );
    } else {
      // fallback if role missing
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Role not assigned")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fleet Management"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome 👋", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),

            Text(
              user?.email ?? "No Email",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            ElevatedButton(onPressed: _logout, child: const Text("Logout")),
          ],
        ),
      ),
    );
  }
}
