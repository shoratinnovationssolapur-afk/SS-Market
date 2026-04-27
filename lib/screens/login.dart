import 'package:flutter/material.dart';
import '../services/auth.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final user = await AuthService().signIn(email, password);

    if (!mounted) return;

    if (user != null) {
      String? role = await AuthService().getUserRole(user.uid);
      if (!mounted) return;
      if (role == 'admin') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const UserDashboard()));
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Credentials"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Logo in circle with shadow
              Center(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Image.asset(
                    'assets/logo_white.png.png',
                    height: 80,
                    errorBuilder: (c, e, s) => const Icon(Icons.auto_graph, size: 80, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 50),
              
              // Email Field
              _buildInputField(
                hint: "Email",
                icon: Icons.email_outlined,
                controller: _emailController,
                borderColor: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(height: 20),
              
              // Password Field (Styled as "Active" with purple border like screenshot)
              _buildInputField(
                hint: "Password",
                icon: Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
                isObscure: _isObscure,
                onObscureToggle: () => setState(() => _isObscure = !_isObscure),
                borderColor: const Color(0xFF6C63FF),
              ),
              
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Login Button (Light purple style)
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF6C63FF))
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3F2FF), // Very light purple
                        foregroundColor: const Color(0xFF6C63FF),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required Color borderColor,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onObscureToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
                  onPressed: onObscureToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
