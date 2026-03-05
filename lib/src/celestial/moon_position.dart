import 'sun_calculator.dart';

class MoonPosition {
  final double azimuth;
  final double altitude;
  final double distance;
  final double parallacticAngle;

  const MoonPosition._({
    required this.azimuth,
    required this.altitude,
    required this.distance,
    required this.parallacticAngle,
  });

  factory MoonPosition.get(
    DateTime dateTime, {
    required double latitude,
    required double longitude,
  }) {
    final data = SunCalculator.getMoonPosition(
      dateTime,
      latitude,
      longitude,
    );

    return MoonPosition._(
      azimuth: data['azimuth'],
      altitude: data['altitude'],
      distance: data['distance'],
      parallacticAngle: data['parallacticAngle'],
    );
  }
}
