import 'package:flutter/material.dart';

class ShareDataService {
  static final ShareDataService _instance = ShareDataService._internal();
  factory ShareDataService() => _instance;
  ShareDataService._internal();

  final ValueNotifier<List<Map<String, String>>> shares = ValueNotifier<List<Map<String, String>>>([
    {
      "id": "1",
      "name": "Apple Inc",
      "description": "Buy at CMP for target 200. Bullish trend confirmed.",
      "date": "Oct 24, 2023"
    },
    {
      "id": "2",
      "name": "Tesla Inc",
      "description": "Hold for long term. Valuation looks attractive.",
      "date": "Oct 23, 2023"
    },
  ]);

  void addShare(Map<String, String> share) {
    final newShare = {
      ...share,
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
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
}
