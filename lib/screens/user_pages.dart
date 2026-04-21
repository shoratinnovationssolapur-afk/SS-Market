import 'package:flutter/material.dart';

class UserMarketPage extends StatelessWidget {
  const UserMarketPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Explore Market"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _marketTile("Apple Inc", "AAPL", "\$182.40", "+1.22%", true),
          _marketTile("Tesla Inc", "TSLA", "\$462.25", "+7.35%", true),
          _marketTile("Microsoft", "MSFT", "\$420.10", "-0.45%", false),
          _marketTile("Amazon", "AMZN", "\$175.20", "+0.15%", true),
        ],
      ),
    );
  }

  Widget _marketTile(String name, String sym, String price, String change, bool pos) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(sym, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(change, style: TextStyle(color: pos ? Colors.greenAccent : Colors.redAccent, fontSize: 12)),
          ]),
        ],
      ),
    );
  }
}

class UserPortfolioPage extends StatelessWidget {
  const UserPortfolioPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("My Portfolio"), backgroundColor: const Color(0xFF161B22)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _summaryCard("Total Invested", "\$10,298.49"),
            const SizedBox(height: 20),
            _assetTile("Tesla", "2.0 Shares", "\$924.50"),
            _assetTile("Apple", "5.0 Shares", "\$912.00"),
            _assetTile("Bitcoin", "0.01 BTC", "\$654.20"),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String label, String val) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(val, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _assetTile(String name, String shares, String val) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(shares, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
          Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Settings"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingOption("Profile Information", Icons.person_outline),
          _settingOption("Security & Password", Icons.lock_outline),
          _settingOption("Notification Settings", Icons.notifications_none),
          _settingOption("Help & Support", Icons.help_outline),
          _settingOption("App Theme", Icons.palette_outlined),
        ],
      ),
    );
  }

  Widget _settingOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
