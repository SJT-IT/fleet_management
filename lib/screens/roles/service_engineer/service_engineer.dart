import 'package:fleet_management/screens/roles/service_engineer/service_eng_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/shared/widgets/navbar.dart';

class ServiceEngineerScreen extends StatefulWidget {
  const ServiceEngineerScreen({super.key});

  @override
  State<ServiceEngineerScreen> createState() => _SerivceEngineerScreenState();
}

class _SerivceEngineerScreenState extends State<ServiceEngineerScreen> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  late final List<Widget> _pages = [
    const ServiceEngineerHomeContent(),
    const Center(child: Text("Search")),
    const Center(child: Text("ODO")),
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
    final userName = auth.fullName ?? auth.user?.email ?? "Service Engineer";

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 160,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text("Service Engineer"),
            background: Container(
              color: Colors.orange,
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
                    Icon(Icons.engineering, size: 80, color: Colors.orange),
                    SizedBox(height: 20),
                    Text(
                      "Service Engineer Dashboard",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Welcome user. Service tools will appear here.",
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
