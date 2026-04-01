import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login
  Future<User?> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // Sign Up
  Future<User?> signup(
    String email,
    String password, {
    required String fullName,
    required String phone,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;

    if (user != null) {
      final uid = user.uid;

      await _firestore.collection('users').doc(uid).set({
        'userId': uid,
        'username': email,
        'role': 'Driver',
        'dealerId': null,
        'vehicleId': null,
        'fullName': fullName,
        'phoneNumber': phone,
        'drivingLicenseNumber': "",
        'status': 'pending',
        'isProfileComplete': false,
        'isApproved': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw Exception("Invalid email format");
        case 'user-not-found':
          throw Exception("No account found with this email");
        case 'too-many-requests':
          throw Exception("Too many attempts. Try again later");
        default:
          throw Exception("Something went wrong");
      }
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
