import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/theme_service.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHistoryPage extends StatelessWidget {
  const UserHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Text("Transaction History",
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .collection('user_payments')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off_rounded, size: 64, color: isDark ? Colors.white10 : Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("No payment history found.",
                      style: TextStyle(color: isDark ? Colors.white38 : Colors.black45)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // Formatting the Firestore Timestamp
              Timestamp? ts = doc['timestamp'] as Timestamp?;
              DateTime dateTime = ts?.toDate() ?? DateTime.now();
              String timeStr = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
              String dateStr = "${dateTime.day}/${dateTime.month}/${dateTime.year}";

              // Checking if still active for UI feedback
              DateTime expiry = DateTime.parse(doc['expiry'] ?? DateTime.now().toIso8601String());
              bool isActive = DateTime.now().isBefore(expiry);

              return _historyItem(
                context,
                doc['title'] ?? "Signal Pass",
                isActive ? "Access: Active" : "Access: Expired",
                doc['amount'] ?? "₹20.00",
                "$dateStr • $timeStr",
                isActive, // Use color to show if the pass is still active
              );
            },
          );
        },
      ),
    );
  }

  Widget _historyItem(BuildContext context, String title, String sub, String amount, String time, bool isActive) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: isActive ? Colors.cyanAccent.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05)) : null,
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActive ? Icons.bolt_rounded : Icons.timer_off_rounded,
              color: isActive ? Colors.greenAccent : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: isActive ? Colors.greenAccent : Colors.grey, fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
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
    final user = FirebaseAuth.instance.currentUser;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          // Profile Header
          _buildProfileHeader(context, user),
          const SizedBox(height: 32),

          _buildSectionHeader(context, "General"),
          _settingOption(context, "Edit Profile", Icons.person_outline_rounded, "Name, phone, and bio", onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
          }),
          
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeService().themeMode,
            builder: (context, mode, _) {
              return SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.blueAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, 
                      color: isDark ? Colors.white70 : Colors.blueAccent, size: 22),
                ),
                title: Text("Dark Mode", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16)),
                subtitle: const Text("Toggle between light and dark theme", style: TextStyle(color: Colors.grey, fontSize: 13)),
                value: isDark,
                onChanged: (bool value) {
                  ThemeService().toggleTheme();
                },
                activeThumbColor: Colors.cyanAccent,
              );
            },
          ),

          const SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              label: const Text("Sign Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                foregroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: const BorderSide(color: Colors.redAccent, width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User? user) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        // Default values
        String name = "User Account";
        String bio = "Stock Market Enthusiast";

        if (snapshot.hasData && snapshot.data!.exists) {
          // Convert to Map to use containsKey or safe access
          var data = snapshot.data!.data() as Map<String, dynamic>?;

          if (data != null) {
            // Use 'fullName' because that is what is in your Firestore
            name = data['fullName'] ?? name;
            bio = data['bio'] ?? bio;
          }
        }

        return Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
              child: Icon(Icons.person, size: 50, color: isDark ? Colors.white38 : Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(name, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(bio, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text(user?.email ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: isDark ? Colors.cyanAccent : Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _settingOption(BuildContext context, String title, IconData icon, String subtitle, {VoidCallback? onTap}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.blueAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDark ? Colors.white70 : Colors.blueAccent, size: 22),
      ),
      title: Text(title, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.grey),
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? "");
    _phoneController = TextEditingController(text: "+91 9876543210"); 
    _bioController = TextEditingController(text: "Stock Market Enthusiast"); 
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated!")));
            },
            child: Text("SAVE", style: TextStyle(color: isDark ? Colors.cyanAccent : Colors.blueAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: isDark ? Colors.cyanAccent : Colors.blueAccent, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildEditField(context, "Full Name", _nameController),
            _buildEditField(context, "Phone Number", _phoneController),
            _buildEditField(context, "Bio", _bioController, maxLines: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(BuildContext context, String label, TextEditingController controller, {int maxLines = 1}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
