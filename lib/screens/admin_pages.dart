import 'package:flutter/material.dart';
import '../services/share_data_service.dart';
import '../services/theme_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: ShareDataService().shares,
        builder: (context, shares, _) {
          if (shares.isEmpty) {
            return Center(child: Text("No shares added yet.", style: TextStyle(color: isDark ? Colors.grey : Colors.black54)));
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
                  color: isDark ? const Color(0xFF161B22) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: isDark ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
                  boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(share["name"] ?? "N/A", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
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
                    Text(share["description"] ?? "No description provided.", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 14)),
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
              return _userHistoryItem(
                context,
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

  Widget _userHistoryItem(BuildContext context, String user, String total, String change) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161B22) : Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.blueAccent.withOpacity(0.1),
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
                activeColor: Colors.blueAccent,
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
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.blueAccent.withOpacity(0.1),
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
  final _nameController = TextEditingController(text: "Admin Master");
  final _emailController = TextEditingController(text: "admin@capitalia.com");

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
          TextButton(onPressed: () => Navigator.pop(context), child: Text("SAVE", style: TextStyle(color: isDark ? Colors.blueAccent : Colors.blue))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 50, 
              backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white, 
              child: Icon(Icons.admin_panel_settings, size: 50, color: isDark ? Colors.blueAccent : Colors.blue)
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField(context, "Display Name", _nameController),
          _buildTextField(context, "Email Address", _emailController),
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
