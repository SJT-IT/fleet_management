import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/screens/auth/auth.dart';
import 'package:fleet_management/screens/roles/admin/admin.dart';
import 'package:fleet_management/screens/roles/dealer/dealer.dart';
import 'package:fleet_management/screens/roles/driver/driver.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    // Loading state
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Not logged in
    if (auth.currentUserRole == null) {
      return const AuthPage();
    }

    // Role-based routing
    switch (auth.currentUserRole) {
      case 'Admin':
        return const AdminScreen();
      case 'Dealer':
        return const DealerScreen();
      case 'Driver':
        return const DriverScreen();
      default:
        return const Scaffold(body: Center(child: Text('Role not assigned')));
    }
  }
}
