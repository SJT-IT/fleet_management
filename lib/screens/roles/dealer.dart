import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleet_management/widgets/navbar.dart';
import 'package:fleet_management/screens/odometer/dealer_odo.dart';
import 'package:fleet_management/screens/profile/dealer_profile.dart';
import 'package:fleet_management/screens/search/dealer_search.dart';

class DealerScreen extends StatefulWidget {
  const DealerScreen({super.key});

  @override
  State<DealerScreen> createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  int _currentIndex = 0;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  // 👇 Pages for each tab
  late final List<Widget> _pages = [
    const DealerHomeContent(),
    const DealerSearchScreen(),
    const DealerOdoScreen(),
    const DealerProfileScreen(),
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
class DealerHomeContent extends StatelessWidget {
  const DealerHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome Dealer Home Screen",
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
