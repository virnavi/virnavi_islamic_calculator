part of "models.dart";

@JsonSerializable()
class HighLatitudeRuleModel {
  final String id;
  final String name;

  HighLatitudeRuleModel({required this.id, required this.name});

  factory HighLatitudeRuleModel.fromJson(Map<String, dynamic> json) =>
      _$HighLatitudeRuleModelFromJson(json);

  Map<String, dynamic> toJson() => _$HighLatitudeRuleModelToJson(this);
}
