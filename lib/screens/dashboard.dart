import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Make sure this is imported

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. FIX: Define the variable here so the build method can see it
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _fetchUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        // Fallback: DisplayName -> Email prefix -> Trader
        userName = user.displayName ?? user.email?.split('@')[0] ?? "Trader";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            // 2. FIX: Only call this ONCE and pass the name variable
            _buildHeader(userName ?? "Trader"),

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

  // 3. FIX: Ensure the header accepts the String argument
  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Hello,", style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ]),
        const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white10,
          child: Icon(Icons.person_outline, color: Colors.white),
        ),
      ],
    );
  }

  // ... keep your existing _buildPortfolioCard, _infoTile, and _stockItem below
  Widget _buildPortfolioCard() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Net Worth", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const Text("\$27,450.50", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 25),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [Text("Profit", style: TextStyle(color: Colors.white60)), Text("+\$2,100")]),
              Column(children: [Text("Loss", style: TextStyle(color: Colors.white60)), Text("-\$340")]),
              Column(children: [Text("Growth", style: TextStyle(color: Colors.white60)), Text("+12.4%")]),
            ],
          )
        ],
      ),
    );
  }

  Widget _stockItem(String name, String sym, String price, String change, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white10, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            Text(sym, style: const TextStyle(color: Colors.white38)),
          ]),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(change, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    );
  }
}