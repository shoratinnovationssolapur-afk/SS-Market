import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUserHistoryPage extends StatelessWidget {
  const AdminUserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(

        title: Row(
          children: [
            Image.asset('assets/logo_dark.png', height: 30, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 12),
            const Text("User Payment History (₹20)", style: TextStyle(color: Colors.white)),
          ],
        ),
        //
        // title: const Text("Master Revenue History",
        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),

        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('admin_payments')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          // Calculate Total Revenue for the Header
          double totalRevenue = 0;
          for (var doc in snapshot.data!.docs) {
            totalRevenue += (doc['amount'] ?? 0).toDouble();
          }

          return Column(
            children: [
              _buildRevenueSummary(totalRevenue),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var purchase = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                    DateTime dateTime = (purchase['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                    String formattedDate = "${dateTime.day}/${dateTime.month} • ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";

                    return _buildAdminHistoryCard(purchase, formattedDate);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRevenueSummary(double total) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Total Revenue Collected", style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text("₹${total.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdminHistoryCard(Map<String, dynamic> purchase, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.cyanAccent.withValues(alpha: 0.1),
            child: const Icon(Icons.person_rounded, color: Colors.cyanAccent),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(purchase["userName"] ?? "Anonymous",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(purchase["userEmail"] ?? "No email provided",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(color: Colors.white24, fontSize: 10)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("₹${purchase['amount']}",
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("SUCCESS", style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.payments_outlined, size: 64, color: Colors.white10),
          SizedBox(height: 16),
          Text("Waiting for first purchase...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}