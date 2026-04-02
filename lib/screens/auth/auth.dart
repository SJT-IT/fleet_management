import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:fleet_management/provider/auth_provider.dart';
import 'package:fleet_management/screens/auth/forgot_password.dart';

// Main Authentication Page widget
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  // NEW: Password visibility states
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  // Regex
  final phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$&*~]).{6,14}$');

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AppAuthProvider>();

    if (isLogin) {
      await auth.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } else {
      await auth.signup(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        confirmPassword: _confirmPasswordController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }

    if (auth.error != null && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(auth.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              _buildCard(),
              if (auth.isLoading)
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToggle(),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: isLogin ? _loginForm() : _signupForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
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
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF22C55E) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
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
          isDark: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _passwordController,
          label: "Password",
          icon: Icons.lock_outline,
          isPassword: true,
          isDark: false,
          isObscured: _isPasswordHidden,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            return null;
          },
          toggleVisibility: () {
            setState(() => _isPasswordHidden = !_isPasswordHidden);
          },
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ForgotPasswordPage(email: _emailController.text.trim()),
                ),
              );
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _mainButton("SIGN IN"),
      ],
    );
  }

  Widget _signupForm() {
    return Column(
      key: const ValueKey("signup"),
      children: [
        _inputField(
          controller: _nameController,
          label: "Full Name",
          icon: Icons.person,
          isDark: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Name is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _phoneController,
          label: "Phone Number",
          icon: Icons.phone,
          isDark: false,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // only numbers allowed
            LengthLimitingTextInputFormatter(11), // limit to 11 digits (India)
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Phone number is required";
            }
            if (value.length < 10 || value.length > 11) {
              return "Enter valid phone number";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _emailController,
          label: "Email",
          icon: Icons.email_outlined,
          isDark: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email is required";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _passwordController,
          label: "Password",
          icon: Icons.lock_outline,
          isPassword: true,
          isDark: false,
          isObscured: _isPasswordHidden,
          toggleVisibility: () {
            setState(() => _isPasswordHidden = !_isPasswordHidden);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Password is required";
            }
            if (!passwordRegex.hasMatch(value)) {
              return "6-14 chars, 1 uppercase & 1 symbol required";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        _inputField(
          controller: _confirmPasswordController,
          label: "Confirm Password",
          icon: Icons.check_circle_outline,
          isPassword: true,
          isDark: false,
          isObscured: _isConfirmPasswordHidden,
          toggleVisibility: () {
            setState(
              () => _isConfirmPasswordHidden = !_isConfirmPasswordHidden,
            );
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Confirm your password";
            }
            if (value != _passwordController.text) {
              return "Passwords do not match";
            }
            return null;
          },
        ),
        const SizedBox(height: 25),
        _mainButton("GET STARTED"),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    required bool isDark,
    String? Function(String?)? validator,
    bool isObscured = false,
    VoidCallback? toggleVisibility,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? isObscured : false,
      validator: validator,
      style: TextStyle(
        color: isDark ? const Color(0xFFF9FAFB) : const Color(0xFF111827),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.white60 : const Color(0xFF6B7280),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF6B7280),
                ),
                onPressed: toggleVisibility,
              )
            : null,
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : const Color(0xFF6B7280),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withAlpha(13)
                : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFF22C55E)),
        ),
      ),
    );
  }

  Widget _mainButton(String text) {
    return Consumer<AppAuthProvider>(
      builder: (context, auth, child) {
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF22C55E),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withAlpha(78),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: auth.isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: auth.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
