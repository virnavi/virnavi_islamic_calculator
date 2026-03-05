part of "models.dart";

@JsonSerializable()
class ConfigAsrMethod {
  @JsonKey(name: 'default')
  final Madhab defaultValue;
  final List<Madhab> options;

  ConfigAsrMethod({required this.defaultValue, required this.options});

  factory ConfigAsrMethod.fromJson(Map<String, dynamic> json) =>
      _$ConfigAsrMethodFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigAsrMethodToJson(this);
}
