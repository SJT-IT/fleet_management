import 'package:fleet_management/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  // Sign out function
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
    }
  }

  // Logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final colorScheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to log out?",
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _signOut(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Yes, Logout"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =======================
            // PROFILE SECTION
            // =======================
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text("Admin"),
                subtitle: Text(user?.email ?? "No Email"),
                trailing: const Icon(Icons.edit),
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // SETTINGS SECTION
            // =======================
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("Account Details"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text("Payment History"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text("Notifications"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // SUPPORT SECTION
            // =======================
            Card(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Contact Us"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text("Terms & Conditions"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text("Privacy Policy"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text("Get Help"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // LOGOUT SECTION
            // =======================
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _showLogoutConfirmation(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
