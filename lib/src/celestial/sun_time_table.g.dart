// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sun_time_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SunTimeTable _$SunTimeTableFromJson(Map<String, dynamic> json) => SunTimeTable(
      solarNoon: DateTimeHelper.fromJson((json['solarNoon'] as num).toInt()),
      nadir: DateTimeHelper.fromJson((json['nadir'] as num).toInt()),
      sunrise:
          DateTimeHelper.fromRangeJson(json['sunrise'] as Map<String, dynamic>),
      sunset:
          DateTimeHelper.fromRangeJson(json['sunset'] as Map<String, dynamic>),
      dawn: DateTimeHelper.fromJson((json['dawn'] as num).toInt()),
      dusk: DateTimeHelper.fromJson((json['dusk'] as num).toInt()),
      nauticalDawn:
          DateTimeHelper.fromJson((json['nauticalDawn'] as num).toInt()),
      nauticalDusk:
          DateTimeHelper.fromJson((json['nauticalDusk'] as num).toInt()),
      nightEnd: DateTimeHelper.fromJson((json['nightEnd'] as num).toInt()),
      nightStart: DateTimeHelper.fromJson((json['nightStart'] as num).toInt()),
      goldenHourStart:
          DateTimeHelper.fromJson((json['goldenHourStart'] as num).toInt()),
      goldenHourEnd:
          DateTimeHelper.fromJson((json['goldenHourEnd'] as num).toInt()),
    );

Map<String, dynamic> _$SunTimeTableToJson(SunTimeTable instance) =>
    <String, dynamic>{
      'solarNoon': DateTimeHelper.toJson(instance.solarNoon),
      'nadir': DateTimeHelper.toJson(instance.nadir),
      'dawn': DateTimeHelper.toJson(instance.dawn),
      'dusk': DateTimeHelper.toJson(instance.dusk),
      'nauticalDawn': DateTimeHelper.toJson(instance.nauticalDawn),
      'nauticalDusk': DateTimeHelper.toJson(instance.nauticalDusk),
      'nightEnd': DateTimeHelper.toJson(instance.nightEnd),
      'nightStart': DateTimeHelper.toJson(instance.nightStart),
      'goldenHourEnd': DateTimeHelper.toJson(instance.goldenHourEnd),
      'goldenHourStart': DateTimeHelper.toJson(instance.goldenHourStart),
      'sunrise': DateTimeHelper.toRangeJson(instance.sunrise),
      'sunset': DateTimeHelper.toRangeJson(instance.sunset),
    };
