import 'package:flutter/material.dart';

class ShareDataService {
  static final ShareDataService _instance = ShareDataService._internal();
  factory ShareDataService() => _instance;
  ShareDataService._internal();

  final ValueNotifier<List<Map<String, String>>> shares = ValueNotifier<List<Map<String, String>>>([
    {
      "name": "Apple Inc",
      "sym": "AAPL",
      "current": "\$182.40",
      "past": "\$150.00",
      "future": "\$210.00",
      "valuation": "\$3.0T",
      "date": "Oct 24, 2023"
    },
    {
      "name": "Tesla Inc",
      "sym": "TSLA",
      "current": "\$240.50",
      "past": "\$210.00",
      "future": "\$300.00",
      "valuation": "\$750B",
      "date": "Oct 23, 2023"
    },
    {
      "name": "NVIDIA",
      "sym": "NVDA",
      "current": "\$450.12",
      "past": "\$380.00",
      "future": "\$520.00",
      "valuation": "\$1.1T",
      "date": "Oct 22, 2023"
    },
  ]);

  void addShare(Map<String, String> share) {
    shares.value = [...shares.value, share];
  }
}
