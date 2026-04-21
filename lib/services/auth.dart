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
          email: email,
          password: password
      );
      User? user = result.user;

      if (user != null) {
        // 2. Update Firebase Display Name
        await user.updateDisplayName(fullName);

        // 3. Create Firestore Document
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'portfolioValue': 0.0,
          'profit': 0.0,
        });
      }
      return user;
    } catch (e) {
      debugPrint("Signup Error: \$e");
      return null;
    }
  }

  // Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}

// Helper to avoid 'print' lint
void debugPrint(String message) {
  // ignore: avoid_print
  print(message);
}
