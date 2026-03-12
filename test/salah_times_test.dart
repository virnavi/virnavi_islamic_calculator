import 'package:flutter_test/flutter_test.dart';
import 'package:virnavi_islamic_calculator/virnavi_islamic_calculator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ── IslamicCalculatorService ───────────────────────────────────────────────

  group('IslamicCalculatorService', () {
    const service = IslamicCalculatorService();

    test('getSalahTimes returns correct prayer times for Dhaka 2025', () async {
      final countryConfig = await service.getCountryConfig('bd');
      var method =
          await service.getCalculationMethod(countryConfig.method.defaultValue);
      method = method.copyWith(madhab: countryConfig.asrMethod.defaultValue);

      final times = await service.getSalahTimes(
        date: DateTime.utc(2025, 9, 23),
        latitude: 23.777176,
        longitude: 90.399452,
        method: method,
      );

      expect(
        DateTime.utc(2025, 9, 22, 22, 32).difference(times.fajr.start).inMinutes,
        closeTo(0, 1),
      );
      expect(
        DateTime.utc(2025, 9, 23, 5, 51).difference(times.dhuhr.start).inMinutes,
        closeTo(0, 1),
      );
      expect(
        DateTime.utc(2025, 9, 23, 11, 54).difference(times.maghrib.start).inMinutes,
        closeTo(0, 1),
      );
    });

    test('toHijriDate converts Gregorian to Hijri correctly', () {
      final hijri = service.toHijriDate(DateTime(2023, 3, 23));
      expect(hijri.year, 1444);
      expect(hijri.month, 9); // Ramadan
      expect(hijri.day, 1);
      expect(hijri.isRamadan, isTrue);
    });

    test('todayHijri returns a valid HijriDate for today', () {
      final hijri = service.todayHijri;
      expect(hijri.year, greaterThan(1440));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
    });

    test('calculateZakat returns correct result above nisab', () {
      final result = service.calculateZakat(
        goldPricePerGram: 8000,
        silverPricePerGram: 100,
        cash: 500000,
        goldValue: 200000,
        investments: 100000,
        debts: 50000,
      );
      expect(result.isZakatDue, isTrue);
      expect(result.zakatDue, closeTo(18750, 1));
      expect(result.netWealth, closeTo(750000, 1));
      expect(result.nisabStandard, NisabStandard.gold);
    });

    test('calculateZakat returns zero when below nisab', () {
      final result = service.calculateZakat(
        goldPricePerGram: 8000,
        silverPricePerGram: 100,
        cash: 400000,
        debts: 100000,
      );
      expect(result.isZakatDue, isFalse);
      expect(result.zakatDue, closeTo(0, 0.01));
    });

    test('calculateZakat uses silver nisab when specified', () {
      final result = service.calculateZakat(
        goldPricePerGram: 8000,
        silverPricePerGram: 100,
        nisabStandard: NisabStandard.silver,
        cash: 300000,
      );
      expect(result.isZakatDue, isTrue);
      expect(result.applicableNisab, closeTo(59500, 1));
      expect(result.zakatDue, closeTo(300000 * 0.025, 1));
    });

    test('getCalculationMethod returns the correct method', () async {
      final method = await service.getCalculationMethod('karachi');
      expect(method.id, 'karachi');
      expect(method.fajrAngle, isNonZero);
    });

    test('getCalculationMethod throws for unknown method', () async {
      expect(
        () => service.getCalculationMethod('unknown_method_xyz'),
        throwsA(isA<Exception>()),
      );
    });

    test('getCountryConfig returns config for Bangladesh', () async {
      final config = await service.getCountryConfig('bd');
      expect(config.method.defaultValue, isNotEmpty);
      expect(config.ids, isNotEmpty);
    });

    test('getCountryConfig throws for unknown country code', () async {
      expect(
        () => service.getCountryConfig('ZZ'),
        throwsA(isA<Exception>()),
      );
    });

    test('getAllCalculationMethods returns a non-empty list', () async {
      final methods = await service.getAllCalculationMethods();
      expect(methods, isNotEmpty);
      expect(methods.every((m) => m.id.isNotEmpty), isTrue);
    });

    test('getConfig returns a valid SalahTimeConfig', () async {
      final config = await service.getConfig();
      expect(config.methods, isNotEmpty);
      expect(config.config, isNotEmpty);
    });
  });

  test('SalahTime calculate returns correct prayer times for Dhaka 2025',
      () async {
  final countryConfig = (await CountryConfig.getByCountryCode('bd'));
    var method = await SalahCalculationMethod.getCalculationMethod(
        countryConfig.method.defaultValue);
    method = method.copyWith(
      madhab: countryConfig.asrMethod.defaultValue,
    );
    final salahTimes = await SalahTimes.calculate(
      date: DateTime.utc(2025, 9, 23),
      latitude: 23.777176,
      longitude: 90.399452,
      method: method,
    );
    // Approximate expected times for Dhaka on 2025-09-23 (Karachi method, Hanafi madhab)
    final fajr = DateTime.utc(2025, 9, 22, 22, 32);
    expect(fajr.difference(salahTimes.fajr.start).inMinutes, closeTo(0, 1));
    final dhuhr = DateTime.utc(2025, 9, 23, 5, 51);
    expect(dhuhr.difference(salahTimes.dhuhr.start).inMinutes, closeTo(0, 1));
    final asr = DateTime.utc(2025, 9, 23, 10, 12); // Hanafi (shadow factor 2)
    expect(asr.difference(salahTimes.asr.start).inMinutes, closeTo(0, 1));
    final maghrib = DateTime.utc(2025, 9, 23, 11, 54);
    expect(
        maghrib.difference(salahTimes.maghrib.start).inMinutes, closeTo(0, 1));
    final isha = DateTime.utc(2025, 9, 23, 13, 9);
    expect(isha.difference(salahTimes.isha.start).inMinutes, closeTo(0, 1));
  });

  test('HijriDate conversion is correct', () {
    // 1 Ramadan 1444 = March 23, 2023
    final h1 = HijriDate.fromGregorian(DateTime(2023, 3, 23));
    expect(h1.year, 1444);
    expect(h1.month, 9); // Ramadan
    expect(h1.day, 1);
    expect(h1.isRamadan, isTrue);

    // 1 Ramadan 1447 = Feb 18, 2026
    final h2 = HijriDate.fromGregorian(DateTime(2026, 2, 18));
    expect(h2.year, 1447);
    expect(h2.month, 9);
    expect(h2.day, 1);

    // March 5, 2026 = 16 Ramadan 1447
    final h3 = HijriDate.fromGregorian(DateTime(2026, 3, 5));
    expect(h3.year, 1447);
    expect(h3.month, 9);
    expect(h3.day, 16);

    // 1 Muharram 1 AH = not Ramadan
    expect(HijriDate.fromGregorian(DateTime(2024, 6, 15)).isRamadan, isFalse);
  });

  test('HijriDate Hajj season detection is correct', () {
    // Tabular calendar dates for Dhul Hijjah 1443 AH.
    // Note: the tabular algorithm may differ by 1 day from moon-sighted calendars.

    // 8 Dhul Hijjah 1443 = July 8, 2022 (Yawm al-Tarwiyah)
    final h8 = HijriDate.fromGregorian(DateTime(2022, 7, 8));
    expect(h8.month, 12);
    expect(h8.day, 8);
    expect(h8.isHajjSeason, isTrue);
    expect(h8.isArafah, isFalse);
    expect(h8.isEidAlAdha, isFalse);

    // 9 Dhul Hijjah 1443 = July 9, 2022 (Day of Arafah)
    final h9 = HijriDate.fromGregorian(DateTime(2022, 7, 9));
    expect(h9.day, 9);
    expect(h9.isHajjSeason, isTrue);
    expect(h9.isArafah, isTrue);
    expect(h9.isEidAlAdha, isFalse);

    // 10 Dhul Hijjah 1443 = July 10, 2022 (Eid al-Adha)
    final h10 = HijriDate.fromGregorian(DateTime(2022, 7, 10));
    expect(h10.day, 10);
    expect(h10.isHajjSeason, isTrue);
    expect(h10.isArafah, isFalse);
    expect(h10.isEidAlAdha, isTrue);

    // 13 Dhul Hijjah 1443 = July 13, 2022 (last day of Tashreeq)
    final h13 = HijriDate.fromGregorian(DateTime(2022, 7, 13));
    expect(h13.day, 13);
    expect(h13.isHajjSeason, isTrue);

    // 14 Dhul Hijjah 1443 = July 14, 2022 (outside Hajj season)
    final h14 = HijriDate.fromGregorian(DateTime(2022, 7, 14));
    expect(h14.day, 14);
    expect(h14.isHajjSeason, isFalse);

    // 7 Dhul Hijjah = day before Hajj season starts
    final h7 = HijriDate.fromGregorian(DateTime(2022, 7, 7));
    expect(h7.day, 7);
    expect(h7.isHajjSeason, isFalse);

    // Ramadan date — not Hajj season
    expect(HijriDate.fromGregorian(DateTime(2026, 3, 5)).isHajjSeason, isFalse);
  });

  test('ZakatCalculator calculates correctly', () {
    // Person with wealth well above nisab
    final calc = ZakatCalculator(
      goldPricePerGram: 8000, // e.g. BDT 8000/g
      silverPricePerGram: 100,
      cash: 500000,
      goldValue: 200000,
      investments: 100000,
      debts: 50000,
    );

    // nisab by gold = 85 * 8000 = 680,000
    expect(calc.nisabByGold, closeTo(680000, 1));
    // nisab by silver = 595 * 100 = 59,500
    expect(calc.nisabBySilver, closeTo(59500, 1));

    // gross wealth = 500000 + 200000 + 100000 = 800,000
    expect(calc.grossWealth, closeTo(800000, 1));
    // net wealth = 800,000 - 50,000 = 750,000
    expect(calc.netWealth, closeTo(750000, 1));

    // meets gold nisab (750,000 >= 680,000) → zakat due
    expect(calc.isZakatDue, isTrue);
    // zakat = 750,000 * 2.5% = 18,750
    expect(calc.zakatDue, closeTo(18750, 1));

    final result = calc.calculate();
    expect(result.isZakatDue, isTrue);
    expect(result.zakatDue, closeTo(18750, 1));
    expect(result.nisabStandard, NisabStandard.gold);
    expect(result.applicableNisab, closeTo(680000, 1));
  });

  test('ZakatCalculator returns zero zakat when below nisab', () {
    final calc = ZakatCalculator(
      goldPricePerGram: 8000,
      silverPricePerGram: 100,
      cash: 400000,
      debts: 100000,
    );
    // net wealth = 300,000 < nisab gold 680,000
    expect(calc.isZakatDue, isFalse);
    expect(calc.zakatDue, closeTo(0, 0.01));
  });

  test('ZakatCalculator silver nisab standard', () {
    // net wealth = 300,000 < gold nisab (680,000) but > silver nisab (59,500)
    final calc = ZakatCalculator(
      goldPricePerGram: 8000,
      silverPricePerGram: 100,
      nisabStandard: NisabStandard.silver,
      cash: 300000,
    );
    expect(calc.isZakatDue, isTrue); // 300,000 >= 59,500
    expect(calc.zakatDue, closeTo(300000 * 0.025, 1));
    expect(calc.applicableNisab, closeTo(59500, 1));
  });
}
