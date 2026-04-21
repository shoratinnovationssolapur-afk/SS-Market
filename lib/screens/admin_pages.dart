import 'package:flutter/material.dart';
import '../services/share_data_service.dart';

class ShareHistoryPage extends StatelessWidget {
  const ShareHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Share Entry History"),
        backgroundColor: const Color(0xFF161B22),
      ),
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: ShareDataService().shares,
        builder: (context, shares, _) {
          if (shares.isEmpty) {
            return const Center(child: Text("No shares added yet.", style: TextStyle(color: Colors.grey)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shares.length,
            itemBuilder: (context, index) {
              final share = shares[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(share["name"] ?? "N/A", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(share["date"] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(share["sym"] ?? "", style: const TextStyle(color: Colors.cyanAccent, fontSize: 14)),
                    const Divider(height: 32, color: Colors.white10),
                    Row(
                      children: [
                        _historyStat("Current", share["current"] ?? ""),
                        _historyStat("Past", share["past"] ?? ""),
                        _historyStat("Future Pred.", share["future"] ?? ""),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _historyStat("Company Valuation", share["valuation"] ?? ""),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _historyStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Market Overview"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _marketItem("Bitcoin", "BTC", "\$65,420.00", "+2.5%", true),
          _marketItem("Ethereum", "ETH", "\$3,520.45", "-1.2%", false),
          _marketItem("NVIDIA", "NVDA", "\$890.12", "+5.8%", true),
          _marketItem("Tesla", "TSLA", "\$180.50", "-0.4%", false),
        ],
      ),
    );
  }

  Widget _marketItem(String name, String sym, String price, String change, bool pos) {
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

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("All User Portfolios"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _userPortfolio("Leo Culhane", "\$27,450.50", "+12.5%"),
          _userPortfolio("Sarah Smith", "\$15,200.00", "-2.1%"),
          _userPortfolio("John Doe", "\$45,800.00", "+8.4%"),
        ],
      ),
    );
  }

  Widget _userPortfolio(String user, String total, String change) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const CircleAvatar(radius: 20, backgroundColor: Colors.white10, child: Icon(Icons.person, color: Colors.grey)),
            const SizedBox(width: 15),
            Text(user, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(total, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(change, style: TextStyle(color: change.startsWith('+') ? Colors.greenAccent : Colors.redAccent, fontSize: 12)),
          ]),
        ],
      ),
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Market News"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _newsItem("Fed signals potential rate cuts as inflation cools", "2 hours ago"),
          _newsItem("NVIDIA stock reaches all-time high amid AI boom", "5 hours ago"),
          _newsItem("Tesla quarterly deliveries beat market expectations", "Yesterday"),
          _newsItem("Global markets react to new tech regulations in EU", "2 days ago"),
        ],
      ),
    );
  }

  Widget _newsItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Admin Settings"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("General Settings", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _settingTile("Platform Name", "Capitalia", Icons.edit),
          _settingTile("Currency", "USD", Icons.currency_exchange),
          const SizedBox(height: 30),
          const Text("Adjustment Settings", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _settingTile("Trading Fees", "0.2%", Icons.percent),
          _settingTile("Market Status", "Open", Icons.power_settings_new),
          _settingTile("KYC Verification", "Mandatory", Icons.verified_user),
        ],
      ),
    );
  }

  Widget _settingTile(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
