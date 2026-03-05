// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Adjustments _$AdjustmentsFromJson(Map<String, dynamic> json) => Adjustments(
      fajr: (json['fajr'] as num?)?.toInt() ?? 0,
      sunrise: (json['sunrise'] as num?)?.toInt() ?? 0,
      dhuhr: (json['dhuhr'] as num?)?.toInt() ?? 0,
      asr: (json['asr'] as num?)?.toInt() ?? 0,
      maghrib: (json['maghrib'] as num?)?.toInt() ?? 0,
      isha: (json['isha'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AdjustmentsToJson(Adjustments instance) =>
    <String, dynamic>{
      'fajr': instance.fajr,
      'sunrise': instance.sunrise,
      'dhuhr': instance.dhuhr,
      'asr': instance.asr,
      'maghrib': instance.maghrib,
      'isha': instance.isha,
    };

CountryConfig _$CountryConfigFromJson(Map<String, dynamic> json) =>
    CountryConfig(
      ids: (json['ids'] as List<dynamic>)
          .map((e) => CountryInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      method: ConfigMethod.fromJson(json['method'] as Map<String, dynamic>),
      latitude:
          ConfigLatitude.fromJson(json['latitude'] as Map<String, dynamic>),
      asrMethod:
          ConfigAsrMethod.fromJson(json['asrMethod'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CountryConfigToJson(CountryConfig instance) =>
    <String, dynamic>{
      'ids': instance.ids,
      'method': instance.method,
      'latitude': instance.latitude,
      'asrMethod': instance.asrMethod,
    };

ConfigAsrMethod _$ConfigAsrMethodFromJson(Map<String, dynamic> json) =>
    ConfigAsrMethod(
      defaultValue: $enumDecode(_$MadhabEnumMap, json['default']),
      options: (json['options'] as List<dynamic>)
          .map((e) => $enumDecode(_$MadhabEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$ConfigAsrMethodToJson(ConfigAsrMethod instance) =>
    <String, dynamic>{
      'default': _$MadhabEnumMap[instance.defaultValue]!,
      'options': instance.options.map((e) => _$MadhabEnumMap[e]!).toList(),
    };

const _$MadhabEnumMap = {
  Madhab.hanafi: 'hanafi',
  Madhab.shafi: 'shafi',
  Madhab.jafari: 'jafari',
};

ConfigLatitude _$ConfigLatitudeFromJson(Map<String, dynamic> json) =>
    ConfigLatitude(
      defaultValue: json['default'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ConfigLatitudeToJson(ConfigLatitude instance) =>
    <String, dynamic>{
      'default': instance.defaultValue,
      'options': instance.options,
    };

ConfigMethod _$ConfigMethodFromJson(Map<String, dynamic> json) => ConfigMethod(
      defaultValue: json['default'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ConfigMethodToJson(ConfigMethod instance) =>
    <String, dynamic>{
      'default': instance.defaultValue,
      'options': instance.options,
    };

HighLatitudeRuleModel _$HighLatitudeRuleModelFromJson(
        Map<String, dynamic> json) =>
    HighLatitudeRuleModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$HighLatitudeRuleModelToJson(
        HighLatitudeRuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

CountryInfo _$CountryInfoFromJson(Map<String, dynamic> json) => CountryInfo(
      id: json['id'] as String,
    );

Map<String, dynamic> _$CountryInfoToJson(CountryInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

SalahCalculationMethod _$SalahCalculationMethodFromJson(
        Map<String, dynamic> json) =>
    SalahCalculationMethod(
      id: json['id'] as String,
      method: json['method'] as String,
      fajrAngle: (json['fajrAngle'] as num).toDouble(),
      ishaAngle: (json['ishaAngle'] as num?)?.toDouble(),
      ishaInterval: (json['ishaInterval'] as num).toInt(),
      maghribAngle: (json['maghribAngle'] as num?)?.toDouble(),
      madhab: $enumDecode(_$MadhabEnumMap, json['madhab']),
      highLatitudeRule:
          $enumDecode(_$HighLatitudeRuleEnumMap, json['highLatitudeRule']),
      adjustments:
          Adjustments.fromJson(json['adjustments'] as Map<String, dynamic>),
      methodAdjustments: Adjustments.fromJson(
          json['methodAdjustments'] as Map<String, dynamic>),
      customized: json['customized'] as bool? ?? false,
    );

Map<String, dynamic> _$SalahCalculationMethodToJson(
        SalahCalculationMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'customized': instance.customized,
      'fajrAngle': instance.fajrAngle,
      'ishaAngle': instance.ishaAngle,
      'ishaInterval': instance.ishaInterval,
      'maghribAngle': instance.maghribAngle,
      'madhab': _$MadhabEnumMap[instance.madhab]!,
      'highLatitudeRule': _$HighLatitudeRuleEnumMap[instance.highLatitudeRule]!,
      'adjustments': instance.adjustments,
      'methodAdjustments': instance.methodAdjustments,
    };

const _$HighLatitudeRuleEnumMap = {
  HighLatitudeRule.none: 'none',
  HighLatitudeRule.middleOfTheNight: 'middleOfTheNight',
  HighLatitudeRule.oneSeventhOfTheNight: 'oneSeventh',
  HighLatitudeRule.angleBased: 'angleBased',
};

SalahTimeConfig _$SalahTimeConfigFromJson(Map<String, dynamic> json) =>
    SalahTimeConfig(
      madhabs: (json['madhabs'] as List<dynamic>)
          .map((e) => $enumDecode(_$MadhabEnumMap, e))
          .toList(),
      highLatitudeRules: (json['highLatitudeRules'] as List<dynamic>)
          .map((e) => $enumDecode(_$HighLatitudeRuleEnumMap, e))
          .toList(),
      methods: (json['methods'] as List<dynamic>)
          .map(
              (e) => SalahCalculationMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      config: (json['config'] as List<dynamic>)
          .map((e) => CountryConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalahTimeConfigToJson(SalahTimeConfig instance) =>
    <String, dynamic>{
      'madhabs': instance.madhabs.map((e) => _$MadhabEnumMap[e]!).toList(),
      'highLatitudeRules': instance.highLatitudeRules
          .map((e) => _$HighLatitudeRuleEnumMap[e]!)
          .toList(),
      'methods': instance.methods,
      'config': instance.config,
    };
