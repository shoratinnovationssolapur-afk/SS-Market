import 'package:flutter/material.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  // Observable state for subscription status
  final ValueNotifier<bool> isSubscribed = ValueNotifier<bool>(false);
  final ValueNotifier<DateTime?> expiryTime = ValueNotifier<DateTime?>(null);

  void subscribe() {
    isSubscribed.value = true;
    expiryTime.value = DateTime.now().add(const Duration(hours: 24));
  }

  bool get hasActiveSubscription {
    if (expiryTime.value == null) return false;
    return DateTime.now().isBefore(expiryTime.value!);
  }

  String get remainingTime {
    if (expiryTime.value == null) return "00:00:00";
    final diff = expiryTime.value!.difference(DateTime.now());
    if (diff.isNegative) return "Expired";
    return "${diff.inHours.toString().padLeft(2, '0')}:${(diff.inMinutes % 60).toString().padLeft(2, '0')}:${(diff.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
