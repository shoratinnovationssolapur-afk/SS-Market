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
      if (purchase.status == PurchaseStatus.pending) {
        // Handle pending state (e.g., show a spinner)
      } else if (purchase.status == PurchaseStatus.error) {
        print("Purchase Error: ${purchase.error}");
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {

        bool deliver = await _verifyPurchase(purchase);

        if (deliver) {
          // ✅ FIX: Get the userId from FirebaseAuth
          final String? userId = FirebaseAuth.instance.currentUser?.uid;

          if (userId != null) {
            // Save access for 24 hours
            final expiryTime = DateTime.now().add(const Duration(hours: 24));

            await FirebaseFirestore.instance.collection('users').doc(userId).update({
              'premium_expiry': expiryTime.toIso8601String(),
            });

            print("Access granted to $userId until $expiryTime");

            // ✅ CRITICAL: Consume the purchase for Android
            // This allows the user to buy the same product again tomorrow
            if (purchase is GooglePlayPurchaseDetails) {
              final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

              await androidAddition.consumePurchase(purchase);
            }
          } else {
            print("Delivery failed: No user logged in.");
          }
        }

        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
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