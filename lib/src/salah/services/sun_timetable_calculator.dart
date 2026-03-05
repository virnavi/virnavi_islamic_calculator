/*
import 'dart:math';

class SunTimetableCalculator {
  static SunTimetable calculate(DateTime date, double latitude, double longitude) {
    final jday = _getJulianDay(date);
    final jcentury = (jday - 2451545.0) / 36525.0;

    final meanLongitude = (280.46646 + jcentury * (36000.76983 + jcentury * 0.0003032)) % 360.0;
    final meanAnomaly = 357.52911 + jcentury * (35999.05029 - 0.0001537 * jcentury);
    final eccent = 0.016708634 - jcentury * (0.000042037 + 0.0000001267 * jcentury);

    final sunEq = sin(_degToRad(meanAnomaly)) * (1.914602 - jcentury * (0.004817 + 0.000014 * jcentury)) +
        sin(_degToRad(2 * meanAnomaly)) * (0.019993 - 0.000101 * jcentury) +
        sin(_degToRad(3 * meanAnomaly)) * 0.000289;

    final sunTrueLong = meanLongitude + sunEq;
    final sunAppLong = sunTrueLong - 0.00569 - 0.00478 * sin(_degToRad(125.04 - 1934.136 * jcentury));
    final meanObliquity = 23.0 + (26.0 + (21.448 - jcentury * (46.815 + jcentury * (0.00059 - jcentury * 0.001813))) / 60.0) / 60.0;
    final obliquity = meanObliquity + 0.00256 * cos(_degToRad(125.04 - 1934.136 * jcentury));

    final declination = _radToDeg(asin(sin(_degToRad(obliquity)) * sin(_degToRad(sunAppLong))));
    final varY = tan(_degToRad(obliquity / 2)) * tan(_degToRad(obliquity / 2));

    final eqOfTime = 4 * _radToDeg(varY * sin(2 * _degToRad(meanLongitude)) -
        2 * eccent * sin(_degToRad(meanAnomaly)) +
        4 * eccent * varY * sin(_degToRad(meanAnomaly)) * cos(2 * _degToRad(meanLongitude)) -
        0.5 * varY * varY * sin(4 * _degToRad(meanLongitude)) -
        1.25 * eccent * eccent * sin(2 * _degToRad(meanAnomaly)));

    final haSunrise = _radToDeg(acos(cos(_degToRad(90.833)) / (cos(_degToRad(latitude)) * cos(_degToRad(declination))) - tan(_degToRad(latitude)) * tan(_degToRad(declination))));

    final solarNoon = (720 - 4 * longitude - eqOfTime) / 1440;
    final sunrise = (solarNoon * 1440 - haSunrise * 4) / 1440;
    final sunset = (solarNoon * 1440 + haSunrise * 4) / 1440;
    final nadir = solarNoon - 0.5;

    return SunTimetable(
      solarNoon: _getDateTime(date, solarNoon),
      nadir: _getDateTime(date, nadir),
      sunriseStart: _getDateTime(date, sunrise),
      sunriseEnd: _getDateTime(date, sunrise).add(const Duration(minutes: 4)), // Approximation
      sunsetStart: _getDateTime(date, sunset).subtract(const Duration(minutes: 4)), // Approximation
      sunsetEnd: _getDateTime(date, sunset),
      dawn: _getDateTime(date, sunrise - (haSunrise * 4 / 1440) * (1 / 5)), // Civil twilight approximation
      dusk: _getDateTime(date, sunset + (haSunrise * 4 / 1440) * (1 / 5)), // Civil twilight approximation
      nauticalDawn: _getDateTime(date, sunrise - (haSunrise * 4 / 1440) * (2 / 5)), // Nautical twilight approximation
      nauticalDusk: _getDateTime(date, sunset + (haSunrise * 4 / 1440) * (2 / 5)), // Nautical twilight approximation
      nightStart: _getDateTime(date, sunset + (haSunrise * 4 / 1440) * (4/5)),
      nightEnd: _getDateTime(date, sunrise - (haSunrise * 4 / 1440) * (4/5)),
      goldenHourStart: _getDateTime(date, sunset - (haSunrise * 4 / 1440) * (1/3)),
      goldenHourEnd: _getDateTime(date, sunset),
    );
  }

  static double _getJulianDay(DateTime date) {
    final a = (14 - date.month) ~/ 12;
    final y = date.year + 4800 - a;
    final m = date.month + 12 * a - 3;
    return date.day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045.0;
  }

  static double _degToRad(double deg) => deg * (pi / 180.0);

  static double _radToDeg(double rad) => rad * (180.0 / pi);

  static DateTime _getDateTime(DateTime date, double decimalHours) {
    final hour = decimalHours * 24;
    final minute = (hour - hour.floor()) * 60;
    final second = (minute - minute.floor()) * 60;
    return DateTime(date.year, date.month, date.day, hour.floor(), minute.floor(), second.floor());
  }
}


import 'dart:math';

class SunCalc {
  static const double rad = pi / 180;
  // Date/time constants and conversions
  static const double dayMs = 1000 * 60 * 60 * 24;
  static const double J1970 = 2440588;
  static const double J2000 = 2451545;

  static double toJulian(DateTime date) =>
      date.millisecondsSinceEpoch / dayMs - 0.5 + J1970;
  static DateTime fromJulian(double j) =>
      DateTime.fromMillisecondsSinceEpoch(((j + 0.5 - J1970) * dayMs).toInt());
  static double toDays(DateTime date) => toJulian(date) - J2000;
  // General calculations for position
  static final double e = rad * 23.4397; // Obliquity of the Earth

  static double _rightAscension(double l, double b) =>
      atan2(sin(l) * cos(e) - tan(b) * sin(e), cos(l));

  static double _declination(double l, double b) =>
      asin(sin(b) * cos(e) + cos(b) * sin(e) * sin(l));

  static double _azimuth(double H, double phi, double dec) =>
      atan2(sin(H), cos(H) * sin(phi) - tan(dec) * cos(phi));

  static double _altitude(double H, double phi, double dec) =>
      asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(H));

  static double _siderealTime(double d, double lw) =>
      rad * (280.16 + 360.9856235 * d) - lw;

  static double _astroRefraction(double h) {
    if (h < 0) {
      // The following formula works for positive altitudes only.
      // If h = -0.08901179 a div/0 would occur.
      h = 0;
    }
    // Formula 16.4 of "Astronomical Algorithms" 2nd edition by Jean Meeus
    // 1.02 / tan(h + 10.26 / (h + 5.10)) h in degrees, result in arc minutes
    // Converted to rad:
    return 0.0002967 / tan(h + 0.00312536 / (h + 0.08901179));
  }

  // Solar calculations
  static double _solarMeanAnomaly(double d) =>
      rad * (357.5291 + 0.98560028 * d);

  static double _eclipticLongitude(double M) {
    // Equation of center
    double C =
        rad * (1.9148 * sin(M) + 0.02 * sin(2 * M) + 0.0003 * sin(3 * M));
    // Perihelion of the Earth
    double P = rad * 102.9372;
    return M + C + P + pi;
  }

  static Map<String, double> _sunCoords(double d) {
    double M = _solarMeanAnomaly(d);
    double L = _eclipticLongitude(M);
    return {
      'dec': _declination(L, 0),
      'ra': _rightAscension(L, 0),
    };
  }

  // Sun position for a given date and latitude/longitude
  static Map<String, double> getSunPosition(
      DateTime date, double lat, double lng) {
    double lw = rad * -lng;
    double phi = rad * lat;
    double d = toDays(date);

    Map<String, double> c = _sunCoords(d);
    double H = _siderealTime(d, lw) - c['ra']!;

    return {
      'azimuth': _azimuth(H, phi, c['dec']!),
      'altitude': _altitude(H, phi, c['dec']!),
    };
  }

  // Sun times configuration (angle, morning name, evening name)
  static final List<List<dynamic>> _times = [
    [-0.833, 'sunrise', 'sunset'],
    [-0.3, 'sunriseEnd', 'sunsetStart'],
    [-6, 'dawn', 'dusk'],
    [-12, 'nauticalDawn', 'nauticalDusk'],
    [-18, 'nightEnd', 'night'],
    [6, 'goldenHourEnd', 'goldenHour'],
  ];

  // Adds a custom time to the times config
  static void _addTime(double angle, String riseName, String setName) {
    _times.add([angle, riseName, setName]);
  }

  // Julian cycle
  static double _julianCycle(double d, double lw) =>
      (d - 0.0009 - lw / (2 * pi)).roundToDouble();

  // Approximate Transit
  static double _approxTransit(double Ht, double lw, double n) =>
      0.0009 + (Ht + lw) / (2 * pi) + n;

  // Solar Transit
  static double _solarTransitJ(double ds, double M, double L) =>
      J2000 + ds + 0.0053 * sin(M) - 0.0069 * sin(2 * L);

  // Hour Angle
  static double _hourAngle(double h, double phi, double d) =>
      acos((sin(h) - sin(phi) * sin(d)) / (cos(phi) * cos(d)));

  // Observer Angle
  static double _observerAngle(double height) => -2.076 * sqrt(height) / 60;

  // Set time for the given sun altitude
  static double _getSetJ(double h, double lw, double phi, double dec, double n,
      double M, double L) {
    double w = _hourAngle(h, phi, dec);
    double a = _approxTransit(w, lw, n);
    return _solarTransitJ(a, M, L);
  }

  // Sun times calculation
  static Map<String, DateTime> getTimes(DateTime date, double lat, double lng,
      [double height = 0.0]) {
    double lw = rad * -lng;
    double phi = rad * lat;
    double dh = _observerAngle(height);
    double d = toDays(date);
    double n = _julianCycle(d, lw);
    double ds = _approxTransit(0, lw, n);
    double M = _solarMeanAnomaly(ds);
    double L = _eclipticLongitude(M);
    double dec = _declination(L, 0);
    double Jnoon = _solarTransitJ(ds, M, L);

    Map<String, DateTime> result = {
      'solarNoon': fromJulian(Jnoon),
      'nadir': fromJulian(Jnoon - 0.5),
    };

    for (var time in _times) {
      double h0 = (time[0] + dh) * rad;
      double Jset = _getSetJ(h0, lw, phi, dec, n, M, L);
      double Jrise = Jnoon - (Jset - Jnoon);
      result[time[1]] = fromJulian(Jrise);
      result[time[2]] = fromJulian(Jset);
    }

    return result;
  }

  // Moon calculations
  static Map<String, dynamic> _moonCoords(double d) {
    double L = rad * (218.316 + 13.176396 * d); // Ecliptic longitude
    double M = rad * (134.963 + 13.064993 * d); // Mean anomaly
    double F = rad * (93.272 + 13.229350 * d); // Mean distance

    double l = L + rad * 6.289 * sin(M); // Longitude
    double b = rad * 5.128 * sin(F); // Latitude
    double dt = 385001 - 20905 * cos(M); // Distance to the moon in km

    return {
      'ra': _rightAscension(l, b),
      'dec': _declination(l, b),
      'dist': dt,
    };
  }

  // Moon position for a given date and latitude/longitude
  static Map<String, dynamic> getMoonPosition(
      DateTime date, double lat, double lng) {
    double lw = rad * -lng;
    double phi = rad * lat;
    double d = toDays(date);

    Map<String, dynamic> c = _moonCoords(d);
    double H = _siderealTime(d, lw) - c['ra'];
    double h = _altitude(H, phi, c['dec']);
    double pa =
        atan2(sin(H), tan(phi) * cos(c['dec']) - sin(c['dec']) * cos(H));
    h += _astroRefraction(h); // Altitude correction for refraction

    return {
      'azimuth': _azimuth(H, phi, c['dec']),
      'altitude': h,
      'distance': c['dist'],
      'parallacticAngle': pa,
    };
  }

  // Moon illumination
  static Map<String, double> getMoonIllumination([DateTime? date]) {
    DateTime d = date ?? DateTime.now();
    double days = toDays(d);
    Map<String, double> s = _sunCoords(days);
    Map<String, dynamic> m = _moonCoords(days);

    double sdist = 149598000; // Distance from Earth to Sun in km

    double phi = acos(sin(s['dec']!) * sin(m['dec']) +
        cos(s['dec']!) * cos(m['dec']!) * cos(s['ra']! - m['ra']!));
    double inc = atan2(sin(phi) * sdist, m['dist'] - sdist * cos(phi));
    double angle = atan2(
        cos(s['dec']!) * sin(s['ra']! - m['ra']!),
        sin(s['dec']!) * cos(m['dec']!) -
            cos(s['dec']!) * sin(m['dec']!) * cos(s['ra']! - m['ra']!));

    return {
      'fraction': (1 + cos(inc)) / 2,
      'phase': 0.5 + 0.5 * inc * (angle < 0 ? -1 : 1) / pi,
      'angle': angle,
    };
  }

  // Helper function to add hours
  static DateTime _hoursLater(DateTime date, double h) =>
      date.add(Duration(milliseconds: h * dayMs ~/ 24));

  // Moon rise/set times
  static Map<String, dynamic> getMoonTimes(
      DateTime date, double lat, double lng,
      {bool inUTC = false}) {
    DateTime t =
        DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);
    if (inUTC) {
      t = DateTime.utc(t.year, t.month, t.day);
    } else {
      t = DateTime(t.year, t.month, t.day);
    }

    double hc = 0.133 * rad;
    double h0 = getMoonPosition(t, lat, lng)['altitude']! - hc;
    double? rise;
    double? set;
    double? ye;
    double h1, h2;
    double? x1;
    double? x2;
    double? dx;

    for (int i = 1; i <= 24; i += 2) {
      h1 = getMoonPosition(_hoursLater(t, i * 1.0), lat, lng)['altitude']! - hc;
      h2 = getMoonPosition(
              _hoursLater(t, (i + 1) * 1.0), lat, lng)['altitude']! -
          hc;

      double a = (h0 + h2) / 2 - h1;
      double b = (h2 - h0) / 2;
      double xe = -b / (2 * a);
      double yeCalc = (a * xe + b) * xe + h1;
      double dCalc = b * b - 4 * a * h1;
      int roots = 0;

      if (dCalc >= 0) {
        dx = sqrt(dCalc) / (2 * a.abs());
        x1 = xe - dx;
        x2 = xe + dx;
        if (x1.abs() <= 1) roots++;
        if (x2.abs() <= 1) roots++;
        if (x1 < -1) x1 = x2;
      }

      if (roots == 1) {
        if (h0 < 0) {
          rise = i + (x1 ?? 0);
        } else {
          set = i + (x1 ?? 0);
        }
      } else if (roots == 2) {
        rise = yeCalc < 0 ? (i + (x2 ?? 0)) : (i + (x1 ?? 0));
        set = yeCalc < 0 ? (i + (x1 ?? 0)) : (i + (x2 ?? 0));
      }

      if (rise != null && set != null) break;

      h0 = h2;
      ye = yeCalc;
    }

    Map<String, dynamic> result = {};

    if (rise != null) {
      result['rise'] = _hoursLater(t, rise);
    }
    if (set != null) {
      result['set'] = _hoursLater(t, set);
    }
    if (rise == null && set == null) {
      result[ye! > 0 ? 'alwaysUp' : 'alwaysDown'] = true;
    }

    return result;
  }
}
*/
