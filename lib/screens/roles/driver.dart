import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
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
            const Text("Welcome Driver Screen", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text(user?.email ?? "No Email"),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _logout, child: const Text("Logout")),
          ],
        ),
      ),
    );
  }
}
