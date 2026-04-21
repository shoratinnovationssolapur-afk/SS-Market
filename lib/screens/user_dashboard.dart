import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 32),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader("My Portfolio Assets"),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _buildAssetCard("TSLA", "Tesla Inc", "$462.25", "+7.35%", true)),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildAssetCard("AAPL", "Apple Inc", "$182.40", "+1.22%", true)),
                                ],
                              ),
                              const SizedBox(height: 32),
                              _buildSectionHeader("Market Watchlist"),
                              const SizedBox(height: 16),
                              _buildWatchlist(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader("Wealth Summary"),
                              const SizedBox(height: 16),
                              _buildStatCard("Total Balance", "$27,450.50", Icons.account_balance_wallet, Colors.cyanAccent),
                              const SizedBox(height: 12),
                              _buildStatCard("Net Profit", "+$1,657.00", Icons.trending_up, Colors.greenAccent),
                              const SizedBox(height: 32),
                              _buildSectionHeader("My Recent Trades"),
                              const SizedBox(height: 16),
                              _buildTradeItem("Buy TSLA", "2.0 Shares", "-$924.50", "Just now"),
                              _buildTradeItem("Sell AMZN", "1.5 Shares", "+$180.00", "2h ago"),
                              _buildTradeItem("Buy BTC", "0.01 BTC", "-$650.00", "Yesterday"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
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
          _navItem(Icons.dashboard_rounded, "Dashboard", true),
          _navItem(Icons.explore_outlined, "Market", false),
          _navItem(Icons.pie_chart_outline, "Portfolio", false),
          _navItem(Icons.notifications_none, "Alerts", false),
          _navItem(Icons.settings_outlined, "Settings", false),
          const Spacer(),
          _buildLogout(context),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String title, bool active) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: active ? Colors.cyanAccent.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: active ? Colors.cyanAccent : Colors.grey, size: 20),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(color: active ? Colors.white : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Text("Welcome back, Leo", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const Spacer(),
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 24),
        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=leo')),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildAssetCard(String sym, String name, String price, String change, bool pos) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sym, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(change, style: TextStyle(color: pos ? Colors.greenAccent : Colors.redAccent, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          Text(price, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTradeItem(String title, String sub, String val, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(height: 8, width: 8, decoration: const BoxDecoration(color: Colors.cyanAccent, shape: BoxShape.circle)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ]),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ]),
        ],
      ),
    );
  }

  Widget _buildWatchlist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _watchItem("Bitcoin", "BTC", "$65,420.00", "+2.5%"),
          _watchItem("Ethereum", "ETH", "$3,520.45", "-1.2%"),
          _watchItem("NVIDIA", "NVDA", "$890.12", "+5.8%"),
        ],
      ),
    );
  }

  Widget _watchItem(String name, String sym, String price, String change) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(color: Colors.white)),
          Text(sym, style: const TextStyle(color: Colors.grey)),
          Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(change, style: TextStyle(color: change.startsWith('+') ? Colors.greenAccent : Colors.redAccent)),
        ],
      ),
    );
  }

  Widget _buildLogout(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.logout, color: Colors.grey, size: 20),
      label: const Text("Log out", style: TextStyle(color: Colors.grey)),
    );
  }
}
