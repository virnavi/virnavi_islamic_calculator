// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'salah_times.dart';

// **************************************************************************
// McpModelGenerator
// **************************************************************************

ObjectSchema _$DateTimeRangeSchema() {
  return ObjectSchema(
    properties: {'start': IntegerSchema(), 'end': IntegerSchema()},
    required: ['start', 'end'],
  );
}

ObjectSchema _$SalahTimesToMcpSchema() {
  return ObjectSchema(
    properties: {
      'fajr': _$DateTimeRangeSchema(),
      'dhuhr': _$DateTimeRangeSchema(),
      'asr': _$DateTimeRangeSchema(),
      'maghrib': _$DateTimeRangeSchema(),
      'isha': _$DateTimeRangeSchema(),
      'witr': _$DateTimeRangeSchema(),
      'duha': _$DateTimeRangeSchema(),
      'awwabin': _$DateTimeRangeSchema(),
      'tahajjud': _$DateTimeRangeSchema(),
    },
    required: [
      'fajr',
      'dhuhr',
      'asr',
      'maghrib',
      'isha',
      'witr',
      'duha',
      'awwabin',
      'tahajjud',
    ],
  );
}

// ignore: camel_case_types
class $SalahTimesMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/SalahTimes';
  static ObjectSchema schema() => _$SalahTimesToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $SalahTimesMcpX.schema,
    fromJson: SalahTimes.fromJson,
  );
}
