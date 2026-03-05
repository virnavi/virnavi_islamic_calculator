/// Which standard to use for the Nisab threshold.
enum NisabStandard {
  /// Use 85 grams of gold as the nisab threshold (most common contemporary view).
  gold,

  /// Use 595 grams of silver as the nisab threshold (lower threshold, more conservative).
  silver,
}

/// Zakat calculator for Islamic obligatory almsgiving.
///
/// Zakat is due on wealth held above the nisab threshold for one full
/// lunar year (hawl). The standard zakat rate is 2.5% of total zakatable assets.
///
/// **Nisab** is the minimum threshold of wealth, defined as the equivalent of
/// either 85 grams of gold or 595 grams of silver.
class ZakatCalculator {
  /// Standard nisab in grams of gold.
  static const double nisabGoldGrams = 85.0;

  /// Standard nisab in grams of silver.
  static const double nisabSilverGrams = 595.0;

  /// Obligatory zakat rate (2.5%).
  static const double zakatRate = 0.025;

  /// Which nisab standard to apply when determining if zakat is due.
  final NisabStandard nisabStandard;

  /// Current gold spot price per gram in your local currency.
  final double goldPricePerGram;

  /// Current silver spot price per gram in your local currency.
  final double silverPricePerGram;

  /// Cash and bank savings.
  final double cash;

  /// Market value of gold jewellery / bars owned.
  final double goldValue;

  /// Market value of silver jewellery / bars owned.
  final double silverValue;

  /// Value of business inventory at market price.
  final double businessInventory;

  /// Value of receivables (money owed to you that you expect to receive).
  final double receivables;

  /// Value of stocks / investment funds (use current market value).
  final double investments;

  /// Rental income savings earmarked for personal use.
  final double rentalIncome;

  /// Outstanding debts that are due within the next lunar year (deductible).
  final double debts;

  ZakatCalculator({
    required this.goldPricePerGram,
    required this.silverPricePerGram,
    this.nisabStandard = NisabStandard.gold,
    this.cash = 0,
    this.goldValue = 0,
    this.silverValue = 0,
    this.businessInventory = 0,
    this.receivables = 0,
    this.investments = 0,
    this.rentalIncome = 0,
    this.debts = 0,
  });

  /// Nisab threshold using gold (85 g × gold spot price).
  double get nisabByGold => nisabGoldGrams * goldPricePerGram;

  /// Nisab threshold using silver (595 g × silver spot price).
  double get nisabBySilver => nisabSilverGrams * silverPricePerGram;

  /// The applicable nisab threshold based on [nisabStandard].
  double get applicableNisab =>
      nisabStandard == NisabStandard.gold ? nisabByGold : nisabBySilver;

  /// Total zakatable wealth before subtracting debts.
  double get grossWealth =>
      cash +
      goldValue +
      silverValue +
      businessInventory +
      receivables +
      investments +
      rentalIncome;

  /// Net zakatable wealth after deducting debts due within the year.
  double get netWealth => grossWealth - debts;

  /// Whether the person's net wealth meets or exceeds the nisab (gold standard).
  bool get meetsNisabByGold => netWealth >= nisabByGold;

  /// Whether the person's net wealth meets or exceeds the nisab (silver standard).
  bool get meetsNisabBySilver => netWealth >= nisabBySilver;

  /// Whether zakat is obligatory using the selected [nisabStandard].
  bool get isZakatDue => nisabStandard == NisabStandard.gold
      ? meetsNisabByGold
      : meetsNisabBySilver;

  /// Zakat amount due (2.5% of net zakatable wealth), or 0 if below nisab.
  double get zakatDue => isZakatDue ? netWealth * zakatRate : 0.0;

  /// Zakat result as a structured summary.
  ZakatResult calculate() {
    return ZakatResult(
      nisabStandard: nisabStandard,
      grossWealth: grossWealth,
      netWealth: netWealth,
      nisabByGold: nisabByGold,
      nisabBySilver: nisabBySilver,
      applicableNisab: applicableNisab,
      isZakatDue: isZakatDue,
      zakatDue: zakatDue,
    );
  }
}

/// The result of a zakat calculation.
class ZakatResult {
  /// The nisab standard used for this calculation.
  final NisabStandard nisabStandard;

  /// Total zakatable assets before deducting debts.
  final double grossWealth;

  /// Net zakatable wealth after deducting debts.
  final double netWealth;

  /// Nisab threshold using 85 g of gold.
  final double nisabByGold;

  /// Nisab threshold using 595 g of silver.
  final double nisabBySilver;

  /// The nisab threshold that was applied (gold or silver depending on [nisabStandard]).
  final double applicableNisab;

  /// Whether zakat is obligatory based on the selected nisab standard.
  final bool isZakatDue;

  /// Amount of zakat payable (0 if not due).
  final double zakatDue;

  const ZakatResult({
    required this.nisabStandard,
    required this.grossWealth,
    required this.netWealth,
    required this.nisabByGold,
    required this.nisabBySilver,
    required this.applicableNisab,
    required this.isZakatDue,
    required this.zakatDue,
  });

  @override
  String toString() =>
      'ZakatResult(netWealth: $netWealth, nisabStandard: $nisabStandard, isZakatDue: $isZakatDue, zakatDue: $zakatDue)';
}
