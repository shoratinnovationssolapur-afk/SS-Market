import 'package:flutter/material.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text("Transaction History"),
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _historyItem("Buy Tesla Inc", "2.0 Shares @ \$231.12", "-\$462.24", "Today, 10:45 AM", false),
          _historyItem("Sell Apple Inc", "5.0 Shares @ \$182.40", "+\$912.00", "Yesterday, 03:20 PM", true),
          _historyItem("Buy Bitcoin", "0.01 BTC @ \$65,420.00", "-\$654.20", "22 Oct, 11:15 AM", false),
          _historyItem("Sell NVIDIA", "1.0 Shares @ \$890.12", "+\$890.12", "20 Oct, 09:30 AM", true),
          _historyItem("Deposit Funds", "Via UPI", "+\$1,000.00", "18 Oct, 12:00 PM", true),
          _historyItem("Buy Microsoft", "1.0 Shares @ \$420.10", "-\$420.10", "15 Oct, 02:45 PM", false),
        ],
      ),
    );
  }

  Widget _historyItem(String title, String sub, String amount, String time, bool isCredit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: isCredit ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(color: isCredit ? Colors.greenAccent : Colors.white, fontWeight: FontWeight.bold)),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(title: const Text("Settings"), backgroundColor: const Color(0xFF161B22)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingOption("Profile Information", Icons.person_outline),
          _settingOption("Security & Password", Icons.lock_outline),
          _settingOption("Notification Settings", Icons.notifications_none),
          _settingOption("Help & Support", Icons.help_outline),
          _settingOption("App Theme", Icons.palette_outlined),
        ],
      ),
    );
  }

  Widget _settingOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
