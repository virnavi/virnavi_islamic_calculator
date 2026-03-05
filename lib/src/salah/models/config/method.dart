part of "models.dart";
@JsonSerializable()
class SalahCalculationMethod {
  @JsonKey(name: "id")
  final String id;
  @JsonKey(name: "method")
  final String method;
  @JsonKey(name: "customized", defaultValue: false)
  final bool customized;
  @JsonKey(name: "fajrAngle")
  final double fajrAngle;
  @JsonKey(name: "ishaAngle")
  final double? ishaAngle;
  @JsonKey(name: "ishaInterval")
  final int ishaInterval;
  @JsonKey(name: "maghribAngle")
  final double? maghribAngle;
  @JsonKey(name: "madhab")
  final Madhab madhab;
  @JsonKey(name: "highLatitudeRule")
  final HighLatitudeRule highLatitudeRule;
  @JsonKey(name: "adjustments")
  final Adjustments adjustments;
  @JsonKey(name: "methodAdjustments")
  final Adjustments methodAdjustments;

  SalahCalculationMethod({
    required this.id,
    required this.method,
    required this.fajrAngle,
    required this.ishaAngle,
    required this.ishaInterval,
    required this.maghribAngle,
    required this.madhab,
    required this.highLatitudeRule,
    required this.adjustments,
    required this.methodAdjustments,
    required this.customized,
  });

  factory SalahCalculationMethod.fromJson(Map<String, dynamic> json) =>
      _$SalahCalculationMethodFromJson(json);

  Map<String, dynamic> toJson() => _$SalahCalculationMethodToJson(this);

  static Future<SalahCalculationMethod> getCalculationMethod(String id) async {
    final config = await SalahTimeConfig.get();
    final method = config.methods.firstWhere(
          (method) => method.id == id,
      orElse: () => throw Exception('Calculation Method $id not found'),
    );
    return method;
  }

  SalahCalculationMethod copyWith({
    String? id,
    String? method,
    double? fajrAngle,
    double? ishaAngle,
    int? ishaInterval,
    double? maghribAngle,
    Madhab? madhab,
    HighLatitudeRule? highLatitudeRule,
    Adjustments? adjustments,
    Adjustments? methodAdjustments,
  }) {
    return SalahCalculationMethod(
      id: id ?? this.id,
      method: method ?? this.method,
      customized: true,
      fajrAngle: fajrAngle ?? this.fajrAngle,
      ishaAngle: ishaAngle ?? this.ishaAngle,
      ishaInterval: ishaInterval ?? this.ishaInterval,
      maghribAngle: maghribAngle ?? this.maghribAngle,
      madhab: madhab ?? this.madhab,
      highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
      adjustments: adjustments ?? this.adjustments,
      methodAdjustments: methodAdjustments ?? this.methodAdjustments,
    );
  }
}