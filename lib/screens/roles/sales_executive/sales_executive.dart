import 'package:fleet_management/screens/roles/sales_executive/sales_exe_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';

class SalesExecutiveScreen extends StatefulWidget {
  const SalesExecutiveScreen({super.key});

  @override
  State<SalesExecutiveScreen> createState() => _SalesExecutiveScreenState();
}

class _SalesExecutiveScreenState extends State<SalesExecutiveScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  late final List<Widget> _pages = [
    const SalesExecutiveHomeContent(),
    const Center(child: Text("Search")),
    const Center(child: Text("ODO")),
    const SalesProfileScreen(),
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

class SalesExecutiveHomeContent extends StatelessWidget {
  const SalesExecutiveHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final userName = auth.fullName ?? auth.user?.email ?? "Sales Executive";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text("Sales Executive"),
            background: Container(
              color: Colors.green,
              child: Center(
                child: Text(
                  "Welcome, $userName",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(Icons.point_of_sale, size: 80, color: Colors.green),
                    SizedBox(height: 20),
                    Text(
                      "Sales Executive Dashboard",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome user. Sales tools will appear here.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
