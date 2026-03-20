import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 Login
  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // 🔹 Sign Up
  Future<User?> signup(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // 🔹 Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}