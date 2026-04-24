import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

class BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // This ID must match exactly what you create in Google Play Console
  static const String signalUnlockID = 'premium_signal_unlock_20';

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
        // Show loading indicator in UI
      } else if (purchase.status == PurchaseStatus.error) {
        print("Purchase Error: ${purchase.error}");
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {

        // 1. Verify purchase (Ideally on your backend)
        bool deliver = await _verifyPurchase(purchase);

        if (deliver) {
          // 2. Unlock the signal for the user
          print("Unlocking Signal for user!");
        }

        // 3. IMPORTANT: Always complete the purchase
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // In a real app, send the purchase token to your Firebase Function
    return true;
  }

  Future<void> buySignal() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    const Set<String> _kIds = {signalUnlockID};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);

    if (response.productDetails.isNotEmpty) {
      final ProductDetails productDetails = response.productDetails.first;
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

      // Use buyConsumable if they can buy it multiple times
      _iap.buyConsumable(purchaseParam: purchaseParam);
    }
  }
}