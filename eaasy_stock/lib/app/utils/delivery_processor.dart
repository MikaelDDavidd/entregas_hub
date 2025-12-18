import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:eaasy_stock/app/modules/home/models/delivery_model.dart';
import 'package:eaasy_stock/app/utils/date_parser.dart';
import 'package:intl/intl.dart';

class DeliveryProcessor {
  static Map<String, List<Delivery>> groupByDate(List<Delivery> deliveries) {
    Map<String, List<Delivery>> grouped = {};

    for (var delivery in deliveries) {
      try {
        DateTime? date = DateParser.parse(delivery.registerDate);
        if (date == null) continue;

        String dateKey = DateFormat('yyyy-MM-dd').format(date);

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(delivery);
      } catch (e) {
        continue;
      }
    }

    var sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    Map<String, List<Delivery>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  static List<Delivery> filterByText(
      List<Delivery> deliveries, String query) {
    if (query.isEmpty) return deliveries;

    final lowerQuery = query.toLowerCase();
    return deliveries
        .where((delivery) =>
            delivery.trackingCode.toLowerCase().contains(lowerQuery))
        .toList();
  }

  static Future<List<Delivery>> filterByDateRange(
    List<Delivery> deliveries,
    DateTime startDate,
    DateTime endDate,
  ) async {
    dev.log('🔍 [DeliveryProcessor] Starting filter with ${deliveries.length} deliveries');

    if (deliveries.isNotEmpty && deliveries.length >= 3) {
      dev.log('📦 [DeliveryProcessor] Sample dates: ${deliveries[0].registerDate}, ${deliveries[1].registerDate}, ${deliveries[2].registerDate}');
    }

    final result = await compute(
      _filterByDateRangeIsolate,
      _FilterParams(deliveries, startDate, endDate),
    );

    dev.log('🎯 [DeliveryProcessor] Results: ✅ ${result.matchCount} matches | ❌ ${result.outsideRangeCount} outside | ⚠️ ${result.nullDateCount} null | 💥 ${result.errorCount} errors');

    return result.filtered;
  }

  static _FilterResult _filterByDateRangeIsolate(_FilterParams params) {
    DateTime start = DateTime(params.startDate.year, params.startDate.month, params.startDate.day);
    DateTime end = DateTime(params.endDate.year, params.endDate.month, params.endDate.day, 23, 59, 59);

    int matchCount = 0;
    int nullDateCount = 0;
    int errorCount = 0;
    int outsideRangeCount = 0;

    final filtered = params.deliveries.where((delivery) {
      try {
        DateTime? deliveryDate = DateParser.parse(delivery.registerDate);
        if (deliveryDate == null) {
          nullDateCount++;
          return false;
        }

        bool matches = deliveryDate.isAfter(start.subtract(Duration(seconds: 1))) &&
            deliveryDate.isBefore(end.add(Duration(seconds: 1)));

        if (matches) {
          matchCount++;
        } else {
          outsideRangeCount++;
        }

        return matches;
      } catch (e) {
        errorCount++;
        return false;
      }
    }).toList();

    return _FilterResult(
      filtered: filtered,
      matchCount: matchCount,
      nullDateCount: nullDateCount,
      errorCount: errorCount,
      outsideRangeCount: outsideRangeCount,
    );
  }
}

class _FilterParams {
  final List<Delivery> deliveries;
  final DateTime startDate;
  final DateTime endDate;

  _FilterParams(this.deliveries, this.startDate, this.endDate);
}

class _FilterResult {
  final List<Delivery> filtered;
  final int matchCount;
  final int nullDateCount;
  final int errorCount;
  final int outsideRangeCount;

  _FilterResult({
    required this.filtered,
    required this.matchCount,
    required this.nullDateCount,
    required this.errorCount,
    required this.outsideRangeCount,
  });
}
