import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:virnavi_islamic_calculator/virnavi_islamic_calculator.dart' as ipt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prayer Times',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PrayerTimesPage(),
    );
  }
}

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  // Default: Dhaka, Bangladesh
  static const double _defaultLat = 23.777176;
  static const double _defaultLng = 90.399452;

  late Future<_PrayerData> _prayerData;
  String _selectedMethodId = 'karachi';
  ipt.Madhab _selectedMadhab = ipt.Madhab.hanafi;
  List<ipt.SalahCalculationMethod> _allMethods = [];
  double? _lat;
  double? _lng;
  bool _usingGps = false;

  @override
  void initState() {
    super.initState();
    _loadMethodsAndCalculate();
  }

  Future<void> _loadMethodsAndCalculate() async {
    final config = await ipt.SalahTimeConfig.get();
    setState(() {
      _allMethods = config.methods;
    });
    await _loadLocation();
  }

  Future<void> _loadLocation() async {
    double lat = _defaultLat;
    double lng = _defaultLng;
    bool gps = false;

    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission perm = permission;
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.whileInUse ||
          perm == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 10),
          ),
        );
        lat = pos.latitude;
        lng = pos.longitude;
        gps = true;
      }
    } catch (_) {
      // Fall through to default coordinates
    }

    setState(() {
      _lat = lat;
      _lng = lng;
      _usingGps = gps;
      _prayerData = _calculate(lat, lng);
    });
  }

  Future<_PrayerData> _calculate(double lat, double lng) async {
    final method = await ipt.SalahCalculationMethod.getCalculationMethod(
        _selectedMethodId);
    final adjusted = method.copyWith(madhab: _selectedMadhab);
    final times = await ipt.SalahTimes.calculate(
      date: DateTime.now(),
      latitude: lat,
      longitude: lng,
      method: adjusted,
    );
    return _PrayerData(times: times, lat: lat, lng: lng);
  }

  void _recalculate() {
    setState(() {
      _prayerData = _calculate(_lat ?? _defaultLat, _lng ?? _defaultLng);
    });
  }

  void _openZakat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ZakatScreen()),
    );
  }

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      builder: (_) => _SettingsSheet(
        allMethods: _allMethods,
        selectedMethodId: _selectedMethodId,
        selectedMadhab: _selectedMadhab,
        onChanged: (methodId, madhab) {
          setState(() {
            _selectedMethodId = methodId;
            _selectedMadhab = madhab;
          });
          _recalculate();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Prayer Times'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            tooltip: 'Zakat Calculator',
            onPressed: _openZakat,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _loadLocation(),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<_PrayerData>(
          future: _prayerData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final data = snapshot.data!;
            return _PrayerTimesBody(
              data: data,
              usingGps: _usingGps,
              methodId: _selectedMethodId,
              madhab: _selectedMadhab,
            );
          },
        ),
      ),
    );
  }
}

class _PrayerData {
  final ipt.SalahTimes times;
  final double lat;
  final double lng;
  _PrayerData({required this.times, required this.lat, required this.lng});
}

class _PrayerTimesBody extends StatelessWidget {
  final _PrayerData data;
  final bool usingGps;
  final String methodId;
  final ipt.Madhab madhab;

