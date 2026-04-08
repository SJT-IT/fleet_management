import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverOdoScreen extends StatelessWidget {
  const DriverOdoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Driver Odo Screen",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(user?.email ?? "No Email"),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
