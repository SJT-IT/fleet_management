import 'package:fleet_management/screens/auth/auth.dart';
import 'package:fleet_management/screens/roles/admin.dart';
import 'package:fleet_management/screens/roles/dealer.dart';
import 'package:fleet_management/screens/roles/driver.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String?> getUserRole(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      return doc['role'];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not logged in
        if (!snapshot.hasData) {
          return const AuthPage();
        }

        final user = snapshot.data!;

        // Logged in → fetch role
        return FutureBuilder<String?>(
          future: getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data;

            if (role == "Admin") return const AdminScreen();
            if (role == "Dealer") return const DealerScreen();
            if (role == "Driver") return const DriverScreen();

            return const Scaffold(
              body: Center(child: Text("Role not assigned")),
            );
          },
        );
      },
    );
  }
}
