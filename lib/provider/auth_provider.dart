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

  // Generic helper to handle async actions with loading & error handling
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

  // Email validation
  String? _validateEmail(String email) {
    if (email.isEmpty) return "Email is required";
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) return "Enter a valid email";
    return null;
  }

  // Phone validation
  String? _validatePhone(String phone) {
    if (phone.isEmpty) return "Phone number is required";
    final phoneRegex = RegExp(r'^\d{10}$'); // exactly 10 digits
    if (!phoneRegex.hasMatch(phone)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }

  // Login
  Future<void> login(String email, String password) async {
    await _executeAsync(() async {
      final user = await _authService.login(email, password);

      if (user != null) {
        currentUserRole = await _userRepo.getUserRole(user.uid);

        if (currentUserRole == null) {
          error = "You are not registered with us";
          await _authService.logout();
        }
      } else {
        error = "Login failed";
      }
    });
  }

  // Signup with email & phone validation
  Future<void> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phone,
  }) async {
    // Password match check
    if (password != confirmPassword) {
      error = "Passwords do not match";
      notifyListeners();
      return;
    }

    // Email validation
    final emailError = _validateEmail(email);
    if (emailError != null) {
      error = emailError;
      notifyListeners();
      return;
    }

    // Phone validation
    final phoneError = _validatePhone(phone);
    if (phoneError != null) {
      error = phoneError;
      notifyListeners();
      return;
    }

    // Execute Firebase signup
    await _executeAsync(() async {
      final user = await _authService.signup(
        email,
        password,
        fullName: name,
        phone: phone,
      );

      if (user != null) {
        currentUserRole = await _userRepo.getUserRole(user.uid);
        successMessage = "Account created successfully";
      }
    });
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    await _executeAsync(() async {
      await _authService.resetPassword(email);
      successMessage = "Password reset link sent to your email";
    });
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    currentUserRole = null;
    notifyListeners();
  }

  // PRIVATE HELPER: FRIENDLY ERROR MESSAGES
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
