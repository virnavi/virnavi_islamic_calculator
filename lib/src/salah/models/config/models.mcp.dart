// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'models.dart';

// **************************************************************************
// McpModelGenerator
// **************************************************************************

ObjectSchema _$AdjustmentsToMcpSchema() {
  return ObjectSchema(
    properties: {
      'fajr': IntegerSchema(),
      'sunrise': IntegerSchema(),
      'dhuhr': IntegerSchema(),
      'asr': IntegerSchema(),
      'maghrib': IntegerSchema(),
      'isha': IntegerSchema(),
    },
    required: ['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'],
  );
}

// ignore: camel_case_types
class $AdjustmentsMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/Adjustments';
  static ObjectSchema schema() => _$AdjustmentsToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $AdjustmentsMcpX.schema,
    fromJson: Adjustments.fromJson,
  );
}

ObjectSchema _$CountryConfigToMcpSchema() {
  return ObjectSchema(
    properties: {
      'ids': ArraySchema(items: $CountryInfoMcpX.schema()),
      'method': $ConfigMethodMcpX.schema(),
      'latitude': $ConfigLatitudeMcpX.schema(),
      'asrMethod': $ConfigAsrMethodMcpX.schema(),
    },
    required: ['ids', 'method', 'latitude', 'asrMethod'],
  );
}

// ignore: camel_case_types
class $CountryConfigMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/CountryConfig';
  static ObjectSchema schema() => _$CountryConfigToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $CountryConfigMcpX.schema,
    fromJson: CountryConfig.fromJson,
    nestedDefinitions: [
      $CountryInfoMcpX.definition,
      $ConfigMethodMcpX.definition,
      $ConfigLatitudeMcpX.definition,
      $ConfigAsrMethodMcpX.definition,
    ],
    nestedExtractors: {
      $ConfigMethodMcpX.mcpModelId: (json) =>
          (json['method'] as Map?)?.cast<String, dynamic>(),
      $ConfigLatitudeMcpX.mcpModelId: (json) =>
          (json['latitude'] as Map?)?.cast<String, dynamic>(),
      $ConfigAsrMethodMcpX.mcpModelId: (json) =>
          (json['asrMethod'] as Map?)?.cast<String, dynamic>(),
    },
  );
}

ObjectSchema _$ConfigAsrMethodToMcpSchema() {
  return ObjectSchema(
    properties: {
      'default': StringSchema(enumValues: ['hanafi', 'shafi', 'jafari']),
      'options': ArraySchema(
        items: StringSchema(enumValues: ['hanafi', 'shafi', 'jafari']),
      ),
    },
    required: ['default', 'options'],
  );
}

// ignore: camel_case_types
class $ConfigAsrMethodMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/ConfigAsrMethod';
  static ObjectSchema schema() => _$ConfigAsrMethodToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $ConfigAsrMethodMcpX.schema,
    fromJson: ConfigAsrMethod.fromJson,
  );
}

ObjectSchema _$ConfigLatitudeToMcpSchema() {
  return ObjectSchema(
    properties: {
      'default': StringSchema(),
      'options': ArraySchema(items: StringSchema()),
    },
    required: ['default', 'options'],
  );
}

// ignore: camel_case_types
class $ConfigLatitudeMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/ConfigLatitude';
  static ObjectSchema schema() => _$ConfigLatitudeToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $ConfigLatitudeMcpX.schema,
    fromJson: ConfigLatitude.fromJson,
  );
}

ObjectSchema _$ConfigMethodToMcpSchema() {
  return ObjectSchema(
    properties: {
      'default': StringSchema(),
      'options': ArraySchema(items: StringSchema()),
    },
    required: ['default', 'options'],
  );
}

// ignore: camel_case_types
class $ConfigMethodMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/ConfigMethod';
  static ObjectSchema schema() => _$ConfigMethodToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $ConfigMethodMcpX.schema,
    fromJson: ConfigMethod.fromJson,
  );
}

