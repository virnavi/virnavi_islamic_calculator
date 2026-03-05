part of "models.dart";

@JsonSerializable()
class ConfigMethod {
  @JsonKey(name: 'default')
  final String defaultValue;
  final List<String> options;

  ConfigMethod({required this.defaultValue, required this.options});

  factory ConfigMethod.fromJson(Map<String, dynamic> json) =>
      _$ConfigMethodFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigMethodToJson(this);
}
