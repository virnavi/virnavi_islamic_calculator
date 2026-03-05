## 0.0.1

Initial stable release.

### Features
- **Prayer times** — accurate salah times (Fajr, Dhuhr, Asr, Maghrib, Isha) plus sunnah prayers (Tahajjud, Duha, Awwabin, Witr)
- **Multiple calculation methods** — Karachi, ISNA, MWL, Makkah, Egypt, Tehran, Gulf, Kuwait, Qatar, Singapore, France, Turkey, Russia, Moonsighting, Dubai, Jordan, Tunisia, Algeria, Indonesia, Morocco, Portugal, and more, sourced from a bundled JSON configuration
- **Per-country defaults** — `CountryConfig.getByCountryCode('bd')` returns the recommended method and Asr madhab for any country
- **Madhab support** — Hanafi (shadow factor 2) and Shafi/Maliki/Hanbali (shadow factor 1) for Asr
- **Method adjustments** — per-prayer minute offsets via `copyWith(adjustments: ...)`
- **Local time I/O** — UTC input → UTC output; local input → local output
- **Hijri calendar** — `HijriDate.fromGregorian(date)` using the tabular 30-year cycle algorithm
- **Ramadan detection** — `SalahTimes.isRamadan`, `SalahTimes.imsak` (10 min before Fajr)
- **Hajj season detection** — `isHajjSeason` (8–13 Dhul Hijjah), `isArafah` (9th), `isEidAlAdha` (10th)
- **Zakat calculator** — `ZakatCalculator` with gold/silver nisab selection (85 g gold or 595 g silver), gross/net wealth breakdown, 2.5% zakat computation
- **JSON serialization** — `SalahTimes.toJson()` / `SalahTimes.fromJson()` via `SunTimeTable`
