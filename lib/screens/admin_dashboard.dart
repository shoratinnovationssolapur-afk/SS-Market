import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(context),
          // Main Content
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
                              _buildSectionHeader("Trending"),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _buildTrendingCard("TSLA", "Tesla Inc", "462.25 USD", "+7.35%", true)),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildTrendingCard("AMZN", "Amazon", "12.27 USD", "-4.87%", false)),
                                ],
                              ),
                              const SizedBox(height: 32),
                              _buildSectionHeader("Most profitable"),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _buildProfitCard("FB", "Meta", "607.75 USD", "-1.32%", false)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildProfitCard("NVDA", "NVIDIA", "256.27 USD", "+3.98%", true)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildProfitCard("UBER", "Uber", "323.52 USD", "-1.61%", false)),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildProfitCard("ADBE", "Adobe", "458.59 USD", "+5.65%", true)),
                                ],
                              ),
                              const SizedBox(height: 32),
                              _buildSectionHeader("Transactions"),
                              const SizedBox(height: 16),
                              _buildTransactionList(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader("My portfolio"),
                              const SizedBox(height: 16),
                              _buildPortfolioSummary("Gain", "+1,657.00 USD", Icons.trending_up, Colors.greenAccent),
                              const SizedBox(height: 12),
                              _buildPortfolioSummary("Investment", "+10,298.49 USD", Icons.account_balance_wallet, Colors.blueAccent),
                              const SizedBox(height: 32),
                              _buildSectionHeader("Recent activities"),
                              const SizedBox(height: 16),
                              _buildRecentActivity("TSLA", "Tesla Inc", "+11.22%", 0.8),
                              _buildRecentActivity("DELL", "Dell Technologies Inc", "+3.22%", 0.4),
                              _buildRecentActivity("NFLX", "Netflix", "+6.56%", 0.6),
                              _buildRecentActivity("AMD", "AMD", "+6.76%", 0.7),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.analytics, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text("Capitalia", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 48),
          _sidebarItem(Icons.dashboard_rounded, "Dashboard", isActive: true),
          _sidebarItem(Icons.bar_chart_rounded, "Market"),
          _sidebarItem(Icons.pie_chart_rounded, "Portfolio"),
          _sidebarItem(Icons.description_rounded, "News"),
          _sidebarItem(Icons.settings_rounded, "Settings"),
          const Spacer(),
          _buildPremiumCard(),
          const SizedBox(height: 24),
          _sidebarItem(Icons.logout_rounded, "Log out"),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.grey, size: 20),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1E88E5)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Capitalia Premium", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text("Unlocking the secrets to successful investing", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Get Now"),
          )
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const Spacer(),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(12)),
          child: const TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(hintText: "Search", hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none, icon: Icon(Icons.search, color: Colors.grey)),
          ),
        ),
        const SizedBox(width: 24),
        const Icon(Icons.notifications_outlined, color: Colors.grey),
        const SizedBox(width: 24),
        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin')),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: Colors.grey, fontSize: 12))),
      ],
    );
  }

  Widget _buildTrendingCard(String sym, String name, String price, String change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.white10, radius: 15, child: Text(sym[0], style: const TextStyle(color: Colors.white, fontSize: 12))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sym, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(name, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(change, style: TextStyle(color: isPositive ? Colors.greenAccent : Colors.redAccent, fontSize: 10)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [const FlSpot(0, 3), const FlSpot(1, 1), const FlSpot(2, 4), const FlSpot(3, 2), const FlSpot(4, 5)],
                  isCurved: true,
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: (isPositive ? Colors.greenAccent : Colors.redAccent).withOpacity(0.1)),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }

  Widget _buildProfitCard(String sym, String name, String price, String change, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.blur_on, color: Colors.grey, size: 20),
              const SizedBox(width: 8),
              Text(sym, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          Text(change, style: TextStyle(color: isPositive ? Colors.greenAccent : Colors.redAccent, fontSize: 10)),
          const SizedBox(height: 12),
          SizedBox(
            height: 30,
            child: LineChart(LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [const FlSpot(0, 1), const FlSpot(1, 3), const FlSpot(2, 2), const FlSpot(3, 4)],
                  isCurved: true,
                  color: isPositive ? Colors.greenAccent : Colors.redAccent,
                  barWidth: 1.5,
                  dotData: const FlDotData(show: false),
                ),
              ],
            )),
          )
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Column(
      children: [
        _transactionItem("Apple", "Sell", "+ 235.99 USD", "17 Aug, 07:00 AM", true),
        _transactionItem("Amazon", "Buy", "- 160.00 USD", "15 Aug, 09:00 AM", false),
        _transactionItem("eBay Inc", "Sell", "+ 114.00 USD", "10 Aug, 10:30 AM", true),
      ],
    );
  }

  Widget _transactionItem(String name, String type, String amount, String date, bool isPositive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF161B22), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white10, radius: 18, child: Text(name[0], style: const TextStyle(color: Colors.white))),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(type, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(color: isPositive ? Colors.greenAccent : Colors.white, fontWeight: FontWeight.bold)),
              Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPortfolioSummary(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(amount, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(String sym, String name, String change, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 15, backgroundColor: Colors.white10, child: Text(sym[0], style: const TextStyle(color: Colors.white, fontSize: 10))),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sym, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(name, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
              const Spacer(),
              Text(change, style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent), minHeight: 4),
        ],
      ),
    );
  }
}
