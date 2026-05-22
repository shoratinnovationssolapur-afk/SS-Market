import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import '../services/subscription_service.dart';

class BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  static const String signalUnlockID = 'ss_market_premium_access';

  void initialize() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      debugPrint("Billing Error: $error");
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {

        // Pass the unique purchase identity string down to the recorder logic
        await _recordPurchaseInFirestore(purchase.purchaseID ?? DateTime.now().millisecondsSinceEpoch.toString());

        if (purchase is GooglePlayPurchaseDetails) {
          final androidAddition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          await androidAddition.consumePurchase(purchase);
        }

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  // ✅ New helper to centralize Firestore updates
// Updated helper accepting the unique transaction id string
  Future<void> _recordPurchaseInFirestore(String transactionId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String uid = user.uid;
    final DateTime now = DateTime.now();
    final expiry = now.add(const Duration(hours: 24));
    final batch = FirebaseFirestore.instance.batch();

    // 1. Update User Profile Expiry
// 1. Update User Profile Expiry
    batch.update(FirebaseFirestore.instance.collection('users').doc(user.uid), {
      'premium_expiry': expiry.toIso8601String(),
      'hasActiveSubscription': true,
    });

    // 2. Add to User History (FIX: Added unique transactionId as document name)
    batch.set(FirebaseFirestore.instance.collection('users').doc(uid).collection('user_payments').doc(transactionId), {
      'title': "Daily Signal Pass",
      'amount': "₹20.00",
      'timestamp': FieldValue.serverTimestamp(),
      'expiry': expiry.toIso8601String(),
      'transactionId': transactionId,
    }, SetOptions(merge: true));

    // 3. Add to Admin Revenue History (FIX: Added unique transactionId as document name)
    batch.set(FirebaseFirestore.instance.collection('admin_payments').doc(transactionId), {
      'userName': user.displayName ?? "Samarth Hatte",
      'userEmail': user.email,
      'uid': uid,
      'amount': 20.0,
      'timestamp': FieldValue.serverTimestamp(),
      'transactionId': transactionId,
    }, SetOptions(merge: true));

    await batch.commit();

    // Update UI immediately
    SubscriptionService().isSubscribed.value = true;
    SubscriptionService().expiryTime.value = expiry;
  }

  Future<void> buySignal() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    const Set<String> kIds = {signalUnlockID};
    final ProductDetailsResponse response = await _iap.queryProductDetails(kIds);

    if (response.productDetails.isNotEmpty) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: response.productDetails.first);
      _iap.buyConsumable(purchaseParam: purchaseParam);
    }
  }
}