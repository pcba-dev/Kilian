import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

/// Track point.
@immutable
class TrackPoint {
  const TrackPoint(this.coordinates);

  final Coordinates coordinates;

  double get lat => coordinates.lat;
  double get long => coordinates.long;
}

/// An immutable class representing a pair of latitude and longitude coordinates, stored in degrees.
@JsonSerializable()
@immutable
class Coordinates {
  final double lat;
  final double long;

  const Coordinates(this.lat, this.long);

  /// JSON serialization.
  // factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
  // Map<String, dynamic> toJson() => _$CoordinatesToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Coordinates && runtimeType == other.runtimeType && lat == other.lat && long == other.long;

  @override
  int get hashCode => lat.hashCode ^ long.hashCode;

  @override
  String toString() => 'Coordinates{latitude: $lat, longitude: $long}';
}

class EarthCalculator {
  // The equatorial radius of the earth in meters
  static const double _kEarthEqRadius = 6378137;

  // The meridional radius of the earth in meters
  static const double _kEarthPolarRadius = 6357852.3;
  // Flattening factor
  static const double _kF = (_kEarthEqRadius - _kEarthPolarRadius) / _kEarthEqRadius;

  static const EarthCalculator instance = EarthCalculator._();

  const EarthCalculator._();

  static double elevation(final Coordinates point) {
    final double latRad = math.pi / 180 * point.lat;
    final double lonRad = math.pi / 180 * point.long;

    final double cosLat = math.cos(latRad);
    final double sinLat = math.sin(latRad);

    final double a = _kEarthEqRadius * cosLat;
    final double b = _kEarthPolarRadius * sinLat;

    final double c = math.sqrt(a * a + b * b);
    final double d = _kEarthEqRadius * _kEarthEqRadius / c;

    final double cosLon = math.cos(lonRad);
    final double sinLon = math.sin(lonRad);

    final double e = d * cosLat * cosLon;
    final double f = d * cosLat * sinLon;
    final double g = d * sinLat;

    final double x = (c + e) * cosLon;
    final double y = (c + e) * sinLon;
    final double z = (g + f) * f + _kEarthEqRadius * _kEarthEqRadius * sinLat * sinLat - d * _kEarthPolarRadius;

    return math.sqrt(x * x + y * y + z * z) - _kEarthEqRadius;
  }

  /// Calculate the Haversine distance between two coordinate points.
  static double distance(final Coordinates point1, final Coordinates point2) {
    // Earth's mean radius in meters
    const double radius = (_kEarthEqRadius + _kEarthPolarRadius) / 2;
    final double latDelta = _toRadians(point1.lat - point2.lat);
    final double lonDelta = _toRadians(point1.long - point2.long);

    final double a = (math.sin(latDelta / 2) * math.sin(latDelta / 2)) +
        (math.cos(_toRadians(point1.lat)) *
            math.cos(_toRadians(point2.lat)) *
            math.sin(lonDelta / 2) *
            math.sin(lonDelta / 2));
    final double distance = radius * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)); // Distance in meters.

    return double.parse(distance.toStringAsFixed(0));
  }

  static double _toRadians(double num) {
    return num * (math.pi / 180.0);
  }
}
