import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../helper/date_time_helper.dart';
import '../../helper/hijri_helper.dart';
import '../enums/enums.dart';
import '../services/salah_time_calculator.dart';
import 'config/models.dart';

part 'salah_times.g.dart';

@JsonSerializable(explicitToJson: true)
class SalahTimes {
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange fajr;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange dhuhr;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange asr;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange maghrib;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange isha;

  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange witr;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange duha;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange awwabin;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange tahajjud;

  SalahTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.witr,
    required this.duha,
    required this.awwabin,
    required this.tahajjud,
  });


  /// Imsak: 10 minutes before Fajr — the pre-dawn eating cutoff in Ramadan.
  DateTime get imsak => fajr.start.subtract(const Duration(minutes: 10));

  /// Whether this timetable's date falls in Ramadan.
  bool get isRamadan => HijriDate.fromGregorian(fajr.start).isRamadan;

  /// The Hijri date corresponding to this timetable (based on Fajr start).
  HijriDate get hijriDate => HijriDate.fromGregorian(fajr.start);

  /// Whether this timetable's date falls during Hajj season (8–13 Dhul Hijjah).
  bool get isHajjSeason => HijriDate.fromGregorian(fajr.start).isHajjSeason;

  /// Whether this timetable's date is the Day of Arafah (9 Dhul Hijjah).
  bool get isArafah => HijriDate.fromGregorian(fajr.start).isArafah;

  /// Whether this timetable's date is Eid al-Adha (10 Dhul Hijjah).
  bool get isEidAlAdha => HijriDate.fromGregorian(fajr.start).isEidAlAdha;

  factory SalahTimes.fromJson(Map<String, Object?> json) =>
      _$SalahTimesFromJson(json);

  Map<String, Object?> toJson() => _$SalahTimesToJson(this);

  static Future<SalahTimes> calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    required SalahCalculationMethod method,
    Madhab? madhab,
  }) async {
    return SalahTimeCalculator.calculate(
      date: date,
      latitude: latitude,
      longitude: longitude,
      method: method,
      madhab: madhab,
    );
  }
}
