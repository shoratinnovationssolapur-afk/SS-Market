import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Corrected to match your Play Console ID
  static const String signalUnlockID = 'ss_market_premium_access';

  void initialize() {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("Billing Error: $error");
    });
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {

        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final String uid = user.uid;
          final String name = user.displayName ?? "User";
          final String email = user.email ?? "N/A";
          final DateTime now = DateTime.now();
          final expiry = now.add(const Duration(hours: 24));

          WriteBatch batch = FirebaseFirestore.instance.batch();

          // 1. Update User Profile (24-hour access)
          batch.update(FirebaseFirestore.instance.collection('users').doc(uid), {
            'premium_expiry': expiry.toIso8601String(),
          });

          // 2. Add to User's Personal Payment History
          DocumentReference userRef = FirebaseFirestore.instance
              .collection('users').doc(uid)
              .collection('user_payments').doc();
          batch.set(userRef, {
            'title': "Daily Signal Pass",
            'amount': "₹20.00",
            'timestamp': FieldValue.serverTimestamp(),
            'expiry': expiry.toIso8601String(),
          });

          // 3. Add to Admin-side Master Payment History
          DocumentReference adminRef = FirebaseFirestore.instance
              .collection('admin_payments').doc();
          batch.set(adminRef, {
            'userName': name,
            'userEmail': email,
            'uid': uid,
            'amount': 20,
            'timestamp': FieldValue.serverTimestamp(),
          });

          await batch.commit();

          // Consume for Android so they can buy again tomorrow
          if (purchase is GooglePlayPurchaseDetails) {
            final androidAddition = _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchase);
          }
        }
        if (purchase.pendingCompletePurchase) await _iap.completePurchase(purchase);
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // For local testing, we return true.
    // In production, verify the purchase.verificationData.serverVerificationData
    return true;
  }

  Future<void> buySignal() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      print("Store not available");
      return;
    }

    const Set<String> _kIds = {signalUnlockID};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);

    if (response.productDetails.isNotEmpty) {
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

      // ✅ Use buyConsumable for ₹20 daily tips
      _iap.buyConsumable(purchaseParam: purchaseParam);
    } else {
      print("Product $signalUnlockID not found in Play Store.");
    }
  }
}