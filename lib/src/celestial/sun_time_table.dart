import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../helper/date_time_helper.dart';
import 'sun_calculator.dart';

part 'sun_time_table.g.dart';

@JsonSerializable(explicitToJson: true)
class SunTimeTable {
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime solarNoon;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime nadir;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime dawn;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime dusk;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime nauticalDawn;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime nauticalDusk;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime nightEnd;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime nightStart;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime goldenHourEnd;
  @JsonKey(
    fromJson: DateTimeHelper.fromJson,
    toJson: DateTimeHelper.toJson,
  )
  final DateTime goldenHourStart;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange sunrise;
  @JsonKey(
    fromJson: DateTimeHelper.fromRangeJson,
    toJson: DateTimeHelper.toRangeJson,
  )
  final DateTimeRange sunset;

  //final DateTimeRange moon;

  const SunTimeTable({
    required this.solarNoon,
    required this.nadir,
    required this.sunrise,
    required this.sunset,
    required this.dawn,
    required this.dusk,
    required this.nauticalDawn,
    required this.nauticalDusk,
    required this.nightEnd,
    required this.nightStart,
    required this.goldenHourStart,
    required this.goldenHourEnd,
    //  required this.moon,
  });

  DateTimeRange get yesterdayNight => DateTimeRange(
      start: nightStart.add(const Duration(days: -1)), end: nightEnd);

  DateTimeRange get tonight => DateTimeRange(
      start: nightStart, end: nightEnd.add(const Duration(days: 1)));

  factory SunTimeTable.fromJson(Map<String, Object?> json) =>
      _$SunTimeTableFromJson(json);

  Map<String, Object?> toJson() => _$SunTimeTableToJson(this);

  factory SunTimeTable.calculate({
    required DateTime dateTime,
    required double latitude,
    required double longitude,
  }) {
    final timetable = SunCalculator.getTimes(
      DateTime.utc(dateTime.year, dateTime.month, dateTime.day),
      latitude,
      longitude,
    );
    /*final moonTimetable = SunCalculator.getMoonTimes(
      DateTime.now(),
      latitude,
      longitude,
      inUTC: true,
    );
*/
    final empty = DateTime.fromMillisecondsSinceEpoch(0);
    return SunTimeTable(
      solarNoon: timetable['solarNoon'] ?? empty,
      nadir: timetable['nadir'] ?? empty,
      dawn: timetable['dawn'] ?? empty,
      dusk: timetable['dusk'] ?? empty,
      nauticalDawn: timetable['nauticalDawn'] ?? empty,
      nauticalDusk: timetable['nauticalDusk'] ?? empty,
      sunrise: DateTimeRange(
        start: timetable['sunrise'] ?? empty,
        end: timetable['sunriseEnd'] ?? empty,
      ),
      nightEnd: timetable['nightEnd'] ?? empty,
      nightStart: timetable['night'] ?? empty,
      goldenHourStart: timetable['goldenHour'] ?? empty,
      goldenHourEnd: timetable['goldenHourEnd'] ?? empty,
      sunset: DateTimeRange(
        start: timetable['sunsetStart'] ?? empty,
        end: timetable['sunset'] ?? empty,
      ),
      /* moon: DateTimeRange(
        from: moonTimetable['rise'] ?? empty,
        to: moonTimetable['set'] ?? empty,
      ),*/
    );
  }
}
