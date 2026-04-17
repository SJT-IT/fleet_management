import 'package:fleet_management/shared/screens/odo_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';
import 'package:fleet_management/provider/auth_provider.dart';
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
    OdoUIScreen(
      vehicleId: "abc123",
      speed: 48,
      alarm: 'no alarm',
      soc: '100',
      voltage: '99',
      temp: '98',
      current: '97',
      odometer: '96',
      latitude: '95',
      longitude: '94',
      timestamp: '2025-03-10 11:04:00',
      sliderValue: 10,
      maxSlider: 10,
      onSliderChanged: (double value) {},
      prevMonthDistance: null,
      currentMonthDistance: null,
      runningMonthDistance: null,
    ), // Odometer tab
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
    final auth = context.watch<AppAuthProvider>();
    final userEmail = auth.user?.email ?? "Driver";

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
          child: Container(
            color: const Color(0xFFF5F7FA),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: const [
                _VehicleCard(),
                _DealershipCard(),
                _QuickActions(),
                _ComplaintStatsCard(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// VEHICLE CARD

class _VehicleCard extends StatelessWidget {
  const _VehicleCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      child: Column(
        children: [
          _title("ASSIGNED VEHICLE"),
          const SizedBox(height: 15),

          _infoRow(Icons.directions_car, "Model", "Ather 450X"),
          _infoRow(Icons.confirmation_number, "Reg No", "MH12AB1234"),
          _statusChip("Active"),
        ],
      ),
    );
  }
}

// DEALERSHIP CARD

class _DealershipCard extends StatelessWidget {
  const _DealershipCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      child: Column(
        children: [
          _title("DEALERSHIP INFO"),
          const SizedBox(height: 15),

          _infoRow(Icons.store, "Name", "Pune EV Motors"),
          _infoRow(Icons.phone, "Contact", "+91 9876543210"),
        ],
      ),
    );
  }
}

// QUICK ACTIONS

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      child: Column(
        children: [
          _title("QUICK ACTIONS"),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.report_problem,
                  label: "Report Issue",
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _actionButton(
                  icon: Icons.list_alt,
                  label: "My Complaints",
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _actionButton(
                  icon: Icons.support_agent,
                  label: "Support",
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// COMPLAINT STATS


class _ComplaintStatsCard extends StatelessWidget {
  const _ComplaintStatsCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      child: Column(
        children: [
          _title("COMPLAINT STATUS"),
          const SizedBox(height: 15),

          _statTile("Pending", "2", Colors.orange),
          _statTile("In Progress", "1", Colors.blue),
          _statTile("Resolved", "5", Colors.green),
        ],
      ),
    );
  }
}

// REUSABLE (MATCHES YOUR ODO STYLE)

Widget _cardWrapper({required Widget child}) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    elevation: 16,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    child: Padding(padding: const EdgeInsets.all(20), child: child),
  );
}

Widget _title(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget _infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget _statusChip(String status) {
  final active = status.toLowerCase() == "active";

  return Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color: active ? Colors.green.withAlpha(40) : Colors.red,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status.toUpperCase(),
      style: TextStyle(
        color: active ? Colors.green : Colors.white,
        fontWeight: FontWeight.bold,
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

Widget _statTile(String label, String value, Color color) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withAlpha(25),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.show_chart, color: color),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
