import 'package:flutter/material.dart';
import 'user_pages.dart';
import 'login.dart';
import 'expert_suggestions.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: isMobile
          ? AppBar(
              backgroundColor: const Color(0xFF161B22),
              title: const Text("Capitalia", style: TextStyle(fontSize: 18, color: Colors.white)),
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
                    // Simplified Header: Name and Description
                    const Text(
                      "Leo Culhane",
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Expert Market Analyst & Portfolio Strategist. Providing high-accuracy intraday and long-term trading signals based on technical and fundamental research.",
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    // Premium Payment Feature
                    _buildExpertBanner(context),
                    const SizedBox(height: 40),
                    // Optional: Visual element to fill space professionally
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

  Widget _buildFeatureHighlights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Why Join Premium?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _highlightItem(Icons.verified_rounded, "High Accuracy Signals", "Verified trade ideas with precise entry/exit."),
        _highlightItem(Icons.timer_rounded, "Real-time Updates", "Get notified immediately when a new signal is active."),
        _highlightItem(Icons.security_rounded, "Risk Management", "Every suggestion comes with a calculated stop-loss."),
      ],
    );
  }

  Widget _highlightItem(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.cyanAccent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.cyanAccent, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
    bool isMobile = MediaQuery.of(context).size.width < 1100;
    
    Widget content = Container(
      width: 260,
      color: const Color(0xFF161B22),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.auto_graph, color: Colors.cyanAccent, size: 28),
              const SizedBox(width: 12),
              const Text("Capitalia", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
        backgroundColor: const Color(0xFF161B22),
        child: content,
      );
    }
    return content;
  }

  Widget _navItem(BuildContext context, IconData icon, String title, {bool active = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: active ? Colors.cyanAccent.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.cyanAccent : Colors.grey, size: 20),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(color: active ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Text("User Panel", style: TextStyle(color: Colors.grey, fontSize: 14)),
        const Spacer(),
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 24),
        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=leo')),
      ],
    );
  }

  Widget _buildLogout(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.logout, color: Colors.grey, size: 20),
            const SizedBox(width: 16),
            const Text("Log out", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
