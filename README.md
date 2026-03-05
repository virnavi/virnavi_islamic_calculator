# virnavi_islamic_calculator

A Flutter package for Islamic calculations — prayer times, Hijri calendar, Ramadan & Hajj detection, and Zakat.

## Features

- **Prayer times** with 20+ built-in calculation methods and per-country defaults
- **Madhab selection** — Hanafi or Shafi/Maliki/Hanbali Asr shadow factor
- **Sunnah prayers** — Tahajjud, Duha, Awwabin, Witr
- **Hijri calendar** converter (tabular 30-year cycle)
- **Ramadan** detection with Imsak time
- **Hajj season** detection — Arafah, Eid al-Adha, Tashreeq days
- **Zakat calculator** — gold/silver nisab, gross/net wealth, 2.5% computation
- **JSON serialization** for caching timetables
- **Local time I/O** — pass a local `DateTime` to get local times back

---

## Getting Started

```yaml
dependencies:
  virnavi_islamic_calculator: ^1.0.0
```

---

## Usage

### Prayer times — country defaults

```dart
import 'package:virnavi_islamic_calculator/virnavi_islamic_calculator.dart';

// Load the recommended method for a country
final config = await CountryConfig.getByCountryCode('bd'); // Bangladesh
var method = await SalahCalculationMethod.getCalculationMethod(
    config.method.defaultValue);
method = method.copyWith(madhab: config.asrMethod.defaultValue);

// Calculate for today (local time in, local time out)
final times = await SalahTimes.calculate(
  date: DateTime.now(),
  latitude: 23.7771,
  longitude: 90.3994,
  method: method,
);

print(times.fajr.start);    // local DateTime
print(times.maghrib.start); // local DateTime
print(times.imsak);         // 10 min before Fajr (Ramadan use)
```

### Choosing a specific method

```dart
final config = await SalahTimeConfig.get();
// config.methods — full list of all available methods

final method = await SalahCalculationMethod.getCalculationMethod('karachi');
```

### Applying custom minute adjustments

```dart
final adjusted = method.copyWith(
  adjustments: Adjustments(fajr: 2, isha: -1),
);
```

### Hijri calendar

```dart
final hijri = HijriDate.fromGregorian(DateTime.now());
print(hijri);           // e.g. "16 Ramadan 1447 AH"
print(hijri.isRamadan); // true/false
print(hijri.monthName); // "Ramadan"
```

### Ramadan

```dart
final times = await SalahTimes.calculate(...);
if (times.isRamadan) {
  print('Imsak: ${times.imsak}');          // 10 min before Fajr
  print('Suhoor ends: ${times.fajr.start}');
  print('Iftar: ${times.maghrib.start}');
}
```

### Hajj season

```dart
if (times.isHajjSeason) {
  if (times.isArafah)    print('Day of Arafah — fast today!');
  if (times.isEidAlAdha) print('Eid al-Adha Mubarak!');
}
```

### Zakat calculator

```dart
final calc = ZakatCalculator(
  goldPricePerGram: 8000,   // your local currency per gram
  silverPricePerGram: 100,
  nisabStandard: NisabStandard.gold, // or NisabStandard.silver
  cash: 500000,
  goldValue: 200000,
  investments: 100000,
  debts: 50000,
);

final result = calc.calculate();
print('Net wealth: ${result.netWealth}');
print('Nisab: ${result.applicableNisab}');
print('Zakat due: ${result.zakatDue}');    // 0 if below nisab
print('Is zakat due: ${result.isZakatDue}');
```

---

## Calculation Methods

| ID | Name |
|----|------|
| `karachi` | University of Islamic Sciences, Karachi |
| `isna` | Islamic Society of North America |
| `mwl` | Muslim World League |
| `makkah` | Umm Al-Qura University, Makkah |
| `egypt` | Egyptian General Authority of Survey |
| `tehran` | Institute of Geophysics, University of Tehran |
| `gulf` | Gulf Region |
| `kuwait` | Kuwait |
| `qatar` | Qatar |
| `singapore` | Majlis Ugama Islam Singapura |
| `france` | Union des organisations islamiques de France |
| `turkey` | Diyanet İşleri Başkanlığı |
| `russia` | Spiritual Administration of Muslims of Russia |
| `dubai` | Dubai |
| `morocco` | Morocco |
| ...and more | See `SalahTimeConfig.get()` for the full list |

---

## Accuracy

Results are verified against IslamicFinder for Dhaka (Karachi method, Hanafi madhab):

| Prayer  | This package | IslamicFinder | Diff |
|---------|-------------|---------------|------|
| Fajr    | 05:01       | 05:03         | 2 min |
| Dhuhr   | 12:11       | 12:11         | exact |
| Maghrib | 18:04       | 18:03         | 1 min |
| Isha    | 19:18       | 19:18         | exact |

Asr difference is expected when comparing different madhabs (Hanafi vs Shafi).

---

## Contributors

| Name | Role |
|------|------|
| [Mohammed Shakib (@shakib1989)](https://github.com/shakib1989) | Main Library Development |

---

## Additional Information

- Issues & contributions: open an issue or PR on GitHub
- Prayer time calculations use standard solar angle formulas (suncalc-based)
- The Hijri calendar uses the tabular 30-year cycle; results may differ by ±1 day from moon-sighting-based calendars
- Zakat nisab values follow the standard scholarly consensus (85 g gold / 595 g silver)
