import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';

class SalesExecutiveScreen extends StatefulWidget {
  const SalesExecutiveScreen({super.key});

  @override
  State<SalesExecutiveScreen> createState() =>
      SalesExecutiveScreenDashboardState();
}

class SalesExecutiveScreenDashboardState extends State<SalesExecutiveScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  List<Widget> get _pages => [
    const BatteryAllocationHome(),
    const Center(child: Text("Search Batteries")),
    const Center(child: Text("History")),
    const Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AppNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/* ---------------- HOME ---------------- */

class BatteryAllocationHome extends StatelessWidget {
  const BatteryAllocationHome({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final userName = auth.fullName ?? auth.user?.email ?? "User";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          floating: true,
          centerTitle: false,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text("Battery Allocation"),
            titlePadding: const EdgeInsets.only(left: 16, bottom: 10),
            background: Container(
              color: Colors.green,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.battery_charging_full,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Welcome, $userName",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Dealer Battery Assignment Control",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
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
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              children: const [
                _AllocationOverview(),
                _AvailableBatteryPool(),
                _InServiceSection(),
                _AssignedSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/* ---------------- OVERVIEW ---------------- */

class _AllocationOverview extends StatelessWidget {
  const _AllocationOverview();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: const [
        _SummaryTile(
          title: "Available",
          value: "18",
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _SummaryTile(
          title: "In Service",
          value: "6",
          icon: Icons.build,
          color: Colors.orange,
        ),
        _SummaryTile(
          title: "Assigned",
          value: "24",
          icon: Icons.link,
          color: Colors.blue,
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- AVAILABLE (MAIN ACTION AREA) ---------------- */

class _AvailableBatteryPool extends StatelessWidget {
  const _AvailableBatteryPool();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "AVAILABLE FOR ALLOCATION",
      child: const Column(
        children: [
          _BatteryTile(id: "BAT-1001", soc: "92%"),
          _BatteryTile(id: "BAT-1002", soc: "89%"),
          _BatteryTile(id: "BAT-1003", soc: "95%"),
        ],
      ),
    );
  }
}

/* ---------------- IN SERVICE ---------------- */

class _InServiceSection extends StatelessWidget {
  const _InServiceSection();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "IN SERVICE (UNAVAILABLE)",
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.build, color: Colors.orange),
            title: Text("BAT-2001"),
            subtitle: Text("Under maintenance"),
          ),
          ListTile(
            leading: Icon(Icons.build, color: Colors.orange),
            title: Text("BAT-2002"),
            subtitle: Text("Diagnostics ongoing"),
          ),
        ],
      ),
    );
  }
}

/* ---------------- ASSIGNED ---------------- */

class _AssignedSection extends StatelessWidget {
  const _AssignedSection();

  @override
  Widget build(BuildContext context) {
    return _CardWrapper(
      title: "ASSIGNED TO DEALERS",
      child: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.link, color: Colors.blue),
            title: Text("BAT-3001 → Dealer A"),
          ),
          ListTile(
            leading: Icon(Icons.link, color: Colors.blue),
            title: Text("BAT-3002 → Dealer B"),
          ),
        ],
      ),
    );
  }
}

/* ---------------- BATTERY TILE ---------------- */

class _BatteryTile extends StatelessWidget {
  final String id;
  final String soc;

  const _BatteryTile({required this.id, required this.soc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.battery_full, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(id, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("SOC: $soc"),
              ],
            ),
          ),
          const Text(
            "AVAILABLE",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

/* ---------------- SHARED ---------------- */

class _CardWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const _CardWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
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
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
