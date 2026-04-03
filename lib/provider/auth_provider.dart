import 'package:fleet_management/repositories/user_repository.dart';
import 'package:fleet_management/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserRepository _userRepo = UserRepository();

  bool isLoading = false;
  String? error;
  String? successMessage;
  String? currentUserRole;
  User? user;

  // CONSTRUCTOR → Initialize auth listener
  AppAuthProvider() {
    _initAuthListener();
  }

  // LISTEN TO FIREBASE AUTH STATE
  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      user = firebaseUser;

      if (user != null) {
        try {
          currentUserRole = await _userRepo.getUserRole(user!.uid);

          if (currentUserRole == null) {
            await _authService.logout();
            user = null;
            error = "You are not registered with us";
          }
        } catch (e) {
          error = "Failed to fetch user role";
        }
      } else {
        currentUserRole = null;
      }

      notifyListeners();
    });
  }

  Future<void> _executeAsync(Future<void> Function() action) async {
    try {
      isLoading = true;
      error = null;
      successMessage = null;
      notifyListeners();

      await action();
    } catch (e) {
      if (e is FirebaseAuthException) {
        error = _getFriendlyError(e);
      } else {
        error = e.toString();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // LOGIN (simplified)
  Future<void> login(String email, String password) async {
    await _executeAsync(() async {
      final loggedInUser = await _authService.login(email, password);

      if (loggedInUser == null) {
        throw Exception("Login failed");
      }

      // ❌ DO NOT set user or role here
      // Listener will handle it automatically
    });
  }

  // Signup
  Future<void> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
  }) async {
    if (password != confirmPassword) {
      throw Exception("Passwords do not match");
    }

    await _executeAsync(() async {
      final newUser = await _authService.signup(
        email,
        password,
        fullName: name,
        phone: phone,
      );

      if (newUser == null) {
        throw Exception("Signup failed");
      }

      successMessage = "Account created successfully";

      // Listener will handle user + role
    });
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    await _executeAsync(() async {
      await _authService.resetPassword(email);
      successMessage = "Password reset link sent to your email";
    });
  }

  // LOGOUT
  Future<void> logout() async {
    await _executeAsync(() async {
      await _authService.logout();
      user = null;
      currentUserRole = null;
    });
  }

  // FRIENDLY ERRORS
  String _getFriendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
