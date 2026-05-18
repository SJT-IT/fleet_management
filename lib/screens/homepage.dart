import 'package:flutter/material.dart';

/// Deprecated:
/// AuthWrapper now handles all authentication
/// and role-based navigation.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'HomePage is deprecated.\nUse AuthWrapper instead.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
