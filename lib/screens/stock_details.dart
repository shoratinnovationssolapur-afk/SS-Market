import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockDetailsScreen extends StatelessWidget {
  final String name, sym, price, change, heroTag;
  final IconData icon;
  final bool isLoss;

  const StockDetailsScreen({
    super.key,
    required this.name,
    required this.sym,
    required this.price,
    required this.change,
    required this.icon,
    required this.heroTag,
    required this.isLoss,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010B13),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF041C2C), Color(0xFF010B13)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              _buildAppBar(context),
              const SizedBox(height: 30),
              _buildStockHeader(),
              const SizedBox(height: 30),
              _buildChartSection(),
              const SizedBox(height: 30),
              _buildTabs(),
              const SizedBox(height: 25),
              _buildAboutSection(),
              const SizedBox(height: 30),
              _buildMarketStats(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStockHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: heroTag,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(sym, style: const TextStyle(color: Colors.white38, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text("\$5,000.00", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Icon(isLoss ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: isLoss ? Colors.redAccent : Colors.greenAccent),
                  Text(change, style: TextStyle(color: isLoss ? Colors.redAccent : Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const titles = ['6:00PM', '6:30PM', '7:00PM', '7:30PM', '8:00PM', '8:30PM'];
                  if (value.toInt() >= 0 && value.toInt() < titles.length) {
                    return Text(titles[value.toInt()], style: const TextStyle(color: Colors.white38, fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text('\$${value.toInt()}', style: const TextStyle(color: Colors.white38, fontSize: 10)),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 100), FlSpot(1, 250), FlSpot(2, 180), FlSpot(3, 300),
                FlSpot(4, 220), FlSpot(5, 350), FlSpot(6, 280),
              ],
              isCurved: true,
              color: Colors.cyanAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.cyanAccent.withOpacity(0.2), Colors.cyanAccent.withOpacity(0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tabItem("About", isActive: true),
          _tabItem("News"),
          _tabItem("Orders"),
        ],
      ),
    );
  }

  Widget _tabItem(String title, {bool isActive = false}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? Colors.cyanAccent : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apple Inc. is a leading American technology company known for its innovative products, sleek design, and ecosystem-driven approach. Founded in 1976 by Steve Jobs, Steve Wozniak, and Ronald Wayne, Apple More...",
            style: TextStyle(color: Colors.white.withOpacity(0.6), height: 1.6, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        children: [
          _statItem("Market cap", "\$327.21B"),
          _statItem("Open", "\$327.21B"),
          _statItem("P/E", "-"),
          _statItem("Volume", "57.86M"),
          _statItem("High", "57.86M"),
          _statItem("52WH", "131.64"),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
