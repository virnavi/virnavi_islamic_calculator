part of "models.dart";

@JsonSerializable()
class SalahTimeConfig {
  @JsonKey(name: "madhabs")
  final List<Madhab> madhabs;
  @JsonKey(name: "highLatitudeRules")
  final List<HighLatitudeRule> highLatitudeRules;
  @JsonKey(name: "methods")
  final List<SalahCalculationMethod> methods;
  @JsonKey(name: "config")
  final List<CountryConfig> config;

  SalahTimeConfig({
    required this.madhabs,
    required this.highLatitudeRules,
    required this.methods,
    required this.config,
  });

  factory SalahTimeConfig.fromJson(Map<String, dynamic> json) =>
      _$SalahTimeConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SalahTimeConfigToJson(this);

  static  Future<SalahTimeConfig> get() async {
    final jsonString = await rootBundle.loadString(
      'packages/virnavi_islamic_calculator/assets/data/salah_time_config.json',
    );
    final jsonMap = json.decode(jsonString);
    return SalahTimeConfig.fromJson(jsonMap);
  }
}

