import 'package:fleet_management/screens/roles/admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_management/widgets/navbar.dart';
import 'package:fleet_management/screens/odometer/admin_odo.dart';
import 'package:fleet_management/screens/profile/admin_profile.dart';

class AdminSearchScreen extends StatefulWidget {
  const AdminSearchScreen({super.key});

  @override
  State<AdminSearchScreen> createState() => _AdminSearchScreenState();
}

class _AdminSearchScreenState extends State<AdminSearchScreen> {
  int _currentIndex = 0;

  final user = FirebaseAuth.instance.currentUser;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Tab content widgets
  final List<Widget> _tabs = [];

  @override
  void initState() {
    super.initState();

    // Initialize tab widgets only once
    _tabs.addAll([
      _buildHomeTab(),
      const AdminScreen(),
      const AdminOdoScreen(),
      const AdminProfileScreen(),
    ]);
  }

  /// Build the Home tab separately (with logout)
  Widget _buildHomeTab() {
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

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    // No navigation needed; IndexedStack handles switching
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fleet Management"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
