part of "models.dart";

@JsonSerializable()
class CountryInfo {
  final String id;

  CountryInfo({required this.id});

  factory CountryInfo.fromJson(Map<String, dynamic> json) => _$CountryInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CountryInfoToJson(this);
}
