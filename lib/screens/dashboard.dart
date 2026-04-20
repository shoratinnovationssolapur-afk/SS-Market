import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildPortfolioCard(),
            const SizedBox(height: 30),
            const Text("Market Insights",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            _stockItem("Apple Inc", "AAPL", "\$12,350.50", "+15.50%", Icons.apple, Colors.greenAccent),
            _stockItem("Microsoft", "MSFT", "\$2,350.50", "-1.20%", Icons.window, Colors.redAccent),
            _stockItem("Tesla", "TSLA", "\$850.10", "+2.41%", Icons.electric_car, Colors.greenAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Hello, Leo", style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text("Welcome Back", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white10,
          child: Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildPortfolioCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00D2FF).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Net Worth", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const Text("\$27,450.50",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile("Profit", "+\$2,100"),
              _infoTile("Loss", "-\$340"),
              _infoTile("Growth", "+12.4%"),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _stockItem(String name, String sym, String price, String change, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
            Text(sym, style: const TextStyle(color: Colors.white38)),
          ]),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text(change, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }
}