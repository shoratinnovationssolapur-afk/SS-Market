import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/subscription_service.dart';
import '../services/share_data_service.dart';
import '../services/billing_service.dart';

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
          bool isValid = SubscriptionService().hasActiveSubscription;
          if (!isValid) {
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
              color: Colors.cyanAccent.withValues(alpha: 0.05),
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
            "Get real-time suggestions from our lead market analyst. Unlock precise market entry points for the next 24 hours.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                const Text("One-Day Premium Pass", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                const Text("₹20.00", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
    ElevatedButton(
    onPressed: () async {
    // ❌ REMOVE THIS: SubscriptionService().subscribe();

    // ✅ DO THIS: Trigger the actual Google Play Billing flow
    try {
    await BillingService().buySignal();

    // Note: We don't unlock here. The 'BillingService' listener
    // will handle the unlock ONLY after Google confirms the UPI payment.
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Billing Error: $e")),
    );
    }
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
        ],
      ),
    );
  }

  Widget _buildUnlockedView() {
    return StreamBuilder<QuerySnapshot>(
      // ✅ NEW: Listening to the actual Cloud Firestore collection
        stream: FirebaseFirestore.instance
            .collection('share_details')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // 1. Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }

          // 2. Handle Empty Data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyStateUI();
          }

          final shares = snapshot.data!.docs;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your existing Expiry Timer Header
                _buildExpiryTimerHeader(),

                const SizedBox(height: 32),
                const Text("Admin's Live Suggestions",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // ✅ NEW: Mapping Firestore documents to your UI
                ...shares.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildSignalCard(
                    data["name"] ?? "N/A",
                    data["description"] ?? "",
                    data["date"] ?? "",
                  );
                }),
              ],
            ),
          );
        }
    );
  }

  Widget _buildEmptyStateUI() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, color: Colors.white10, size: 60),
            SizedBox(height: 16),
            Text(
              "No suggestions added by admin yet.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

// Helper to keep your build method clean
  Widget _buildExpiryTimerHeader() {
    return Container(
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
              Text(SubscriptionService().remainingTime,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCard(String name, String description, String date) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _showFullSuggestion(context, name, description),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
            const Divider(height: 32, color: Colors.white10),
            const Text("EXPERT SUGGESTION", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            Text(
              "Read Full Suggestion",
              style: TextStyle(color: Colors.cyanAccent.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullSuggestion(BuildContext context, String title, String description) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Text(description, style: const TextStyle(color: Colors.white70, height: 1.5)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}
