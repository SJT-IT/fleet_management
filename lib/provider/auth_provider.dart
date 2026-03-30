import 'package:fleet_management/services/auth_service.dart';
import 'package:flutter/material.dart';

class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _authService.login(email, password);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

      await _authService.signup(email, password, fullName: name, phone: phone);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
