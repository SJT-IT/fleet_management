import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_management/widgets/navbar.dart';
import 'package:fleet_management/screens/roles/admin/admin_search.dart';
import 'package:fleet_management/screens/roles/admin/admin_odo.dart';
import 'package:fleet_management/screens/roles/admin/admin_profile.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  // 👇 Pages for each tab
  late final List<Widget> _pages = [
    const AdminHomeContent(),
    const AdminSearchScreen(),
    const AdminOdoScreen(),
    const AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fleet Management"),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),

      // Switch content instead of navigating
      body: _pages[_currentIndex],

      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

//  Extracted Home Content (your original body)
class AdminHomeContent extends StatelessWidget {
  const AdminHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Admin Home Screen",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(user?.email ?? "No Email"),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
