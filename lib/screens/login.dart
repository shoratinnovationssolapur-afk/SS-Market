import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:ss_market/services/auth.dart';
import 'dashboard.dart';
import 'SignUpScreen.dart';    // Import your signup screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Add Controllers to capture text
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;

  // 2. Login Logic Function
  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = await AuthService().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim()
    );

    setState(() => _isLoading = false);

    if (user != null) {
      // Success: Navigate to Dashboard
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen())
      );
    } else {
      // Failure: Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Email or Password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Globe transformation background
          Hero(
            tag: 'globe_morph',
            child: Positioned(
              top: -100, left: -100,
              child: Container(
                width: 450, height: 450,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)]),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.transparent),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Welcome Back",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 40),

                // Pass controllers to inputs
                _buildGlassInput("Email Address", Icons.alternate_email_rounded, controller: _emailController),
                const SizedBox(height: 20),
                _buildGlassInput(
                  "Password",
                  Icons.lock_outline_rounded,
                  controller: _passwordController,
                  isPass: _isObscure,
                  suffix: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white60),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
                const SizedBox(height: 40),

                // Show loader or button
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF00D2FF))
                    : _buildLoginButton(),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen())
                  ),
                  child: const Text(
                      "New here? Create an account",
                      style: TextStyle(color: Colors.white70)
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput(String hint, IconData icon, {required TextEditingController controller, bool isPass = false, Widget? suffix}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller, // Linked controller
            obscureText: isPass,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF00D2FF)),
              suffixIcon: suffix,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D2FF),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      onPressed: _handleLogin, // Trigger auth
      child: const Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}