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
  String? fullName;

  // ------------------ Constructor ------------------
  AppAuthProvider() {
    _initAuthListener();
  }

  // ------------------ Auth State Listener ------------------
  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      user = firebaseUser;

      if (user != null) {
        try {
          final data = await _userRepo.getUserData(user!.uid);

          // Prevent async race condition
          if (FirebaseAuth.instance.currentUser?.uid == user?.uid) {
            currentUserRole = data?['role'] as String?;
            fullName = data?['fullName'] as String?;
          }
        } catch (e) {
          currentUserRole = null;
          fullName = null;
        }
      } else {
        currentUserRole = null;
        fullName = null;
      }

      // Reset UI states on auth change
      isLoading = false;
      error = null;
      successMessage = null;

      notifyListeners();
    });
  }

  // ------------------ Helper for async actions ------------------
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

      isLoading = false; // Only stop loading on error
      notifyListeners();
    }
    // ❗ No finally block → listener handles success case
  }

  // ------------------ LOGIN ------------------
  Future<void> login(String email, String password) async {
    await _executeAsync(() async {
      final loggedInUser = await _authService.login(email, password);
      if (loggedInUser == null) {
        throw Exception("Login failed");
      }
      // Listener will handle user + role
    });
  }

  // ------------------ SIGNUP ------------------
  Future<void> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
  }) async {
    if (password != confirmPassword) {
      error = "Passwords do not match";
      notifyListeners();
      return;
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

  // ------------------ RESET PASSWORD ------------------
  Future<void> resetPassword(String email) async {
    await _executeAsync(() async {
      await _authService.resetPassword(email);
      successMessage = "Password reset link sent to your email";
    });

    // Reset loading manually since no auth change occurs
    isLoading = false;
    notifyListeners();
  }

  // ------------------ LOGOUT ------------------
  Future<void> logout() async {
    try {
      isLoading = true;
      notifyListeners();

      await _authService.logout(); // Listener will handle cleanup
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ Friendly Firebase Errors ------------------
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
