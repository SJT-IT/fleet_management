import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/screens/roles/dealer/dealer_odo.dart';
import 'package:fleet_management/screens/roles/dealer/dealer_profile.dart';
import 'package:fleet_management/screens/roles/dealer/dealer_search.dart';

class DealerScreen extends StatefulWidget {
  const DealerScreen({super.key});

  @override
  State<DealerScreen> createState() => _DealerScreenState();
}

class _DealerScreenState extends State<DealerScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  // Pages for each tab
  late final List<Widget> _pages = [
    const DealerHomeContent(), // Home tab
    const DealerSearchScreen(), // Search tab
    const DealerOdoScreen(dealerId: '', dealerName: ''), // Odometer tab
    const DealerProfileScreen(), // Profile tab
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
class DealerHomeContent extends StatelessWidget {
  const DealerHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
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
                      "Dealer Control Panel",
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
                _HeaderRow(),
                _SummaryCards(),
                _DriverListCard(),
                _VehicleListCard(),
                _ComplaintListCard(),
                _QuickActionsDealer(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.business, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Text(
            "Dealer Panel",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _summaryTile("Drivers", "24", Colors.blue)),
        Expanded(child: _summaryTile("Vehicles", "18", Colors.green)),
        Expanded(child: _summaryTile("Complaints", "6", Colors.red)),
      ],
    );
  }
}

Widget _summaryTile(String title, String value, Color color) {
  return Card(
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
  );
}

class _DriverListCard extends StatelessWidget {
  const _DriverListCard();

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
            subtitle: const Text("Status: Active"),
          ),
        ),
      ),
    );
  }
}

class _VehicleListCard extends StatelessWidget {
  const _VehicleListCard();

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

class _ComplaintListCard extends StatelessWidget {
  const _ComplaintListCard();

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
            subtitle: const Text("Pending"),
          ),
        ),
      ),
    );
  }
}

class _QuickActionsDealer extends StatelessWidget {
  const _QuickActionsDealer();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "QUICK ACTIONS",
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              icon: Icons.assignment,
              label: "Assign",
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionButton(
              icon: Icons.build,
              label: "Update Vehicle",
              color: Colors.orange,
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
