part of "models.dart";

@JsonSerializable()
class ConfigLatitude {
  @JsonKey(name: 'default')
  final String defaultValue;
  final List<String> options;

  ConfigLatitude({required this.defaultValue, required this.options});

  factory ConfigLatitude.fromJson(Map<String, dynamic> json) =>
      _$ConfigLatitudeFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigLatitudeToJson(this);
}
