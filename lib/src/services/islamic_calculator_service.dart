import 'package:virnavi_ai_agent_mcp/virnavi_ai_agent_mcp.dart';

import '../helper/hijri_helper.dart';
import '../salah/enums/enums.dart';
import '../salah/models/config/models.dart';
import '../salah/models/salah_times.dart';
import '../zakat/zakat_calculator.dart';

part 'islamic_calculator_service.mcp.dart';

/// A unified service class for all virnavi_islamic_calculator functionalities.
///
/// Provides a single entry point for:
/// - Salah (prayer) time calculation
/// - Hijri (Islamic) calendar conversion
/// - Zakat (almsgiving) calculation
/// - Calculation method and country config lookup
@McpService(path: 'islamic_calculator')
class IslamicCalculatorService {
  const IslamicCalculatorService();

  // ── Salah Times ────────────────────────────────────────────────────────────

  /// Calculates salah times for a given date, location, and calculation method.
  ///
  /// Optionally pass a [madhab] to override the method default for Asr timing.
  @McpTool(
    path: 'get_salah_times',
    description:
        'Calculates salah (prayer) times for a given date, latitude, longitude, and calculation method.',
  )
  Future<SalahTimes> getSalahTimes({
    @McpParam(description: 'The date to calculate prayer times for, as milliseconds since epoch UTC.')
    required DateTime date,
    @McpParam(description: 'Latitude of the location in decimal degrees.')
    required double latitude,
    @McpParam(description: 'Longitude of the location in decimal degrees.')
    required double longitude,
    @McpParam(description: 'The salah calculation method to use.')
    required SalahCalculationMethod method,
    @McpParam(description: 'Madhab override for Asr timing. Defaults to the method default if not specified.')
    Madhab? madhab,
  }) {
    return SalahTimes.calculate(
      date: date,
      latitude: latitude,
      longitude: longitude,
      method: method,
      madhab: madhab,
    );
  }

  // ── Hijri Calendar ─────────────────────────────────────────────────────────

  /// Converts a Gregorian date to the corresponding Hijri (Islamic) date.
  @McpTool(
    path: 'to_hijri_date',
    description: 'Converts a Gregorian date to the corresponding Hijri (Islamic) calendar date.',
  )
  HijriDate toHijriDate(
    @McpParam(description: 'The Gregorian date to convert, as milliseconds since epoch UTC.') DateTime date,
  ) =>
      HijriDate.fromGregorian(date);

  /// Returns the Hijri date for today.
  HijriDate get todayHijri => HijriDate.fromGregorian(DateTime.now());

  // ── Zakat ──────────────────────────────────────────────────────────────────

  /// Calculates zakat and returns a [ZakatResult].
  ///
  /// [goldPricePerGram] and [silverPricePerGram] must be in your local
  /// currency. All asset values should be in the same currency.
  @McpTool(
    path: 'calculate_zakat',
    description:
        'Calculates the obligatory zakat amount based on wealth, nisab threshold, and the 2.5% rate.',
  )
  ZakatResult calculateZakat({
    @McpParam(description: 'Current gold spot price per gram in local currency.')
    required double goldPricePerGram,
    @McpParam(description: 'Current silver spot price per gram in local currency.')
    required double silverPricePerGram,
    @McpParam(description: 'Nisab standard to use: gold (85 g) or silver (595 g).')
    NisabStandard nisabStandard = NisabStandard.gold,
    @McpParam(description: 'Cash and bank savings.') double cash = 0,
    @McpParam(description: 'Market value of gold owned.') double goldValue = 0,
    @McpParam(description: 'Market value of silver owned.') double silverValue = 0,
    @McpParam(description: 'Value of business inventory at market price.')
    double businessInventory = 0,
    @McpParam(description: 'Value of receivables expected to be received.')
    double receivables = 0,
    @McpParam(description: 'Value of stocks and investment funds.') double investments = 0,
    @McpParam(description: 'Rental income savings earmarked for personal use.')
    double rentalIncome = 0,
    @McpParam(description: 'Outstanding debts due within the next lunar year (deductible).')
    double debts = 0,
  }) {
    return ZakatCalculator(
      goldPricePerGram: goldPricePerGram,
      silverPricePerGram: silverPricePerGram,
      nisabStandard: nisabStandard,
      cash: cash,
      goldValue: goldValue,
      silverValue: silverValue,
      businessInventory: businessInventory,
      receivables: receivables,
      investments: investments,
      rentalIncome: rentalIncome,
      debts: debts,
    ).calculate();
  }

  // ── Configuration Lookup ───────────────────────────────────────────────────

  /// Returns the [SalahCalculationMethod] for the given method ID.
  @McpTool(
    path: 'get_calculation_method',
    description: 'Returns the salah calculation method configuration for the given method ID.',
  )
  Future<SalahCalculationMethod> getCalculationMethod(
    @McpParam(description: 'The calculation method ID (e.g. "MWL", "ISNA", "Egypt").')
    String methodId,
  ) {
    return SalahCalculationMethod.getCalculationMethod(methodId);
  }

  /// Returns the [CountryConfig] for the given ISO country code.
  @McpTool(
    path: 'get_country_config',
    description:
        'Returns the recommended salah calculation configuration for a given ISO country code (e.g. "BD", "SA", "US").',
  )
  Future<CountryConfig> getCountryConfig(
    @McpParam(description: 'ISO 3166-1 alpha-2 country code (e.g. "BD", "SA", "US").')
    String countryCode,
  ) {
    return CountryConfig.getByCountryCode(countryCode);
  }

  /// Returns all available [SalahCalculationMethod]s from the bundled config.
  @McpTool(
    path: 'get_all_calculation_methods',
    description: 'Returns all available salah calculation methods from the bundled configuration.',
  )
  Future<List<SalahCalculationMethod>> getAllCalculationMethods() async {
    final config = await SalahTimeConfig.get();
    return config.methods;
  }

  /// Returns the full bundled [SalahTimeConfig].
  @McpTool(
    path: 'get_config',
    description: 'Returns the full bundled salah time configuration including all methods and country configs.',
  )
  Future<SalahTimeConfig> getConfig() => SalahTimeConfig.get();
}
