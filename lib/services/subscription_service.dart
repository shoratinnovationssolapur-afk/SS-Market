import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Added missing import
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Added missing import

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // Observable state for subscription status
  final ValueNotifier<bool> isSubscribed = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> expiryTime = ValueNotifier<DateTime?>(null);

  // Called after a successful payment
  void subscribe() {
    isSubscribed.value = true;
    expiryTime.value = DateTime.now().add(const Duration(hours: 24));
  }

  // ✅ COMBINED: One reset method to clear everything
  void reset() {
    isSubscribed.value = false;
    expiryTime.value = null;
  }

  bool get hasActiveSubscription {
    // If the local value is true, they have access
    if (isSubscribed.value) return true;

    if (expiryTime.value == null) return false;
    return DateTime.now().isBefore(expiryTime.value!);
  }

  // ✅ FIXED: Corrected variable names and added Firestore sync
  Future<void> checkSubscriptionStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isSubscribed.value = false;
      return;
    }

    try {
      // Fetch the latest expiry from Firestore
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        String? expiryStr = data['premium_expiry'];

        if (expiryStr != null) {
          DateTime expiry = DateTime.parse(expiryStr);
          bool active = DateTime.now().isBefore(expiry);

          // Update the UI state
          isSubscribed.value = active;
          if (active) expiryTime.value = expiry;
        } else {
          isSubscribed.value = false;
        }
      }
    } catch (e) {
      debugPrint("Error checking subscription: $e");
      isSubscribed.value = false;
    }
  }

  String get remainingTime {
    if (expiryTime.value == null) return "00:00:00";
    final diff = expiryTime.value!.difference(DateTime.now());
    if (diff.isNegative) return "00:00:00";
    return "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}