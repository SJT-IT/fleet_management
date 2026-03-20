import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main Authentication Page (Login / Signup)
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Flag to toggle between Login and Sign Up
  bool isLogin = true;

  //  Controllers for input fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers to free memory
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Function to handle login/signup submission
  void _submit() async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final authService = AuthService();

    try {
      if (isLogin) {
        // Login flow
        await authService.login(email, password);
      } else {
        // Sign Up flow
        final confirmPassword = _confirmPasswordController.text.trim();

        if (password != confirmPassword) {
          if (!mounted) return; // Ensure widget is still in tree
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")),
          );
          return;
        }

        await authService.signup(email, password);
      }

      if (!mounted) return; // AuthWrapper will handle navigation automatically

    } on FirebaseAuthException catch (e) {
      if (!mounted) return; 
      String message = "Authentication failed";

      // Handle Firebase specific errors
      if (e.code == 'user-not-found') {
        message = "No user found for that email";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password";
      } else if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return; 
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggle(), //  Login / Sign Up toggle
                  const SizedBox(height: 30),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      //  Smooth fade + slide transition between forms
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.2, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: isLogin ? _loginForm() : _signupForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build the toggle buttons (Login / Sign Up)
  Widget _buildToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tabItem("Login", true),
        const SizedBox(width: 20),
        _tabItem("Sign Up", false),
      ],
    );
  }

  // Single toggle tab widget
  Widget _tabItem(String title, bool tabLogin) {
    final active = isLogin == tabLogin;

    return GestureDetector(
      onTap: () => setState(() => isLogin = tabLogin),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 2,
            width: active ? 40 : 0, //  Active tab underline
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  // Login Form
  Widget _loginForm() {
    return Column(
      key: const ValueKey("login"), // For AnimatedSwitcher
      children: [
        _inputField(controller: _emailController, label: "Email"),
        const SizedBox(height: 15),
        _inputField(
          controller: _passwordController,
          label: "Password",
          isPassword: true,
        ),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {}, // Forgot password functionality placeholder
            child: const Text("Forgot Password?"),
          ),
        ),

        const SizedBox(height: 10),
        _mainButton("LOGIN"), // Submit button

        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => setState(() => isLogin = false),
          child: const Text.rich(
            TextSpan(
              text: "Don't have an account? ",
              children: [
                TextSpan(
                  text: "SIGN UP",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Sign Up Form
  Widget _signupForm() {
    return Column(
      key: const ValueKey("signup"), // For AnimatedSwitcher
      children: [
        _inputField(controller: _emailController, label: "Email"),
        const SizedBox(height: 15),
        _inputField(
          controller: _passwordController,
          label: "Password",
          isPassword: true,
        ),
        const SizedBox(height: 15),
        _inputField(
          controller: _confirmPasswordController,
          label: "Confirm Password",
          isPassword: true,
        ),

        const SizedBox(height: 20),
        _mainButton("SIGN UP"),

        const SizedBox(height: 15),
        GestureDetector(
          onTap: () => setState(() => isLogin = true),
          child: const Text.rich(
            TextSpan(
              text: "Already have an account? ",
              children: [
                TextSpan(
                  text: "LOGIN",
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Input Field Widget
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword, // Hide password if true
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Required"; // Simple validation
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
    );
  }

  // Main Button Widget (Login / Sign Up)
  Widget _mainButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}