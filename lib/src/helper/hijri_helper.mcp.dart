// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'hijri_helper.dart';

// **************************************************************************
// McpModelGenerator
// **************************************************************************

ObjectSchema _$HijriDateToMcpSchema() {
  return ObjectSchema(
    properties: {
      'year': IntegerSchema(),
      'month': IntegerSchema(),
      'day': IntegerSchema(),
    },
    required: ['year', 'month', 'day'],
  );
}

// ignore: camel_case_types
class $HijriDateMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/HijriDate';
  static ObjectSchema schema() => _$HijriDateToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $HijriDateMcpX.schema,
    fromJson: HijriDate.fromJson,
  );
}
