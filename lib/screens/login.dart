import 'package:flutter/material.dart';
import 'dart:ui';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';
import 'sign_up_screen.dart'; // Fixed import name

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Hero(
              tag: 'globe_morph',
              child: Container(
                width: 450,
                height: 450,
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  const Text("Welcome Back",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 10),
                  const Text(
                      "\"The goal of a successful trader is to make the best trades. Money is secondary.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 40),
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
                  _buildLoginButton(context),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(color: Color(0xFF00D2FF), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput(String hint, IconData icon, {bool isPass = false, Widget? suffix, TextEditingController? controller}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
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

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D2FF),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      onPressed: () {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();

        if (email == "admin@ss.com" && password == "admin123") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
        } else if (email == "user@ss.com" && password == "user123") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Credentials"), backgroundColor: Colors.redAccent),
          );
        }
      },
      child: const Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}
