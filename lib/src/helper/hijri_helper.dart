import 'package:json_annotation/json_annotation.dart';
import 'package:virnavi_ai_agent_mcp/virnavi_ai_agent_mcp.dart';

part 'hijri_helper.g.dart';
part 'hijri_helper.mcp.dart';

/// Tabular Islamic (Hijri) calendar date.
///
/// Uses the standard astronomical tabular calendar with epoch
/// 1 Muharram 1 AH = JDN 1948440 (Friday, July 16, 622 CE Julian).
@McpModel()
@JsonSerializable()
class HijriDate {
  final int year;
  final int month; // 1–12
  final int day;   // 1–30

  const HijriDate(this.year, this.month, this.day);

  /// Returns true when this date falls in Ramadan (month 9).
  bool get isRamadan => month == 9;

  /// Returns true during the Hajj season: 8–13 Dhul Hijjah (month 12).
  /// This covers Yawm al-Tarwiyah (8th), Arafah (9th), Eid al-Adha (10th),
  /// and the three days of Tashreeq (11th–13th).
  bool get isHajjSeason => month == 12 && day >= 8 && day <= 13;

  /// Returns true on the Day of Arafah: 9 Dhul Hijjah.
  /// This is the most important day of Hajj.
  bool get isArafah => month == 12 && day == 9;

  /// Returns true on Eid al-Adha: 10 Dhul Hijjah.
  bool get isEidAlAdha => month == 12 && day == 10;

  /// Converts a Gregorian [date] to the corresponding tabular Hijri date.
  static HijriDate fromGregorian(DateTime date) {
    // ── Step 1: Gregorian → Julian Day Number ─────────────────────────────
    final int y = date.year, m = date.month, d = date.day;
    final int a = (14 - m) ~/ 12;
    final int Y = y + 4800 - a;
    final int M = m + 12 * a - 3;
    final int jdn = d +
        (153 * M + 2) ~/ 5 +
        365 * Y +
        Y ~/ 4 -
        Y ~/ 100 +
        Y ~/ 400 -
        32045;

    // ── Step 2: JDN → Hijri ───────────────────────────────────────────────
    // N = days elapsed since the Islamic epoch (N=1 on 1 Muharram 1 AH).
    final int N = jdn - 1948439;

    // Approximate Hijri year, then correct with at most one iteration.
    int hy = N * 30 ~/ 10631 + 1;
    while (_yearStart(hy + 1) < N) {
      hy++;
    }
    while (_yearStart(hy) >= N) {
      hy--;
    }

    // Day within the Hijri year (1-indexed).
    final int dayInYear = N - _yearStart(hy);

    // Hijri month: odd months have 30 days, even months have 29 days.
    // Cumulative days before month m = 29*(m-1) + m÷2.
    final int hm = (2 * (dayInYear - 1)) ~/ 59 + 1;

    // Day within the month.
    final int hd = dayInYear - (29 * (hm - 1) + hm ~/ 2);

    return HijriDate(hy, hm, hd);
  }

  /// Days from the Islamic epoch to the *start* of Hijri year [y].
  /// Year y begins at day (_yearStart(y) + 1) in the N numbering.
  static int _yearStart(int y) => (y - 1) * 354 + (11 * y - 2) ~/ 30;

  /// Human-readable Hijri month names.
  static const _monthNames = [
    '', // 1-indexed
    'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
    'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', "Sha'ban",
    'Ramadan', 'Shawwal', "Dhul Qa'dah", 'Dhul Hijjah',
  ];

  String get monthName => _monthNames[month];

  factory HijriDate.fromJson(Map<String, dynamic> json) =>
      _$HijriDateFromJson(json);

  Map<String, dynamic> toJson() => _$HijriDateToJson(this);

  @override
  String toString() => '$day $monthName $year AH';
}
