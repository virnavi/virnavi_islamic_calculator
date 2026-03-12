// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zakat_calculator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZakatCalculator _$ZakatCalculatorFromJson(Map<String, dynamic> json) =>
    ZakatCalculator(
      goldPricePerGram: (json['goldPricePerGram'] as num).toDouble(),
      silverPricePerGram: (json['silverPricePerGram'] as num).toDouble(),
      nisabStandard:
          $enumDecodeNullable(_$NisabStandardEnumMap, json['nisabStandard']) ??
          NisabStandard.gold,
      cash: (json['cash'] as num?)?.toDouble() ?? 0,
      goldValue: (json['goldValue'] as num?)?.toDouble() ?? 0,
      silverValue: (json['silverValue'] as num?)?.toDouble() ?? 0,
      businessInventory: (json['businessInventory'] as num?)?.toDouble() ?? 0,
      receivables: (json['receivables'] as num?)?.toDouble() ?? 0,
      investments: (json['investments'] as num?)?.toDouble() ?? 0,
      rentalIncome: (json['rentalIncome'] as num?)?.toDouble() ?? 0,
      debts: (json['debts'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ZakatCalculatorToJson(ZakatCalculator instance) =>
    <String, dynamic>{
      'nisabStandard': _$NisabStandardEnumMap[instance.nisabStandard]!,
      'goldPricePerGram': instance.goldPricePerGram,
      'silverPricePerGram': instance.silverPricePerGram,
      'cash': instance.cash,
      'goldValue': instance.goldValue,
      'silverValue': instance.silverValue,
      'businessInventory': instance.businessInventory,
      'receivables': instance.receivables,
      'investments': instance.investments,
      'rentalIncome': instance.rentalIncome,
      'debts': instance.debts,
    };

const _$NisabStandardEnumMap = {
  NisabStandard.gold: 'gold',
  NisabStandard.silver: 'silver',
};

ZakatResult _$ZakatResultFromJson(Map<String, dynamic> json) => ZakatResult(
  nisabStandard: $enumDecode(_$NisabStandardEnumMap, json['nisabStandard']),
  grossWealth: (json['grossWealth'] as num).toDouble(),
  netWealth: (json['netWealth'] as num).toDouble(),
  nisabByGold: (json['nisabByGold'] as num).toDouble(),
  nisabBySilver: (json['nisabBySilver'] as num).toDouble(),
  applicableNisab: (json['applicableNisab'] as num).toDouble(),
  isZakatDue: json['isZakatDue'] as bool,
  zakatDue: (json['zakatDue'] as num).toDouble(),
);

Map<String, dynamic> _$ZakatResultToJson(ZakatResult instance) =>
    <String, dynamic>{
      'nisabStandard': _$NisabStandardEnumMap[instance.nisabStandard]!,
      'grossWealth': instance.grossWealth,
      'netWealth': instance.netWealth,
      'nisabByGold': instance.nisabByGold,
      'nisabBySilver': instance.nisabBySilver,
      'applicableNisab': instance.applicableNisab,
      'isZakatDue': instance.isZakatDue,
      'zakatDue': instance.zakatDue,
    };
