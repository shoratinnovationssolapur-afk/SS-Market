import 'package:flutter/material.dart';

class ShareDataService {
  static final ShareDataService _instance = ShareDataService._internal();
  factory ShareDataService() => _instance;
  ShareDataService._internal();

  // 1. Existing Shares List (Stock suggestions)
  final ValueNotifier<List<Map<String, String>>> shares = ValueNotifier<List<Map<String, String>>>([]);

  // 2. New Purchases List (User history for ₹20 payments)
  // In a real app, this would be a Firestore collection
  final ValueNotifier<List<Map<String, dynamic>>> purchases = ValueNotifier<List<Map<String, dynamic>>>([]);

  // --- Share Methods ---
  void addShare(Map<String, String> share) {
    final newShare = {
      ...share,
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "date": DateTime.now().toString().split(' ')[0],
    };
    shares.value = [...shares.value, newShare];
  }

  void updateShare(String id, Map<String, String> updatedData) {
    shares.value = [
      for (final share in shares.value)
        if (share["id"] == id) {...share, ...updatedData} else share
    ];
  }

  void deleteShare(String id) {
    shares.value = shares.value.where((share) => share["id"] != id).toList();
  }

  // --- Purchase History Methods ---

  // This fixes the 'getAllPurchases' isn't defined error
  Stream<List<Map<String, dynamic>>> getAllPurchases() {
    // We return the purchases as a Stream so the UI updates automatically
    return Stream.value(purchases.value);
  }

  // Method to record a new purchase (Call this when a user pays ₹20)
  void recordPurchase(String userName, String shareName) {
    final newPurchase = {
      "userName": userName,
      "shareName": shareName,
      "amount": "20",
      "timestamp": DateTime.now().toString().substring(0, 16), // e.g. 2026-04-23 14:30
    };
    purchases.value = [...purchases.value, newPurchase];
  }
}