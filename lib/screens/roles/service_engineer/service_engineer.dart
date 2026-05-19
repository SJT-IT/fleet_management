import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/screens/roles/service_engineer/service_eng_profile.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceEngineerScreen extends StatefulWidget {
  const ServiceEngineerScreen({super.key});

  @override
  State<ServiceEngineerScreen> createState() => _ServiceEngineerScreenState();
}

class _ServiceEngineerScreenState extends State<ServiceEngineerScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  List<Widget> get _pages => [
        const ServiceEngineerHomeContent(),
        const Center(child: Text("Vehicle Search")),
        const Center(child: Text("Diagnostics / ODO")),
        const ServiceProfileScreen(),
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

class ServiceEngineerHomeContent extends StatelessWidget {
  const ServiceEngineerHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    final userName =
        auth.fullName ?? auth.user?.email ?? "Service Engineer";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          floating: true,
          centerTitle: false, // FIXED for consistency

          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16, bottom: 6),
            title: const Text("Service Dashboard"),
            background: Container(
              color: const Color(0xFFFF6F00),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.engineering,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Welcome, $userName",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Vehicle Diagnostics & Maintenance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 🔥 Better sliver structure (performance improvement)
        SliverToBoxAdapter(
          child: Container(
            color: const Color(0xFFF5F7FA),
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Column(
              children: [
                const _FleetHealthSummary(),
                const _CriticalAlertsCard(),
                const _ComplaintsQueueCard(),
                const _MaintenanceScheduleCard(),
                const _QuickActionsCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FleetHealthSummary extends StatelessWidget {
  const _FleetHealthSummary();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _summaryTile(
          context,
          "Active",
          "42",
          Icons.directions_car,
          Colors.green,
        ),
        _summaryTile(
          context,
          "In Service",
          "6",
          Icons.build,
          Colors.orange,
        ),
        _summaryTile(
          context,
          "Critical",
          "3",
          Icons.warning,
          Colors.red,
        ),
        _summaryTile(
          context,
          "Complaints",
          "11",
          Icons.report_problem,
          Colors.blue,
        ),
      ],
    );
  }
}

Widget _summaryTile(
  BuildContext context,
  String title,
  String value,
  IconData icon,
  Color color,
) {
  final width = MediaQuery.of(context).size.width / 2 - 16;

  return SizedBox(
    width: width,
    child: Card(
      margin: const EdgeInsets.all(8),
      elevation: 14,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
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

class _CriticalAlertsCard extends StatelessWidget {
  const _CriticalAlertsCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "CRITICAL ALERTS",
      child: Column(
        children: const [
          _AlertTile(
            icon: Icons.battery_alert,
            color: Colors.red,
            title: "Battery Overheating",
            subtitle: "MH12AB1234 • Temp above safe limit",
          ),
          _AlertTile(
            icon: Icons.electrical_services,
            color: Colors.orange,
            title: "Voltage Instability",
            subtitle: "MH14XY7788 • Inspection required",
          ),
          _AlertTile(
            icon: Icons.location_off,
            color: Colors.blueGrey,
            title: "Vehicle Offline",
            subtitle: "MH01PQ9090 • Last sync 3h ago",
          ),
        ],
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _AlertTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(30),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}

class _ComplaintsQueueCard extends StatelessWidget {
  const _ComplaintsQueueCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "ACTIVE COMPLAINTS",
      child: Column(
        children: [
          _complaintTile(
            vehicle: "MH12AB1234",
            issue: "Battery Heating",
            priority: "HIGH",
            color: Colors.red,
          ),
          _complaintTile(
            vehicle: "MH14CD5678",
            issue: "Brake Sensor Fault",
            priority: "MEDIUM",
            color: Colors.orange,
          ),
          _complaintTile(
            vehicle: "MH01EF1111",
            issue: "Display Malfunction",
            priority: "LOW",
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}

Widget _complaintTile({
  required String vehicle,
  required String issue,
  required String priority,
  required Color color,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withAlpha(20),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(Icons.report_problem, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(issue),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            priority,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MaintenanceScheduleCard extends StatelessWidget {
  const _MaintenanceScheduleCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "UPCOMING MAINTENANCE",
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.build_circle, color: Colors.orange),
            title: Text("Brake Inspection"),
            subtitle: Text("Vehicle MH12AB1234"),
          ),
          ListTile(
            leading: Icon(Icons.battery_charging_full, color: Colors.green),
            title: Text("Battery Health Check"),
            subtitle: Text("Vehicle MH14XY7788"),
          ),
          ListTile(
            leading: Icon(Icons.system_update, color: Colors.blue),
            title: Text("Firmware Update"),
            subtitle: Text("Vehicle MH01PQ9090"),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return _cardWrapper(
      title: "QUICK ACTIONS",
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              icon: Icons.analytics,
              label: "Run Diagnostics",
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _actionButton(
              icon: Icons.assignment_turned_in,
              label: "Resolve Issue",
              color: Colors.green,
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
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
          const SizedBox(height: 16),
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
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(
      color: color.withAlpha(25),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}