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

  // Private flag to prevent listener conflicts during logout
  final bool _isLoggingOut = false;

  // ------------------ Constructor ------------------
  AppAuthProvider() {
    _initAuthListener();
  }

  // ------------------ Auth State Listener ------------------
  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      // Ignore changes while logging out
      if (_isLoggingOut) return;

      user = firebaseUser;

      if (user != null) {
        try {
          final role = await _userRepo.getUserRole(user!.uid);
          if (role != null) {
            currentUserRole = role;
            error = null; // clear previous errors
          } else {
            currentUserRole = null;
            error = null; // do NOT force logout if role missing
          }
        } catch (e) {
          currentUserRole = null;
          error = null; // do NOT force logout if fetch fails
        }
      } else {
        currentUserRole = null;
        error = null;
      }

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
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ------------------ LOGIN ------------------
  Future<void> login(String email, String password) async {
    await _executeAsync(() async {
      final loggedInUser = await _authService.login(email, password);
      if (loggedInUser == null) {
        throw Exception("Login failed");
      }
      // ❌ user & role will be set by listener
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

  // ------------------ RESET PASSWORD ------------------
  Future<void> resetPassword(String email) async {
    await _executeAsync(() async {
      await _authService.resetPassword(email);
      successMessage = "Password reset link sent to your email";
    });
  }

  // ------------------ LOGOUT ------------------
  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    // Clear local provider state immediately
    user = null;
    currentUserRole = null;
    error = null;
    successMessage = null;

    try {
      await _authService.logout(); // sign out from Firebase
    } catch (e) {
      error = e.toString();
    } finally {
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
