import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up
  Future<User?> signUp(String email, String password, String fullName) async {
    try {
      // 1. Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await user.updateDisplayName(fullName);

        // 2. Determine Role
        // Logic: If the email matches your admin email, set as admin.
        // Otherwise, default to 'user'.
        String role = "user";
        if (email.trim().toLowerCase() == "admin@ss.com") {
          role = "admin";
        }

        // 3. Create Firestore Document with Role
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'role': role, // <--- New Role Field
          'createdAt': FieldValue.serverTimestamp(),
          'portfolioValue': 0.0,
          'profit': 0.0,
        });
      }
      return user;
    } catch (e) {
      print("Signup Error: $e");
      return null;
    }
  }

  // Helper method to fetch user role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['role'];
      }
    } catch (e) {
      print("Error fetching role: $e");
    }
    return null;
  }

  // Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("SignIn Error: ${e.toString()}");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}