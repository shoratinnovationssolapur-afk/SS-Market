import 'package:flutter/material.dart';
import 'admin_user_history.dart';
import 'admin_pages.dart';
import 'login.dart';
import '../services/share_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isMobile = MediaQuery.of(context).size.width < 1100;
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : Colors.grey[100],
      appBar: isMobile
          ? AppBar(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        title: Text("SS Market Admin",
            style: TextStyle(fontSize: 18, color: isDark ? Colors.white : Colors.black)),
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
      )
          : null,
      drawer: isMobile ? _buildSidebar(context) : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(context),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMobile)
                    _buildTopBar(context, user?.displayName ?? "Admin"),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Live Suggestions History",
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (isMobile)
                        ElevatedButton.icon(
                          onPressed: () => _showAddShareDialog(context),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add Share"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Expanded(
                    child: ValueListenableBuilder<List<Map<String, String>>>(
                      valueListenable: ShareDataService().shares,
                      builder: (context, shares, _) {
                        if (shares.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.analytics_outlined,
                                    color: isDark ? Colors.white10 : Colors.black12, size: 80),
                                const SizedBox(height: 16),
                                Text("No shares added yet.",
                                    style: TextStyle(color: isDark ? Colors.grey : Colors.black54)),
                                const SizedBox(height: 8),
                                Text(
                                    "Click 'Add Share' to start giving suggestions.",
                                    style: TextStyle(
                                        color: isDark ? Colors.white24 : Colors.black26, fontSize: 12)),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: shares.length,
                          itemBuilder: (context, index) {
                            final share = shares[index];
                            return _buildAdminShareCard(context, share);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminShareCard(BuildContext context, Map<String, String> share) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
          Text(share["name"] ?? "N/A",
              style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(share["date"] ?? "",
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          Text("EXPERT SUGGESTION",
              style: TextStyle(
                  color: isDark ? Colors.cyanAccent : Colors.blue,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(share["description"] ?? "No description provided.",
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  void _showAddShareDialog(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        title: Text("Add New Share", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(context, "Share Name", Icons.business, nameController),
            _buildDialogField(context, "Description", Icons.description, descController,
                maxLines: 3),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty) return;
              ShareDataService().addShare({
                "id": DateTime.now().millisecondsSinceEpoch.toString(),
                "name": nameController.text,
                "description": descController.text,
                "date": DateTime.now().toString().split(' ')[0],
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Share added successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text("Save Share", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(BuildContext context, String label, IconData icon, TextEditingController controller, {int maxLines = 1}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 260,
      color: isDark ? const Color(0xFF161B22) : Colors.white,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.analytics, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text("Capitalia", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 48),
              _sidebarItem(context, Icons.dashboard_rounded, "Dashboard", isActive: true, onTap: () {
                if (Navigator.of(context).canPop()) Navigator.pop(context);
              }),
              _sidebarItem(context, Icons.history_rounded, "User History", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminUserHistoryPage()),
                );
              }),
              _sidebarItem(context, Icons.settings_rounded, "Settings", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              }),
              const Spacer(),
              _sidebarItem(context, Icons.logout_rounded, "Log out", onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sidebarItem(BuildContext context, IconData icon, String title, {bool isActive = false, VoidCallback? onTap}) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? (isDark ? Colors.white.withOpacity(0.05) : Colors.blueAccent.withOpacity(0.1)) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? (isDark ? Colors.white : Colors.blueAccent) : Colors.grey, size: 20),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(color: isActive ? (isDark ? Colors.white : Colors.blueAccent) : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String name) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Text("Welcome, $name", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () => _showAddShareDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Add Share"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(width: 24),
        const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin')),
      ],
    );
  }
}
