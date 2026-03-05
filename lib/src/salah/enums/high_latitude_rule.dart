part of 'enums.dart';

@JsonEnum()
enum HighLatitudeRule {
  @JsonValue("none") none,
  @JsonValue("middleOfTheNight")  middleOfTheNight,
  @JsonValue("oneSeventh")  oneSeventhOfTheNight,
  @JsonValue("angleBased")  angleBased,
}
