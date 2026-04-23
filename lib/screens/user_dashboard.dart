import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/subscription_service.dart';
import '../services/share_data_service.dart';

import 'user_pages.dart';
import 'login.dart';
import 'expert_suggestions.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  String _userName = "Loading...";

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
            _userName = userDoc.get('fullName') ?? "User";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
      if (mounted) setState(() => _userName = "User");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF02101A) : Colors.grey[50],
      appBar: isMobile
          ? AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        title: Text("Capitalia",
            style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black)),
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
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
                    if (!isMobile) _buildTopBar(context),
                    const SizedBox(height: 40),

                    // RESOLVED: Combined name and style logic
                    Text(
                      _userName,
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      "Expert Market Analyst & Portfolio Strategist. Providing high-accuracy intraday and long-term trading signals based on technical and fundamental research.",
                      style: TextStyle(
                          color: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.black54,
                          fontSize: 16,
                          height: 1.5
                      ),
                    ),

                    const SizedBox(height: 40),

                    // RESOLVED: Using ValueListenableBuilder for subscription logic
                    ValueListenableBuilder<bool>(
                      valueListenable: SubscriptionService().isSubscribed,
                      builder: (context, isSubscribed, _) {
                        // Check for active subscription
                        bool isValid = SubscriptionService().hasActiveSubscription;
                        if (isValid) {
                          return _buildPaidSuggestionsView(context);
                        } else {
                          return _buildExpertBanner(context);
                        }
                      },
                    ),

                    const SizedBox(height: 40),
                    _buildFeatureHighlights(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaidSuggestionsView(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Expert Suggestions",
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 14),
                  SizedBox(width: 4),
                  Text("Unlocked", style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<List<Map<String, String>>>(
          valueListenable: ShareDataService().shares,
          builder: (context, shares, _) {
            if (shares.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text("No live suggestions at the moment.", style: TextStyle(color: isDark ? Colors.grey : Colors.black54)),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shares.length,
              itemBuilder: (context, index) {
                final share = shares[index];
                return _buildSuggestionCard(context, share);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(BuildContext context, Map<String, String> share) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.cyanAccent.withOpacity(0.1) : Colors.blueAccent.withOpacity(0.1)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(share["name"] ?? "N/A", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(share["date"] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 8),
          Text(share["description"] ?? "", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Why Join Premium?", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _highlightItem(context, Icons.verified_rounded, "High Accuracy Signals", "Verified trade ideas with precise entry/exit."),
        _highlightItem(context, Icons.timer_rounded, "Real-time Updates", "Get notified immediately when a new signal is active."),
        _highlightItem(context, Icons.security_rounded, "Risk Management", "Every suggestion comes with a calculated stop-loss."),
      ],
    );
  }

  Widget _highlightItem(BuildContext context, IconData icon, String title, String desc) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: isDark ? Colors.cyanAccent.withValues(alpha: 0.1) : Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: isDark ? Colors.cyanAccent : Colors.blueAccent, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildExpertBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D2FF).withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Get Expert Signals",
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  "Unlock today's premium buy/sell suggestions for just ₹20. Valid for 24 hours.",
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 15),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpertSuggestionsPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF3A7BD5),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Pay ₹20 & Unlock", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                )
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width > 600) ...[
            const SizedBox(width: 40),
            const Icon(Icons.bolt_rounded, color: Colors.white, size: 100),
          ],
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isMobile = MediaQuery.of(context).size.width < 1100;
    
    Widget content = Container(
      width: 260,
      color: isDark ? const Color(0xFF161B22) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph, color: isDark ? Colors.cyanAccent : Colors.blueAccent, size: 28),
              const SizedBox(width: 12),
              Text("Capitalia", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 48),
          _navItem(context, Icons.dashboard_rounded, "Dashboard", active: true, onTap: () {
            if (isMobile) Navigator.pop(context);
          }),
          _navItem(context, Icons.insights_rounded, "Expert Signals", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ExpertSuggestionsPage()));
          }),
          _navItem(context, Icons.history_rounded, "History", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserHistoryPage()));
          }),
          _navItem(context, Icons.settings_outlined, "Settings", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSettingsPage()));
          }),
          const Spacer(),
          _buildLogout(context),
        ],
      ),
    );

    if (isMobile) {
      return Drawer(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        child: content,
      );
    }
    return content;
  }

  Widget _navItem(BuildContext context, IconData icon, String title, {bool active = false, VoidCallback? onTap}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? (isDark ? Colors.cyanAccent.withValues(alpha: 0.1) : Colors.blueAccent.withOpacity(0.1)) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? (isDark ? Colors.cyanAccent : Colors.blueAccent) : Colors.grey, size: 20),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(color: active ? (isDark ? Colors.white : Colors.black) : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Text("User Panel", style: TextStyle(color: isDark ? Colors.grey : Colors.black45, fontSize: 14)),
        const Spacer(),
        Icon(Icons.search, color: isDark ? Colors.grey : Colors.black45),
        const SizedBox(width: 24),
        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=leo')),
      ],
    );
  }

  Widget _buildLogout(BuildContext context) {
    return InkWell(
      onTap: () async {
        await FirebaseAuth.instance.signOut(); // Sign out from Firebase
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      },
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.grey, size: 20),
            SizedBox(width: 16),
            Text("Log out", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
