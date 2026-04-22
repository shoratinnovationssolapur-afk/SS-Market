import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_pages.dart';
import 'login.dart';
import 'expert_suggestions.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users') // 🔥 make sure this matches your DB
            .doc(user.uid)
            .get();

        setState(() {
          userName = doc['fullName'] ?? "No Name"; // 🔥 check field name
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        userName = "Error loading name";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: isMobile
          ? AppBar(
              backgroundColor: const Color(0xFF161B22),
              title: const Text("Capitalia",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      drawer: isMobile ? _buildSidebar(context) : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(context),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMobile) _buildTopBar(),
                    const SizedBox(height: 40),

                    // ✅ USER NAME FROM FIREBASE
                    Text(
                      userName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      "Expert Market Analyst & Portfolio Strategist...",
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 16),
                    ),

                    const SizedBox(height: 40),
                    _buildExpertBanner(context),
                    const SizedBox(height: 40),
                    _buildFeatureHighlights(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI METHODS (UNCHANGED) ----------------

  Widget _buildFeatureHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Why Join Premium?",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _highlightItem(Icons.verified_rounded, "High Accuracy Signals",
            "Verified trade ideas with precise entry/exit."),
        _highlightItem(Icons.timer_rounded, "Real-time Updates",
            "Get notified immediately."),
        _highlightItem(Icons.security_rounded, "Risk Management",
            "Every suggestion includes stop-loss."),
      ],
    );
  }

  Widget _highlightItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white)),
              Text(desc, style: const TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildExpertBanner(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ExpertSuggestionsPage()));
      },
      child: const Text("Pay ₹20 & Unlock"),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListTile(title: const Text("Dashboard")),
          ListTile(
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return const Row(
      children: [
        Text("User Panel", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}