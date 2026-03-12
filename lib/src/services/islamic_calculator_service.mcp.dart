// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'islamic_calculator_service.dart';

// **************************************************************************
// McpServiceGenerator
// **************************************************************************

extension IslamicCalculatorServiceMcpExtension on IslamicCalculatorService {
  List<ToolDefinition> get mcpTools => [
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_salah_times',
      description:
          'Calculates salah (prayer) times for a given date, latitude, longitude, and calculation method.',
      inputSchema: ObjectSchema(
        properties: {
          'date': IntegerSchema(
            description:
                'The date to calculate prayer times for, as milliseconds since epoch UTC.',
          ),
          'latitude': NumberSchema(
            description: 'Latitude of the location in decimal degrees.',
          ),
          'longitude': NumberSchema(
            description: 'Longitude of the location in decimal degrees.',
          ),
          'method': $SalahCalculationMethodMcpX.schema(),
          'madhab': StringSchema(
            description:
                'Madhab override for Asr timing. Defaults to the method default if not specified.',
            enumValues: ['hanafi', 'shafi', 'jafari'],
          ),
        },
        required: ['date', 'latitude', 'longitude', 'method'],
      ),
      resultModelId: 'virnavi_islamic_calculator/SalahTimes',
      handler: (args) async {
        final result = await getSalahTimes(
          date: DateTime.fromMillisecondsSinceEpoch(
            args['date'] as int,
            isUtc: true,
          ),
          latitude: args['latitude'] as double,
          longitude: args['longitude'] as double,
          method: args['method'] as SalahCalculationMethod,
          madhab: (args['madhab'] == null
              ? null
              : const {
                  'hanafi': Madhab.hanafi,
                  'shafi': Madhab.shafi,
                  'jafari': Madhab.jafari,
                }[args['madhab'] as String]!),
        );
        return ToolResult.success(result.toJson());
      },
    ),
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/to_hijri_date',
      description:
          'Converts a Gregorian date to the corresponding Hijri (Islamic) calendar date.',
      inputSchema: ObjectSchema(
        properties: {
          'date': IntegerSchema(
            description:
                'The Gregorian date to convert, as milliseconds since epoch UTC.',
          ),
        },
        required: ['date'],
      ),
      resultModelId: 'virnavi_islamic_calculator/HijriDate',
      handler: (args) async {
        final result = toHijriDate(
          DateTime.fromMillisecondsSinceEpoch(args['date'] as int, isUtc: true),
        );
        return ToolResult.success(result.toJson());
      },
    ),
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/calculate_zakat',
      description:
          'Calculates the obligatory zakat amount based on wealth, nisab threshold, and the 2.5% rate.',
      inputSchema: ObjectSchema(
        properties: {
          'goldPricePerGram': NumberSchema(
            description: 'Current gold spot price per gram in local currency.',
          ),
          'silverPricePerGram': NumberSchema(
            description:
                'Current silver spot price per gram in local currency.',
          ),
          'nisabStandard': StringSchema(
            description:
                'Nisab standard to use: gold (85 g) or silver (595 g).',
            enumValues: ['gold', 'silver'],
          ),
          'cash': NumberSchema(description: 'Cash and bank savings.'),
          'goldValue': NumberSchema(description: 'Market value of gold owned.'),
          'silverValue': NumberSchema(
            description: 'Market value of silver owned.',
          ),
          'businessInventory': NumberSchema(
            description: 'Value of business inventory at market price.',
          ),
          'receivables': NumberSchema(
            description: 'Value of receivables expected to be received.',
          ),
          'investments': NumberSchema(
            description: 'Value of stocks and investment funds.',
          ),
          'rentalIncome': NumberSchema(
            description: 'Rental income savings earmarked for personal use.',
          ),
          'debts': NumberSchema(
            description:
                'Outstanding debts due within the next lunar year (deductible).',
          ),
        },
        required: ['goldPricePerGram', 'silverPricePerGram'],
      ),
      resultModelId: 'virnavi_islamic_calculator/ZakatResult',
      handler: (args) async {
        final result = calculateZakat(
          goldPricePerGram: args['goldPricePerGram'] as double,
          silverPricePerGram: args['silverPricePerGram'] as double,
          nisabStandard: const {
            'gold': NisabStandard.gold,
            'silver': NisabStandard.silver,
          }[args['nisabStandard'] as String]!,
          cash: args['cash'] as double,
          goldValue: args['goldValue'] as double,
          silverValue: args['silverValue'] as double,
          businessInventory: args['businessInventory'] as double,
          receivables: args['receivables'] as double,
          investments: args['investments'] as double,
          rentalIncome: args['rentalIncome'] as double,
          debts: args['debts'] as double,
        );
        return ToolResult.success(result.toJson());
      },
    ),
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_calculation_method',
      description:
          'Returns the salah calculation method configuration for the given method ID.',
      inputSchema: ObjectSchema(
        properties: {
          'methodId': StringSchema(
            description:
                'The calculation method ID (e.g. "MWL", "ISNA", "Egypt").',
          ),
        },
        required: ['methodId'],
      ),
      resultModelId: 'virnavi_islamic_calculator/SalahCalculationMethod',
      handler: (args) async {
        final result = await getCalculationMethod(args['methodId'] as String);
        return ToolResult.success(result.toJson());
      },
    ),
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_country_config',
      description:
          'Returns the recommended salah calculation configuration for a given ISO country code (e.g. "BD", "SA", "US").',
      inputSchema: ObjectSchema(
        properties: {
          'countryCode': StringSchema(
            description:
                'ISO 3166-1 alpha-2 country code (e.g. "BD", "SA", "US").',
          ),
        },
        required: ['countryCode'],
      ),
      resultModelId: 'virnavi_islamic_calculator/CountryConfig',
      handler: (args) async {
        final result = await getCountryConfig(args['countryCode'] as String);
        return ToolResult.success(result.toJson());
      },
    ),
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_all_calculation_methods',
      description:
          'Returns all available salah calculation methods from the bundled configuration.',
      inputSchema: ObjectSchema(),
      handler: (args) async {
        final result = await getAllCalculationMethods();
        return ToolResult.success(result.map((e) => e.toJson()).toList());
      },
    ),
    ToolDefinition(
      name:
          'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_config',
      description:
          'Returns the full bundled salah time configuration including all methods and country configs.',
      inputSchema: ObjectSchema(),
      resultModelId: 'virnavi_islamic_calculator/SalahTimeConfig',
      handler: (args) async {
        final result = await getConfig();
        return ToolResult.success(result.toJson());
      },
    ),
  ];
}
