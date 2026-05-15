import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_user_history.dart';
import 'admin_pages.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isSaving = false;
  String _adminName = "Admin";
  String _adminEmail = "";

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchAdminData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Set initial values from Auth immediately
        if (mounted) {
          setState(() {
            _adminEmail = user.email ?? "";
            _adminName = user.displayName ?? "Admin";
          });
        }

        // Fetch detailed admin info from Firestore 'users' collection
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (adminDoc.exists && mounted) {
          setState(() {
            _adminName = adminDoc.get('fullName') ?? user.displayName ?? "Admin";
            _adminEmail = adminDoc.get('email') ?? user.email ?? _adminEmail;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching admin data: $e");
    }
  }

  Future<void> _saveEntry() async {
    if (_descriptionController.text.trim().isEmpty) return;

    // Check line count limit (100 lines)
    int lineCount = _descriptionController.text.split('\n').length;
    if (lineCount > 100) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Suggestion cannot exceed 100 lines!"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    setState(() => _isSaving = true);
    try {
      final DateTime now = DateTime.now();

      await FirebaseFirestore.instance.collection('share_details').add({
        "name": "Expert Suggestion",
        "description": _descriptionController.text.trim(),
        "date": "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}",
        "time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        "timestamp": FieldValue.serverTimestamp(),
        "createdBy": _adminName,
      });

      _descriptionController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data saved successfully ✅"),
            backgroundColor: Color(0xFF333333),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteShare(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('share_details')
          .doc(docId)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Record deleted successfully")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting: $e")),
        );
      }
    }
  }

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Suggestion?"),
        content: const Text("Are you sure you want to delete this share detail?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteShare(docId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isMobile = MediaQuery.of(context).size.width < 1100;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF52EBFF),
        elevation: 0,
        title: Text(
          "Admin Panel - $_adminName",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          )
        ],
      ),
      drawer: isMobile ? _buildSidebar(context) : null,
      body: Row(
        children: [
          if (!isMobile) _buildSidebar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- ADMIN PROFILE HEADER SECTION ---
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: const Color(0xFF362797).withValues(alpha: 0.1),
                            child: Icon(Icons.admin_panel_settings_rounded, color: isDark ? Colors.white : const Color(
                                0xFF362797), size: 35),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _adminName,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.alternate_email_rounded, size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      _adminEmail,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF161B22) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF6C63FF).withValues(alpha: 0.5)),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                        decoration: const InputDecoration(
                          labelText: "Enter Description",
                          labelStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _isSaving
                        ? const CircularProgressIndicator(color: Color(0xFF4CAF50))
                        : ElevatedButton(
                            onPressed: _saveEntry,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              minimumSize: const Size(180, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                    const SizedBox(height: 40),
                    const Text(
                      "Today's Entries",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('share_details')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No entries found.", style: TextStyle(color: Colors.grey));
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var doc = snapshot.data!.docs[index];
                            var data = doc.data() as Map<String, dynamic>;
                            return GestureDetector(
                              onLongPress: () => _confirmDelete(context, doc.id),
                              onTap: () => _showFullSuggestion(context, data["description"] ?? ""),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF161B22) : const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data["description"] ?? "",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${data["date"]} ${data["time"]}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "By: ${data["createdBy"] ?? "Admin"}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullSuggestion(BuildContext context, String description) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF161B22) : Colors.white,
        title: const Text("Full Suggestion"),
        content: SingleChildScrollView(
          child: Text(description, style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
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
                  Image.asset('assets/logo_dark.png', height: 40, errorBuilder: (c, e, s) => Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.analytics, color: Colors.white, size: 24),
                  )),
                  const SizedBox(width: 12),
                  Text("SS Market", style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 24),
              // Profile Summary in Sidebar
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.blueAccent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_adminName, style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(_adminEmail, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
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
              _sidebarItem(context, Icons.logout_rounded, "Log out", onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                }
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
          color: isActive ? (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.blueAccent.withValues(alpha: 0.1)) : Colors.transparent,
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
}