ObjectSchema _$HighLatitudeRuleModelToMcpSchema() {
  return ObjectSchema(
    properties: {'id': StringSchema(), 'name': StringSchema()},
    required: ['id', 'name'],
  );
}

// ignore: camel_case_types
class $HighLatitudeRuleModelMcpX {
  static const String mcpModelId =
      'virnavi_islamic_calculator/HighLatitudeRuleModel';
  static ObjectSchema schema() => _$HighLatitudeRuleModelToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $HighLatitudeRuleModelMcpX.schema,
    fromJson: HighLatitudeRuleModel.fromJson,
  );
}

ObjectSchema _$CountryInfoToMcpSchema() {
  return ObjectSchema(properties: {'id': StringSchema()}, required: ['id']);
}

// ignore: camel_case_types
class $CountryInfoMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/CountryInfo';
  static ObjectSchema schema() => _$CountryInfoToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $CountryInfoMcpX.schema,
    fromJson: CountryInfo.fromJson,
  );
}

ObjectSchema _$SalahCalculationMethodToMcpSchema() {
  return ObjectSchema(
    properties: {
      'id': StringSchema(),
      'method': StringSchema(),
      'customized': BooleanSchema(),
      'fajrAngle': NumberSchema(),
      'ishaAngle': NumberSchema(),
      'ishaInterval': IntegerSchema(),
      'maghribAngle': NumberSchema(),
      'madhab': StringSchema(enumValues: ['hanafi', 'shafi', 'jafari']),
      'highLatitudeRule': StringSchema(
        enumValues: ['none', 'middleOfTheNight', 'oneSeventh', 'angleBased'],
      ),
      'adjustments': $AdjustmentsMcpX.schema(),
      'methodAdjustments': $AdjustmentsMcpX.schema(),
    },
    required: [
      'id',
      'method',
      'customized',
      'fajrAngle',
      'ishaInterval',
      'madhab',
      'highLatitudeRule',
      'adjustments',
      'methodAdjustments',
    ],
  );
}

// ignore: camel_case_types
class $SalahCalculationMethodMcpX {
  static const String mcpModelId =
      'virnavi_islamic_calculator/SalahCalculationMethod';
  static ObjectSchema schema() => _$SalahCalculationMethodToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $SalahCalculationMethodMcpX.schema,
    fromJson: SalahCalculationMethod.fromJson,
    nestedDefinitions: [$AdjustmentsMcpX.definition],
    nestedExtractors: {
      $AdjustmentsMcpX.mcpModelId: (json) =>
          (json['adjustments'] as Map?)?.cast<String, dynamic>(),
    },
  );
}

ObjectSchema _$SalahTimeConfigToMcpSchema() {
  return ObjectSchema(
    properties: {
      'madhabs': ArraySchema(
        items: StringSchema(enumValues: ['hanafi', 'shafi', 'jafari']),
      ),
      'highLatitudeRules': ArraySchema(
        items: StringSchema(
          enumValues: ['none', 'middleOfTheNight', 'oneSeventh', 'angleBased'],
        ),
      ),
      'methods': ArraySchema(items: $SalahCalculationMethodMcpX.schema()),
      'config': ArraySchema(items: $CountryConfigMcpX.schema()),
    },
    required: ['madhabs', 'highLatitudeRules', 'methods', 'config'],
  );
}

// ignore: camel_case_types
class $SalahTimeConfigMcpX {
  static const String mcpModelId = 'virnavi_islamic_calculator/SalahTimeConfig';
  static ObjectSchema schema() => _$SalahTimeConfigToMcpSchema();
  static McpModelDefinition get definition => McpModelDefinition(
    id: mcpModelId,
    schemaFactory: $SalahTimeConfigMcpX.schema,
    fromJson: SalahTimeConfig.fromJson,
    nestedDefinitions: [
      $SalahCalculationMethodMcpX.definition,
      $CountryConfigMcpX.definition,
    ],
  );
}