  const _PrayerTimesBody({
    required this.data,
    required this.usingGps,
    required this.methodId,
    required this.madhab,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(now);
    final t = data.times;

    final mainPrayers = [
      ('Fajr', t.fajr),
      ('Dhuhr', t.dhuhr),
      ('Asr', t.asr),
      ('Maghrib', t.maghrib),
      ('Isha', t.isha),
    ];

    final sunnahPrayers = [
      ('Tahajjud', t.tahajjud),
      ('Duha', t.duha),
      ('Awwabin', t.awwabin),
      ('Witr', t.witr),
    ];

    // Determine current active prayer
    String? activePrayer;
    for (final (name, range) in mainPrayers) {
      if (now.isAfter(range.start) && now.isBefore(range.end)) {
        activePrayer = name;
        break;
      }
    }

    final cs = Theme.of(context).colorScheme;
    final hijri = t.hijriDate;
    final isRamadan = t.isRamadan;
    final isHajjSeason = t.isHajjSeason;
    final isArafah = t.isArafah;
    final isEidAlAdha = t.isEidAlAdha;
    final fmt = DateFormat('HH:mm');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Date & location card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateStr,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(hijri.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: cs.primary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(usingGps ? Icons.gps_fixed : Icons.location_off,
                        size: 14, color: cs.outline),
                    const SizedBox(width: 4),
                    Text(
                      usingGps
                          ? '${data.lat.toStringAsFixed(3)}, ${data.lng.toStringAsFixed(3)}'
                          : 'Default: Dhaka, Bangladesh',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: cs.outline),
                    ),
                    const SizedBox(width: 12),
                    Text('$methodId | ${madhab.name}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: cs.outline)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Hajj season banner
        if (isHajjSeason) ...[
          Card(
            color: cs.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.mosque, color: cs.onSecondaryContainer, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArafah
                              ? 'Day of Arafah — 9 Dhul Hijjah'
                              : isEidAlAdha
                                  ? 'Eid al-Adha Mubarak — 10 Dhul Hijjah'
                                  : 'Hajj Season — ${hijri.day} Dhul Hijjah',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: cs.onSecondaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (isArafah)
                          Text(
                            'The greatest day of Hajj. Fasting is sunnah for non-pilgrims.',
                            style: TextStyle(
                                color: cs.onSecondaryContainer, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Ramadan banner
        if (isRamadan) ...[
          Card(
            color: cs.tertiaryContainer,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ramadan Mubarak 🌙',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: cs.onTertiaryContainer,
                            fontWeight: FontWeight.bold,
                          )),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _RamadanTimeChip(
                        label: 'Imsak',
                        time: fmt.format(t.imsak),
                        icon: Icons.no_food,
                        color: cs.onTertiaryContainer,
                      ),
                      _RamadanTimeChip(
                        label: 'Suhoor ends',
                        time: fmt.format(t.fajr.start),
                        icon: Icons.restaurant,
                        color: cs.onTertiaryContainer,
                      ),
                      _RamadanTimeChip(
                        label: 'Iftar',
                        time: fmt.format(t.maghrib.start),
                        icon: Icons.wb_sunny,
                        color: cs.onTertiaryContainer,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Main prayers
        Text('Obligatory Prayers',
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        for (final (name, range) in mainPrayers)
          _PrayerCard(
            name: name,
            range: range,
            isActive: name == activePrayer,
            now: now,
          ),

        const SizedBox(height: 12),
        Text('Sunnah Prayers',
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 6),
        for (final (name, range) in sunnahPrayers)
          _PrayerCard(name: name, range: range, isActive: false, now: now),
      ],
    );
  }
}

class _RamadanTimeChip extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color color;

  const _RamadanTimeChip({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(time,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 16)),
        Text(label,
            style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final String name;
  final DateTimeRange range;
  final bool isActive;
  final DateTime now;

  const _PrayerCard({
    required this.name,
    required this.range,
    required this.isActive,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('HH:mm');
    final cs = Theme.of(context).colorScheme;
    final start = fmt.format(range.start);
    final end = fmt.format(range.end);

    String? subtitle;
    if (isActive) {
      final remaining = range.end.difference(now);
      final h = remaining.inHours;
      final m = remaining.inMinutes % 60;
      subtitle = h > 0 ? '${h}h ${m}m remaining' : '${m}m remaining';
    }

    return Card(
      color: isActive ? cs.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? cs.primary : cs.surfaceContainerHighest,
          foregroundColor: isActive ? cs.onPrimary : cs.onSurface,
          child: Text(name[0],
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        title: Text(name,
            style: TextStyle(
                fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: Text(
          '$start – $end',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isActive ? cs.primary : null,
                fontWeight: isActive ? FontWeight.bold : null,
              ),
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatefulWidget {
  final List<ipt.SalahCalculationMethod> allMethods;
  final String selectedMethodId;
  final ipt.Madhab selectedMadhab;
  final void Function(String methodId, ipt.Madhab madhab) onChanged;

  const _SettingsSheet({
    required this.allMethods,
    required this.selectedMethodId,
    required this.selectedMadhab,
    required this.onChanged,
  });

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late String _methodId;
  late ipt.Madhab _madhab;

  @override
  void initState() {
    super.initState();
    _methodId = widget.selectedMethodId;
    _madhab = widget.selectedMadhab;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text('Calculation Method',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _methodId,
            isExpanded: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: widget.allMethods
                .map((m) => DropdownMenuItem(
                      value: m.id,
                      child: Text(m.method, overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _methodId = v);
            },
          ),
          const SizedBox(height: 16),
          Text('Asr Calculation (Madhab)',
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<ipt.Madhab>(
            segments: const [
              ButtonSegment(
                  value: ipt.Madhab.shafi,
                  label: Text('Shafi / Maliki / Hanbali')),
              ButtonSegment(
                  value: ipt.Madhab.hanafi, label: Text('Hanafi')),
            ],
            selected: {_madhab},
            onSelectionChanged: (s) => setState(() => _madhab = s.first),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                widget.onChanged(_methodId, _madhab);
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Zakat Calculator Screen ───────────────────────────────────────────────────

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _cashCtrl = TextEditingController();
  final _goldValueCtrl = TextEditingController();
  final _silverValueCtrl = TextEditingController();
  final _investmentsCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();

  ipt.NisabStandard _nisabStandard = ipt.NisabStandard.gold;
  ipt.ZakatResult? _result;

  double _parse(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '')) ?? 0;

  void _calculate() {
    final calc = ipt.ZakatCalculator(
      goldPricePerGram: _parse(_goldCtrl),
      silverPricePerGram: _parse(_silverCtrl),
      nisabStandard: _nisabStandard,
      cash: _parse(_cashCtrl),
      goldValue: _parse(_goldValueCtrl),
      silverValue: _parse(_silverValueCtrl),
      investments: _parse(_investmentsCtrl),
      debts: _parse(_debtsCtrl),
    );
    setState(() => _result = calc.calculate());
  }

  @override
  void dispose() {
    for (final c in [_goldCtrl, _silverCtrl, _cashCtrl, _goldValueCtrl,
        _silverValueCtrl, _investmentsCtrl, _debtsCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _field(String label, TextEditingController ctrl, {String hint = '0'}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final result = _result;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Zakat Calculator'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Enter current market prices and your assets.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.outline)),
            const SizedBox(height: 16),

            Text('Nisab Standard',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<ipt.NisabStandard>(
              segments: const [
                ButtonSegment(
                  value: ipt.NisabStandard.gold,
                  label: Text('Gold (85 g)'),
                  icon: Icon(Icons.circle, size: 12),
                ),
                ButtonSegment(
                  value: ipt.NisabStandard.silver,
                  label: Text('Silver (595 g)'),
                  icon: Icon(Icons.circle_outlined, size: 12),
                ),
              ],
              selected: {_nisabStandard},
              onSelectionChanged: (s) =>
                  setState(() => _nisabStandard = s.first),
            ),

            const Divider(height: 24),
            Text('Spot Prices (per gram)',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            _field('Gold price / gram (your currency)', _goldCtrl),
            _field('Silver price / gram (your currency)', _silverCtrl),

            const Divider(height: 24),
            Text('Your Assets',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            _field('Cash & savings', _cashCtrl),
            _field('Gold jewellery / bars (market value)', _goldValueCtrl),
            _field('Silver jewellery / bars (market value)', _silverValueCtrl),
            _field('Investments & stocks (market value)', _investmentsCtrl),

            const Divider(height: 24),
            Text('Deductions',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            _field('Debts due within the year', _debtsCtrl),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _calculate,
                child: const Text('Calculate Zakat'),
              ),
            ),

            if (result != null) ...[
              const SizedBox(height: 20),
              Card(
                color: result.isZakatDue
                    ? cs.primaryContainer
                    : cs.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.isZakatDue ? 'Zakat is Due' : 'No Zakat Due',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: result.isZakatDue
                                      ? cs.onPrimaryContainer
                                      : cs.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      _ResultRow('Gross wealth',
                          result.grossWealth.toStringAsFixed(2), cs),
                      _ResultRow('Debts deducted',
                          (result.grossWealth - result.netWealth)
                              .toStringAsFixed(2),
                          cs),
                      _ResultRow('Net zakatable wealth',
                          result.netWealth.toStringAsFixed(2), cs,
                          bold: true),
                      const Divider(height: 16),
                      _ResultRow(
                        'Nisab threshold (${result.nisabStandard == ipt.NisabStandard.gold ? 'gold' : 'silver'})',
                        result.applicableNisab.toStringAsFixed(2),
                        cs,
                      ),
                      const Divider(height: 16),
                      _ResultRow(
                        'Zakat payable (2.5%)',
                        result.zakatDue.toStringAsFixed(2),
                        cs,
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme cs;
  final bool bold;

  const _ResultRow(this.label, this.value, this.cs, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
