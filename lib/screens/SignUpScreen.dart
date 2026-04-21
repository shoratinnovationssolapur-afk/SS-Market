import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:ss_market/services/auth.dart'; // Import the helper above
import 'dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  void _handleSignUp() async {
    setState(() => _isLoading = true);
    final user = await AuthService().signUp(_emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Globe Background (Matches Login)
          Hero(
            tag: 'globe_morph',
            child: Positioned(
              top: -100, right: -100, // Slightly shifted for visual variety
              child: Container(
                width: 450, height: 450,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF92FE9D)]),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(color: Colors.transparent),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                const Text("Create Account",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 40),
                _buildGlassInput("Full Name", Icons.person_outline_rounded, controller: _nameController),
                const SizedBox(height: 20),
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
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF00D2FF))
                    : _buildActionButton("Sign Up", _handleSignUp),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Already have an account? Sign In", style: TextStyle(color: Colors.white70)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassInput(String hint, IconData icon, {bool isPass = false, Widget? suffix, required TextEditingController controller}) {
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

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D2FF),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}