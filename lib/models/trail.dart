import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import './geospatial.dart';

part 'trail.g.dart';

/// Track point.
@JsonSerializable(explicitToJson: true)
@immutable
class WayPoint {
  const WayPoint(this.coordinates, this.altitude);

  final Coordinates coordinates;

  final double altitude;

  double get lat => coordinates.lat;

  double get long => coordinates.long;

  /// JSON serialization.
  factory WayPoint.fromJson(Map<String, dynamic> json) => _$WayPointFromJson(json);

  Map<String, dynamic> toJson() => _$WayPointToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WayPoint &&
          runtimeType == other.runtimeType &&
          coordinates == other.coordinates &&
          altitude == other.altitude;

  @override
  int get hashCode => coordinates.hashCode ^ altitude.hashCode;
}

/// Track segment.
@JsonSerializable(explicitToJson: true)
@immutable
class TrailSegment {
  const TrailSegment(this.hdist, this.dalt, this.mid);

  const TrailSegment.fromHdistAndDalt(this.hdist, this.dalt, this.mid);

  /// Horizontal distance.
  final double hdist;

  /// Elevation gain.
  final double dalt;

  /// M.I.D. level
  final MIDLevel mid;

  /// Actual distance.
  double get distance => math.sqrt(hdist * hdist + dalt * dalt);

  /// JSON serialization.
  static TrailSegment fromJson(Map<String, dynamic> json) => _$TrailSegmentFromJson(json);

  Map<String, dynamic> toJson() => _$TrailSegmentToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrailSegment &&
          runtimeType == other.runtimeType &&
          dalt == other.dalt &&
          hdist == other.hdist &&
          mid == other.mid;

  @override
  int get hashCode => dalt.hashCode ^ hdist.hashCode ^ mid.hashCode;
}

@JsonSerializable(explicitToJson: true, genericArgumentFactories: true)
@immutable
class Trail<T extends TrailSegment> {
  const Trail(final List<T> segments) : _segments = segments;

  final List<T> _segments;

  List<T> get segments => _segments;

  /// Total distance.
  double get distance {
    double res = 0;
    for (final TrailSegment segment in segments) {
      res += segment.distance;
    }
    return res;
  }

  /// Total horizontal distance.
  double get hdist {
    double res = 0;
    for (final TrailSegment segment in segments) {
      res += segment.hdist;
    }
    return res;
  }

  /// Total d+.
  double get dplus {
    double res = 0;
    for (final TrailSegment segment in segments) {
      if (segment.dalt > 0) {
        res += segment.dalt;
      }
    }
    return res;
  }

  /// Total d-.
  double get dminus {
    double res = 0;
    for (final TrailSegment segment in segments) {
      if (segment.dalt < 0) {
        res += segment.dalt;
      }
    }
    return res;
  }

  /// JSON serialization.
  factory Trail.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$TrailFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$TrailToJson(this, toJsonT);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Trail && runtimeType == other.runtimeType && segments == other.segments;

  @override
  int get hashCode => segments.hashCode;
}

/// M.I.D. level of a trail.dart segment.
///
/// M.I.D. (Medium, Itinerary and Difficulty) is an evaluation system used among hikers
/// to assess and express the technical and physical demands of the hikes.
/// The M.I.D.(E.) system is recommended by the "Federation Española de Dedeportes de
/// Montaña y Escalada" (F.E.D.M.E.).
enum MIDLevel {
  easy, // Easy: Level 1
  moderate, // Moderate: Level 2
  challenging, // Challenging: Level 3
  hard, // Difficult: Level 4
  extreme, // Extreme: Level 5
}
