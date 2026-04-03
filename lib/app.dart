import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/screens/auth/auth.dart';
import 'package:fleet_management/screens/roles/admin/admin.dart';
import 'package:fleet_management/screens/roles/dealer/dealer.dart';
import 'package:fleet_management/screens/roles/driver/driver.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppAuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fleet Management',
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasShownError = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final user = auth.user;

    // Show spinner if loading
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Show AuthPage if not logged in
    if (user == null) {
      _showErrorSnackbar(auth);
      return const AuthPage();
    }

    // If logged in but there is an error (like user not in Firestore)
    if (auth.error != null) {
      _showErrorSnackbar(auth);
      return const AuthPage();
    }

    // User logged in → check role and redirect
    switch (auth.currentUserRole) {
      case 'Admin':
        return const AdminScreen();
      case 'Dealer':
        return const DealerScreen();
      case 'Driver':
        return const DriverScreen();
      default:
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Role not assigned. Please contact admin or try logging in again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Log out the user and reset provider state
                      final auth = context.read<AppAuthProvider>();
                      await auth.logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  void _showErrorSnackbar(AppAuthProvider auth) {
    if (auth.error != null && !_hasShownError) {
      _hasShownError = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(auth.error!)));
      });
    }
  }
}
