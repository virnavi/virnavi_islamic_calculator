part of "models.dart";


@JsonSerializable()
class Adjustments {
  @JsonKey(name: "fajr")
  final int fajr;
  @JsonKey(name: "sunrise")
  final int sunrise;
  @JsonKey(name: "dhuhr")
  final int dhuhr;
  @JsonKey(name: "asr")
  final int asr;
  @JsonKey(name: "maghrib")
  final int maghrib;
  @JsonKey(name: "isha")
  final int isha;
  
  Adjustments({
     this.fajr = 0,
     this.sunrise= 0,
     this.dhuhr= 0,
     this.asr= 0,
     this.maghrib= 0,
     this.isha= 0,
  });

  factory Adjustments.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentsFromJson(json);

  Map<String, dynamic> toJson() => _$AdjustmentsToJson(this);
}
