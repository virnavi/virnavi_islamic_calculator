// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'virnavi_islamic_calculator.dart';

// **************************************************************************
// McpSummaryGenerator
// **************************************************************************

// ignore: camel_case_types
class $IslamicCalculatorSummaryMcpSummary {
  static const McpSummary summary = McpSummary(
    id: 'virnavi_islamic_calculator',
    toolNames: {
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_salah_times',
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/to_hijri_date',
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/calculate_zakat',
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_calculation_method',
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_country_config',
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_all_calculation_methods',
      'packages/virnavi_islamic_calculator/mcp/islamic_calculator/get_config',
    },
    modelIds: {
      'virnavi_islamic_calculator/HijriDate',
      'virnavi_islamic_calculator/Adjustments',
      'virnavi_islamic_calculator/CountryConfig',
      'virnavi_islamic_calculator/ConfigAsrMethod',
      'virnavi_islamic_calculator/ConfigLatitude',
      'virnavi_islamic_calculator/ConfigMethod',
      'virnavi_islamic_calculator/HighLatitudeRuleModel',
      'virnavi_islamic_calculator/CountryInfo',
      'virnavi_islamic_calculator/SalahCalculationMethod',
      'virnavi_islamic_calculator/SalahTimeConfig',
      'virnavi_islamic_calculator/SalahTimes',
      'virnavi_islamic_calculator/ZakatCalculator',
      'virnavi_islamic_calculator/ZakatResult',
    },
    viewModelIds: {},
  );

  static McpSummary bindAll(List<ToolDefinition> tools) => summary.bind(
    tools,
    models: [
      $HijriDateMcpX.definition,
      $AdjustmentsMcpX.definition,
      $CountryConfigMcpX.definition,
      $ConfigAsrMethodMcpX.definition,
      $ConfigLatitudeMcpX.definition,
      $ConfigMethodMcpX.definition,
      $HighLatitudeRuleModelMcpX.definition,
      $CountryInfoMcpX.definition,
      $SalahCalculationMethodMcpX.definition,
      $SalahTimeConfigMcpX.definition,
      $SalahTimesMcpX.definition,
      $ZakatCalculatorMcpX.definition,
      $ZakatResultMcpX.definition,
    ],
  );

  static McpSummary bindWithViews(List<ToolDefinition> tools) =>
      bindAll(tools).bindViews([]);
}
