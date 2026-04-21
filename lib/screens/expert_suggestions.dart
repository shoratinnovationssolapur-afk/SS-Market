import 'package:flutter/material.dart';
import '../services/subscription_service.dart';
import '../services/share_data_service.dart';

class ExpertSuggestionsPage extends StatefulWidget {
  const ExpertSuggestionsPage({super.key});

  @override
  State<ExpertSuggestionsPage> createState() => _ExpertSuggestionsPageState();
}

class _ExpertSuggestionsPageState extends State<ExpertSuggestionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Expert Signals", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: SubscriptionService().isSubscribed,
        builder: (context, isSubscribed, _) {
          if (!isSubscribed) {
            return _buildLockedView();
          }
          return _buildUnlockedView();
        },
      ),
    );
  }

  Widget _buildLockedView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_person_rounded, color: Colors.cyanAccent, size: 64),
          ),
          const SizedBox(height: 32),
          const Text(
            "Expert Buy/Sell Signals",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            "Get real-time suggestions from our lead market analyst. Unlock precise entry points, stop-loss targets, and profit goals for the next 24 hours.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                const Text("One-Day Premium Pass", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                const Text("₹20.00", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    SubscriptionService().subscribe();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Payment Successful! Expert signals unlocked.")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Pay Now & Unlock", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, color: Colors.grey, size: 16),
              SizedBox(width: 8),
              Text("Secure transaction valid for 24 hours", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildUnlockedView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Access Period Ending In", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text(SubscriptionService().remainingTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text("Active Buy/Sell Signals", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildSignalCard("RELIANCE", "BUY", "₹2,450", "₹2,600", "₹2,400", "Current trend shows strong bullish momentum based on volume analysis."),
          _buildSignalCard("HDFC BANK", "SELL", "₹1,620", "₹1,550", "₹1,650", "Breaking support levels. Recommended to exit or short for intraday."),
          _buildSignalCard("TATA MOTORS", "BUY", "₹640", "₹710", "₹610", "Long term accumulation phase started. Great value at current price."),
        ],
      ),
    );
  }

  Widget _buildSignalCard(String sym, String type, String entry, String target, String sl, String analysis) {
    bool isBuy = type == "BUY";
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sym, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isBuy ? Colors.greenAccent.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(type, style: TextStyle(color: isBuy ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _signalStat("ENTRY", entry),
              _signalStat("TARGET", target),
              _signalStat("STOP LOSS", sl),
            ],
          ),
          const Divider(height: 40, color: Colors.white10),
          const Text("EXPERT ANALYSIS", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text(analysis, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  Widget _signalStat(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 4),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
