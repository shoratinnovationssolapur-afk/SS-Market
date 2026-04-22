import 'package:flutter/material.dart';
import '../services/share_data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShareHistoryPage extends StatelessWidget {
  const ShareHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Share Entry History"),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
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
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(share["name"] ?? "N/A", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.cyanAccent, size: 20),
                              onPressed: () => _showEditDialog(context, share),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              onPressed: () => ShareDataService().deleteShare(share["id"]!),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(share["date"] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 16),
                    const Text("DESCRIPTION", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text(share["description"] ?? "No description provided.", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, String> share) {
    final nameController = TextEditingController(text: share["name"]);
    final descController = TextEditingController(text: share["description"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161B22),
        title: const Text("Edit Share", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Share Name", labelStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              ShareDataService().updateShare(share["id"]!, {
                "name": nameController.text,
                "description": descController.text,
              });
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
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
      appBar: AppBar(
        title: const Text("User History"),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No user data found.", style: TextStyle(color: Colors.grey)));
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return _userHistoryItem(
                userData['fullName'] ?? "Unknown",
                "\$${userData['portfolioValue']?.toString() ?? '0.0'}",
                "${userData['profit']?.toString() ?? '0.0'}%"
              );
            },
          );
        },
      ),
    );
  }

  Widget _userHistoryItem(String user, String total, String change) {
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
            Text(change, style: TextStyle(color: change.startsWith('-') ? Colors.redAccent : Colors.greenAccent, fontSize: 12)),
          ]),
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
      appBar: AppBar(
        title: const Text("Basic Settings"),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("App Settings", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _settingTile("Platform Name", "Capitalia", Icons.edit),
          _settingTile("Currency Display", "INR / USD", Icons.currency_exchange),
          _settingTile("Notifications", "Enabled", Icons.notifications_active),
          _settingTile("Theme Mode", "Dark", Icons.brightness_4),
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
