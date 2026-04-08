import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/widgets/navbar.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/screens/roles/driver/driver_odo.dart';
import 'package:fleet_management/screens/roles/driver/driver_profile.dart';
import 'package:fleet_management/screens/roles/driver/driver_search.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  // Pages for each tab
  late final List<Widget> _pages = [
    const DriverHomeContent(), // Home tab
    const DriverSearchScreen(), // Search tab
    const DriverOdoScreen(), // Odometer tab
    const DriverProfileScreen(), // Profile tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed from scaffold because each page can handle its own SliverAppBar
      body: _pages[_currentIndex],
      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ----------------- Home Content with Collapsible Header -----------------
class DriverHomeContent extends StatelessWidget {
  const DriverHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Use provider, not FirebaseAuth directly
    final auth = context.watch<AppAuthProvider>();
    final userEmail = auth.user?.email ?? "Dealer";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text("Fleet Dashboard"),
            background: Container(
              color: Colors.blueAccent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome, $userEmail",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Your fleet overview",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: const Text(
              "Fleet Vehicles",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text("Vehicle $index"),
                subtitle: const Text("Status: Active"),
              ),
            ),
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
