import 'package:fleet_management/repositories/user_repository.dart';
import 'package:fleet_management/services/auth_service.dart';
import 'package:flutter/material.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserRepository _userRepo = UserRepository();

  bool isLoading = false;
  String? error;
  String? currentUserRole;

  // Login
  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final user = await _authService.login(email, password);

      if (user != null) {
        currentUserRole = await _userRepo.getUserRole(user.uid);

        if (currentUserRole == null) {
          // User exists in Auth but not in Firestore
          error = "You are not registered with us";
          await _authService.logout(); // log them out immediately
        }
      } else {
        error = "Login failed";
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
      error = "Passwords do not match";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final user = await _authService.signup(
        email,
        password,
        fullName: name,
        phone: phone,
      );

      if (user != null) {
        currentUserRole = await _userRepo.getUserRole(user.uid);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    currentUserRole = null;
    notifyListeners();
  }
}
