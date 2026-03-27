import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSearchScreen extends StatelessWidget {
  const AdminSearchScreen({super.key});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Admin Search Screen",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(user?.email ?? "No Email"),
          const SizedBox(height: 30),
          ElevatedButton(onPressed: _logout, child: const Text("Logout")),
        ],
      ),
    );
  }
}
