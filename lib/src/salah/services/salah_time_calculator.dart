import 'dart:math';

import 'package:flutter/material.dart';
import 'package:virnavi_islamic_calculator/src/celestial/sun_time_table.dart';

import '../enums/enums.dart';
import '../models/config/models.dart';
import '../models/salah_times.dart';

class SalahTimeCalculator {
  static Future<SalahTimes> calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    required SalahCalculationMethod method,
    Madhab? madhab,
  }) async {
    final madhabToUse = madhab ?? method.madhab;
    final madhabValue = madhabToUse == Madhab.hanafi ? 2 : 1;

    final sunTimetable = SunTimeTable.calculate(
      dateTime: date,
      latitude: latitude,
      longitude: longitude,
    );

    final fajr =
    _calculateTimeForAngle(date, latitude, longitude, method.fajrAngle);

    DateTime isha;
    if (method.ishaAngle != null) {
      isha = _calculateTimeForAngle(
          date, latitude, longitude, method.ishaAngle!,
          ishan: true);
    } else {
      isha = sunTimetable.sunset.end
          .add(Duration(minutes: method.ishaInterval));
    }

    DateTime maghrib;
    if (method.maghribAngle != null) {
      maghrib = _calculateTimeForAngle(
          date, latitude, longitude, method.maghribAngle!,
          ishan: true);
    } else {
      maghrib = sunTimetable.sunset.end;
    }

    final dhuhr = sunTimetable.solarNoon;
    final asr =
    _calculateAsrTime(date, latitude, longitude, madhab: madhabValue);

    final adj = method.methodAdjustments;
    final userAdj = method.adjustments;

    final adjustedFajr = _applyOffset(fajr, adj.fajr + userAdj.fajr);
    final adjustedDhuhr = _applyOffset(dhuhr, adj.dhuhr + userAdj.dhuhr);
    final adjustedAsr = _applyOffset(asr, adj.asr + userAdj.asr);
    final adjustedMaghrib = _applyOffset(maghrib, adj.maghrib + userAdj.maghrib);
    final adjustedIsha = _applyOffset(isha, adj.isha + userAdj.isha);

    final result = SalahTimes(
      fajr: DateTimeRange(start: adjustedFajr, end: sunTimetable.sunrise.start),
      dhuhr: DateTimeRange(start: adjustedDhuhr, end: adjustedAsr),
      asr: DateTimeRange(start: adjustedAsr, end: adjustedMaghrib),
      maghrib: DateTimeRange(start: adjustedMaghrib, end: adjustedIsha),
      isha: DateTimeRange(start: adjustedIsha, end: adjustedFajr.add(const Duration(days: 1))),
      witr: DateTimeRange(
          start: adjustedIsha.add(const Duration(hours: 1)),
          end: adjustedFajr.add(const Duration(days: 1))),
      duha: DateTimeRange(
          start: sunTimetable.sunrise.end.add(const Duration(minutes: 20)),
          end: adjustedDhuhr),
      awwabin: DateTimeRange(
          start: adjustedMaghrib.add(const Duration(minutes: 20)), end: adjustedIsha),
      tahajjud: DateTimeRange(
          start: sunTimetable.nadir,
          end: adjustedFajr),
    );

    if (date.isUtc) return result;

    return SalahTimes(
      fajr: _toLocalRange(result.fajr),
      dhuhr: _toLocalRange(result.dhuhr),
      asr: _toLocalRange(result.asr),
      maghrib: _toLocalRange(result.maghrib),
      isha: _toLocalRange(result.isha),
      witr: _toLocalRange(result.witr),
      duha: _toLocalRange(result.duha),
      awwabin: _toLocalRange(result.awwabin),
      tahajjud: _toLocalRange(result.tahajjud),
    );
  }

  static DateTimeRange _toLocalRange(DateTimeRange r) =>
      DateTimeRange(start: r.start.toLocal(), end: r.end.toLocal());

  static DateTime _calculateTimeForAngle(DateTime date, double latitude,
      double longitude, double angle,
      {bool ishan = false}) {
    final jday = _getJulianDay(date);
    final jcentury = (jday - 2451545.0) / 36525.0;

    final meanLongitude =
        (280.46646 + jcentury * (36000.76983 + jcentury * 0.0003032)) % 360.0;
    final meanAnomaly =
        357.52911 + jcentury * (35999.05029 - 0.0001537 * jcentury);

    final sunEq = sin(_degToRad(meanAnomaly)) *
        (1.914602 - jcentury * (0.004817 + 0.000014 * jcentury)) +
        sin(_degToRad(2 * meanAnomaly)) * (0.019993 - 0.000101 * jcentury) +
        sin(_degToRad(3 * meanAnomaly)) * 0.000289;

    final sunTrueLong = meanLongitude + sunEq;
    final sunAppLong = sunTrueLong -
        0.00569 -
        0.00478 * sin(_degToRad(125.04 - 1934.136 * jcentury));
    final meanObliquity = 23.0 +
        (26.0 +
            (21.448 -
                jcentury *
                    (46.815 +
                        jcentury * (0.00059 - jcentury * 0.001813))) /
                60.0) /
            60.0;
    final obliquity =
        meanObliquity + 0.00256 * cos(_degToRad(125.04 - 1934.136 * jcentury));
    final declination =
    _radToDeg(asin(sin(_degToRad(obliquity)) * sin(_degToRad(sunAppLong))));

    final eccent =
        0.016708634 - jcentury * (0.000042037 + 0.0000001267 * jcentury);
    final varY = tan(_degToRad(obliquity / 2)) * tan(_degToRad(obliquity / 2));

    final eqOfTime = 4 *
        _radToDeg(varY * sin(2 * _degToRad(meanLongitude)) -
            2 * eccent * sin(_degToRad(meanAnomaly)) +
            4 *
                eccent *
                varY *
                sin(_degToRad(meanAnomaly)) *
                cos(2 * _degToRad(meanLongitude)) -
            0.5 * varY * varY * sin(4 * _degToRad(meanLongitude)) -
            1.25 * eccent * eccent * sin(2 * _degToRad(meanAnomaly)));

    final ha = _radToDeg(acos((sin(_degToRad(-angle)) -
        sin(_degToRad(latitude)) * sin(_degToRad(declination))) /
        (cos(_degToRad(latitude)) * cos(_degToRad(declination)))));

    final solarNoon = (720 - 4 * longitude - eqOfTime) / 1440;
    final time = solarNoon + (ishan ? (ha * 4) / 1440 : (-ha * 4) / 1440);

    return _getDateTime(date, time);
  }

  static DateTime _calculateAsrTime(DateTime date, double latitude,
      double longitude,
      {int madhab = 1}) {
    final jday = _getJulianDay(date);
    final jcentury = (jday - 2451545.0) / 36525.0;

    final meanLongitude =
        (280.46646 + jcentury * (36000.76983 + jcentury * 0.0003032)) % 360.0;
    final meanAnomaly =
        357.52911 + jcentury * (35999.05029 - 0.0001537 * jcentury);

    final sunEq = sin(_degToRad(meanAnomaly)) *
        (1.914602 - jcentury * (0.004817 + 0.000014 * jcentury)) +
        sin(_degToRad(2 * meanAnomaly)) * (0.019993 - 0.000101 * jcentury) +
        sin(_degToRad(3 * meanAnomaly)) * 0.000289;

    final sunTrueLong = meanLongitude + sunEq;
    final sunAppLong = sunTrueLong -
        0.00569 -
        0.00478 * sin(_degToRad(125.04 - 1934.136 * jcentury));
    final meanObliquity = 23.0 +
        (26.0 +
            (21.448 -
                jcentury *
                    (46.815 +
                        jcentury * (0.00059 - jcentury * 0.001813))) /
                60.0) /
            60.0;
    final obliquity =
        meanObliquity + 0.00256 * cos(_degToRad(125.04 - 1934.136 * jcentury));
    final declination =
    _radToDeg(asin(sin(_degToRad(obliquity)) * sin(_degToRad(sunAppLong))));

    final eccent =
        0.016708634 - jcentury * (0.000042037 + 0.0000001267 * jcentury);
    final varY = tan(_degToRad(obliquity / 2)) * tan(_degToRad(obliquity / 2));
    final eqOfTime = 4 *
        _radToDeg(varY * sin(2 * _degToRad(meanLongitude)) -
            2 * eccent * sin(_degToRad(meanAnomaly)) +
            4 *
                eccent *
                varY *
                sin(_degToRad(meanAnomaly)) *
                cos(2 * _degToRad(meanLongitude)) -
            0.5 * varY * varY * sin(4 * _degToRad(meanLongitude)) -
            1.25 * eccent * eccent * sin(2 * _degToRad(meanAnomaly)));

    final asrAlt = _radToDeg(
        atan(1 / (madhab + tan(_degToRad(latitude - declination).abs()))));
    final ha = _radToDeg(acos((sin(_degToRad(asrAlt)) -
        sin(_degToRad(latitude)) * sin(_degToRad(declination))) /
        (cos(_degToRad(latitude)) * cos(_degToRad(declination)))));

    final solarNoon = (720 - 4 * longitude - eqOfTime) / 1440;
    final time = solarNoon + (ha * 4) / 1440;

    return _getDateTime(date, time);
  }

  static double _getJulianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045.0;
  }

  static DateTime _applyOffset(DateTime dt, int minutes) =>
      dt.add(Duration(minutes: minutes));

  static double _degToRad(double deg) => deg * (pi / 180.0);

  static double _radToDeg(double rad) => rad * (180.0 / pi);

  static DateTime _getDateTime(DateTime date, double decimalHours) {
    final hour = decimalHours * 24;
    final minute = (hour - hour.floor()) * 60;
    final second = (minute - minute.floor()) * 60;
    return DateTime.utc(date.year, date.month, date.day, hour.floor(),
        minute.floor(), second.floor());
  }
}
