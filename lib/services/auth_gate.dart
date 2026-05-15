import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports are safer than relative paths
import 'package:ss_market/services/auth.dart';
import 'package:ss_market/screens/login.dart';
import 'package:ss_market/screens/user_dashboard.dart';
import 'package:ss_market/screens/admin_dashboard.dart';
import 'package:ss_market/screens/get_started.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Color(0xFF00D2FF))),
          );
        }

        // Check if user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return FutureBuilder<String?>(
            future: AuthService().getUserRole(snapshot.data!.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(child: CircularProgressIndicator(color: Color(0xFF00D2FF))),
                );
              }

              // If no role found, send to Login
              if (roleSnapshot.data == null) {
                return const LoginScreen();
              }

              // Direct based on role (Removed 'const' to prevent compile errors)
              return roleSnapshot.data == 'admin'
                  ? const AdminDashboard()
                  : const UserDashboard();
            },
          );
        }

        // If no session, show Get Started
        return const GetStartedScreen();
      },
    );
  }
}