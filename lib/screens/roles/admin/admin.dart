import 'package:fleet_management/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';
import 'package:fleet_management/screens/roles/admin/admin_search.dart';
import 'package:fleet_management/screens/roles/admin/admin_odo.dart';
import 'package:fleet_management/screens/roles/admin/admin_profile.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  // Pages for each tab
  late final List<Widget> _pages = [
    const AdminHomeContent(), // Home tab
    const AdminSearchScreen(), // Search tab
    const AdminOdoScreen(), // Odometer tab
    const AdminProfileScreen(), // Profile tab
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
class AdminHomeContent extends StatelessWidget {
  const AdminHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final userName = auth.fullName ?? auth.user?.email ?? "Admin";

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
                      "Welcome, $userName",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Admin Panel",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFF5F7FA),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: const [
                _AdminHeader(),
                _AdminSummary(),
                _DealershipListCard(),
                _DriverListCardAdmin(),
                _VehicleListCardAdmin(),
                _ComplaintListCardAdmin(),
                _AdminTools(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.admin_panel_settings, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Text(
            "Admin Control",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _AdminSummary extends StatelessWidget {
  const _AdminSummary();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _summaryTile("Dealers", "12", Colors.blue),
        _summaryTile("Drivers", "48", Colors.green),
        _summaryTile("Vehicles", "36", Colors.orange),
        _summaryTile("Complaints", "9", Colors.red),
      ],
    );
  }
}

Widget _summaryTile(String title, String value, Color color) {
  return SizedBox(
    width:
        // ignore: deprecated_member_use
        MediaQueryData.fromView(WidgetsBinding.instance.window).size.width / 2 -
        16,
    child: Card(
      margin: const EdgeInsets.all(8),
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ),
  );
}

class _DealershipListCard extends StatelessWidget {
  const _DealershipListCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "DEALERSHIPS",
      child: Column(
        children: List.generate(
          3,
          (i) => ListTile(
            leading: const Icon(Icons.store),
            title: Text("Dealer $i"),
            subtitle: const Text("Pune"),
          ),
        ),
      ),
    );
  }
}

class _DriverListCardAdmin extends StatelessWidget {
  const _DriverListCardAdmin();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "DRIVERS",
      child: Column(
        children: List.generate(
          3,
          (i) => ListTile(
            leading: const Icon(Icons.person),
            title: Text("Driver $i"),
            subtitle: const Text("Active"),
          ),
        ),
      ),
    );
  }
}

class _VehicleListCardAdmin extends StatelessWidget {
  const _VehicleListCardAdmin();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "VEHICLES",
      child: Column(
        children: List.generate(
          3,
          (i) => ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text("Vehicle $i"),
            subtitle: const Text("Active"),
          ),
        ),
      ),
    );
  }
}

class _ComplaintListCardAdmin extends StatelessWidget {
  const _ComplaintListCardAdmin();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "COMPLAINTS",
      child: Column(
        children: List.generate(
          3,
          (i) => ListTile(
            leading: const Icon(Icons.report_problem, color: Colors.red),
            title: Text("Complaint $i"),
            subtitle: const Text("High Priority"),
          ),
        ),
      ),
    );
  }
}

class _AdminTools extends StatelessWidget {
  const _AdminTools();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "ADMIN TOOLS",
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              icon: Icons.manage_accounts,
              label: "Users",
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionButton(
              icon: Icons.settings,
              label: "Settings",
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _cardWrapper({required String title, required Widget child}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    elevation: 16,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          child,
        ],
      ),
    ),
  );
}

Widget _actionButton({
  required IconData icon,
  required String label,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: color.withAlpha(30),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
