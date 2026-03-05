// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salah_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalahTimes _$SalahTimesFromJson(Map<String, dynamic> json) => SalahTimes(
      fajr: DateTimeHelper.fromRangeJson(json['fajr'] as Map<String, dynamic>),
      dhuhr:
          DateTimeHelper.fromRangeJson(json['dhuhr'] as Map<String, dynamic>),
      asr: DateTimeHelper.fromRangeJson(json['asr'] as Map<String, dynamic>),
      maghrib:
          DateTimeHelper.fromRangeJson(json['maghrib'] as Map<String, dynamic>),
      isha: DateTimeHelper.fromRangeJson(json['isha'] as Map<String, dynamic>),
      witr: DateTimeHelper.fromRangeJson(json['witr'] as Map<String, dynamic>),
      duha: DateTimeHelper.fromRangeJson(json['duha'] as Map<String, dynamic>),
      awwabin:
          DateTimeHelper.fromRangeJson(json['awwabin'] as Map<String, dynamic>),
      tahajjud: DateTimeHelper.fromRangeJson(
          json['tahajjud'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SalahTimesToJson(SalahTimes instance) =>
    <String, dynamic>{
      'fajr': DateTimeHelper.toRangeJson(instance.fajr),
      'dhuhr': DateTimeHelper.toRangeJson(instance.dhuhr),
      'asr': DateTimeHelper.toRangeJson(instance.asr),
      'maghrib': DateTimeHelper.toRangeJson(instance.maghrib),
      'isha': DateTimeHelper.toRangeJson(instance.isha),
      'witr': DateTimeHelper.toRangeJson(instance.witr),
      'duha': DateTimeHelper.toRangeJson(instance.duha),
      'awwabin': DateTimeHelper.toRangeJson(instance.awwabin),
      'tahajjud': DateTimeHelper.toRangeJson(instance.tahajjud),
    };
