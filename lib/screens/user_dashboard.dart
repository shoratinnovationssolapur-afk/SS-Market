import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/subscription_service.dart';
import 'login.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String _userName = "snehal";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && mounted) {
          setState(() {
            _userName = (userDoc.get('fullName') ?? "snehal").split(' ')[0].toLowerCase();
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF), // Dark purple AppBar
        elevation: 0,
        title: const Text(
          "SSMarket",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Gradient Card (Cyan/Blue to Purple)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00D2FF), Color(0xFF6C63FF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.show_chart, color: Colors.white, size: 80), // Trend icon
                        const SizedBox(height: 20),
                        Text(
                          "Hello, $_userName 👋",
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Grow your knowledge with expert-picked stock lessons.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  // Today's Access Pass Card
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 10))
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Today's Access Pass",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Pay just ₹20 to unlock today's Learning.",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "₹20",
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Two Small Cards Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: _buildSmallCard("Secure Payment", Icons.lock_outline)),
                        const SizedBox(width: 20),
                        Expanded(child: _buildSmallCard("Expert Picks", Icons.star)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          
          // Bottom Message & Buttons (as seen in screenshot 4)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "💰 Please pay ₹20 first to view stock info.",
                  style: TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility),
                  label: const Text("View"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(180, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.payment),
                  label: const Text("Pay ₹20 & Unlock"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CBA9), // Teal color from screenshot
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6C63FF).withOpacity(0.5), size: 35),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
