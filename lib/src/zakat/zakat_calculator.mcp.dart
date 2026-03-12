// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'zakat_calculator.dart';

// **************************************************************************
// McpModelGenerator
// **************************************************************************

ObjectSchema _$ZakatCalculatorToMcpSchema() {
  return ObjectSchema(
    properties: {
      'nisabStandard': StringSchema(enumValues: ['gold', 'silver']),
      'goldPricePerGram': NumberSchema(),
      'silverPricePerGram': NumberSchema(),
      'cash': NumberSchema(),
      'goldValue': NumberSchema(),
      'silverValue': NumberSchema(),
      'businessInventory': NumberSchema(),
      'receivables': NumberSchema(),
      'investments': NumberSchema(),
      'rentalIncome': NumberSchema(),
      'debts': NumberSchema(),
    },
    required: [
      'nisabStandard',
      'goldPricePerGram',
      'silverPricePerGram',
      'cash',
      'goldValue',
      'silverValue',
      'businessInventory',
      'receivables',
      'investments',
      'rentalIncome',
      'debts',
    ],
  );
}

// ignore: camel_case_types
class $ZakatCalculatorMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/ZakatCalculator';
  static ObjectSchema schema() => _$ZakatCalculatorToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $ZakatCalculatorMcpX.schema,
    fromJson: ZakatCalculator.fromJson,
  );
}

ObjectSchema _$ZakatResultToMcpSchema() {
  return ObjectSchema(
    properties: {
      'nisabStandard': StringSchema(enumValues: ['gold', 'silver']),
      'grossWealth': NumberSchema(),
      'netWealth': NumberSchema(),
      'nisabByGold': NumberSchema(),
      'nisabBySilver': NumberSchema(),
      'applicableNisab': NumberSchema(),
      'isZakatDue': BooleanSchema(),
      'zakatDue': NumberSchema(),
    },
    required: [
      'nisabStandard',
      'grossWealth',
      'netWealth',
      'nisabByGold',
      'nisabBySilver',
      'applicableNisab',
      'isZakatDue',
      'zakatDue',
    ],
  );
}

// ignore: camel_case_types
class $ZakatResultMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/ZakatResult';
  static ObjectSchema schema() => _$ZakatResultToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $ZakatResultMcpX.schema,
    fromJson: ZakatResult.fromJson,
  );
}
