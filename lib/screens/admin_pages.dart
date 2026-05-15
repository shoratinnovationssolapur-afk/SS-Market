import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShareHistoryPage extends StatelessWidget {
  const ShareHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_dark.png', height: 30, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 12),
            Text("Share Entry History", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('signals').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No signals added yet.", style: TextStyle(color: isDark ? Colors.grey : Colors.black54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var signal = doc.data() as Map<String, dynamic>;
              String id = doc.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF161B22) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.05)) : null,
                  boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(signal["name"] ?? "N/A", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.cyanAccent, size: 20),
                              onPressed: () => _showEditDialog(context, id, signal),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              onPressed: () => FirebaseFirestore.instance.collection('signals').doc(id).delete(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(signal["date"] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 16),
                    const Text("DESCRIPTION", style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
                    const SizedBox(height: 8),
                    Text(signal["description"] ?? "No description provided.",
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, Map<String, dynamic> signalData) {
    final nameController = TextEditingController(text: signalData["name"]);
    final descController = TextEditingController(text: signalData["description"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF161B22) : Colors.white,
        title: Text("Edit Share", style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              decoration: const InputDecoration(labelText: "Share Name", labelStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              maxLines: 3,
              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              decoration: const InputDecoration(labelText: "Description", labelStyle: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('signals').doc(docId).update({
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_dark.png', height: 30, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 12),
            Text("User History", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No user data found.", style: TextStyle(color: isDark ? Colors.grey : Colors.black54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userData = snapshot.data!.docs[index].data() as Map<String, dynamic>;

              String name = userData['fullName'] ?? "Unknown";
              String portfolio = userData['portfolioValue']?.toString() ?? "0";
              String profit = userData['profit']?.toString() ?? "0";

              return _userHistoryItem(
                context,
                name,
                "₹$portfolio",
                "$profit%",
              );
            },
          );
        },
      ),
    );
  }

  Widget _userHistoryItem(BuildContext context, String user, String total, String change) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            CircleAvatar(radius: 20, backgroundColor: isDark ? Colors.white10 : Colors.grey[200], child: const Icon(Icons.person, color: Colors.grey)),
            const SizedBox(width: 15),
            Text(user, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(total, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
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
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_dark.png', height: 30, errorBuilder: (c, e, s) => const SizedBox()),
            const SizedBox(width: 12),
            Text("Admin Settings", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          ],
        ),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          _buildSectionHeader(context, "Account"),
          _settingTile(context, "Edit Profile", "Update admin profile", Icons.person_outline_rounded, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminEditProfilePage()));
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

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: isDark ? Colors.blueAccent : Colors.blue, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _settingTile(BuildContext context, String title, String value, IconData icon, {VoidCallback? onTap}) {
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
      subtitle: Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white24 : Colors.grey, size: 18),
      onTap: onTap,
    );
  }
}

class AdminEditProfilePage extends StatefulWidget {
  const AdminEditProfilePage({super.key});
  @override
  State<AdminEditProfilePage> createState() => _AdminEditProfilePageState();
}

class _AdminEditProfilePageState extends State<AdminEditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && mounted) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = data['fullName'] ?? user.displayName ?? "Admin";
            _emailController.text = data['email'] ?? user.email ?? "";
            _isLoading = false;
          });
        } else if (mounted) {
           setState(() {
            _nameController.text = user.displayName ?? "Admin";
            _emailController.text = user.email ?? "";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching admin data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: AppBar(
        title: Text("Admin Profile", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        actions: [
          if (!_isLoading)
            TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      await user.updateDisplayName(_nameController.text);
                      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                        'fullName': _nameController.text,
                      }, SetOptions(merge: true));

                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Admin profile updated!")));
                      }
                    } catch (e) {
                      debugPrint("Error updating admin profile: $e");
                    }
                  }
                },
                child: Text("SAVE", style: TextStyle(color: isDark ? Colors.blueAccent : Colors.blue))
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
                radius: 50,
                backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
                child: Icon(Icons.admin_panel_settings, size: 50, color: isDark ? Colors.blueAccent : Colors.blue)
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              _emailController.text,
              style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(context, "Display Name", _nameController),
          TextField(
            controller: _emailController,
            enabled: false,
            style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            decoration: InputDecoration(
              labelText: "Login Email",
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label, TextEditingController controller) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: TextField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: isDark ? const Color(0xFF161B22) : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
