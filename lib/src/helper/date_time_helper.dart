import 'package:flutter/material.dart';

abstract class DateTimeHelper {
  static DateTime fromJson(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: true,
    );
  }

  static int toJson(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  static Map<String, dynamic> toRangeJson(DateTimeRange range) {
    return {
      "start": range.start.millisecondsSinceEpoch,
      "end": range.end.millisecondsSinceEpoch,
    };
  }

  static DateTimeRange fromRangeJson(Map<String, dynamic> data) {
    return DateTimeRange(
      start:
          DateTime.fromMillisecondsSinceEpoch(data["start"] ?? 0, isUtc: true),
      end: DateTime.fromMillisecondsSinceEpoch(data["end"] ?? 0, isUtc: true),
    );
  }
}
