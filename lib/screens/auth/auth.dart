import 'dart:ui';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // NEW CONTROLLERS
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose(); //
    _phoneController.dispose(); //
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final authService = AuthService();

    try {
      if (isLogin) {
        await authService.login(email, password);
      } else {
        if (password != _confirmPasswordController.text.trim()) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")),
          );
          return;
        }

        // PASS EXTRA DATA
        await authService.signup(
          email,
          password,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 48, 184, 120),
              Color.fromARGB(255, 32, 67, 45),
              Color.fromARGB(255, 15, 39, 24),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildGlassCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1200),
          curve: Curves.elasticOut,
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withAlpha(50), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggle(),
                const SizedBox(height: 40),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  switchInCurve: Curves.easeOutBack,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: isLogin ? _loginForm() : _signupForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _toggleButton("Login", true),
          _toggleButton("Sign Up", false),
        ],
      ),
    );
  }

  Widget _toggleButton(String title, bool tabLogin) {
    bool active = isLogin == tabLogin;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isLogin = tabLogin),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.blueAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      key: const ValueKey("login"),
      children: [
        _inputField(
          controller: _emailController,
          label: "Email",
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _passwordController,
          label: "Password",
          isPassword: true,
          icon: Icons.lock_outline,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _mainButton("SIGN IN"),
      ],
    );
  }

  // UPDATED SIGNUP FORM
  Widget _signupForm() {
    return Column(
      key: const ValueKey("signup"),
      children: [
        _inputField(
          controller: _nameController,
          label: "Full Name",
          icon: Icons.person,
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _phoneController,
          label: "Phone Number",
          icon: Icons.phone,
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _emailController,
          label: "Email",
          icon: Icons.email_outlined,
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _passwordController,
          label: "Password",
          isPassword: true,
          icon: Icons.lock_outline,
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _confirmPasswordController,
          label: "Confirm Password",
          isPassword: true,
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 30),
        _mainButton("GET STARTED"),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withAlpha(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _mainButton(String text) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.cyanAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withAlpha(76),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
