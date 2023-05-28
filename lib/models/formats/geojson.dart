import 'package:geotypes/geotypes.dart';

import '../geospatial.dart';

// RFC 7946 GeoJson conversions.

extension CoordinatesGeoJson on Coordinates {
  /// Converts to a RFC 7946 Position.
  /// Position order per RFC 7946 §3.1.1: [longitude, latitude].
  Position toGeoJson() => Position(long, lat);

  /// Converts a RFC 7946 Position array `[longitude, latitude]` to a [Coordinates].
  static Coordinates fromGeoJson(final List<dynamic> position) =>
      Coordinates((position[1] as num).toDouble(), (position[0] as num).toDouble());
}

extension WayPointGeoJson on WayPoint {
  /// Converts to a RFC 7946 Point geometry.
  Point toGeoJson() => Point(coordinates: Position(long, lat, altitude));

  /// Converts a RFC 7946 Point geometry to a [WayPoint].
  static WayPoint fromGeoJson(final Map<String, dynamic> json) {
    final List<dynamic> pos = json['coordinates'] as List<dynamic>;
    return WayPoint(
      (pos[1] as num).toDouble(),
      (pos[0] as num).toDouble(),
      pos.length > 2 ? (pos[2] as num).toDouble() : 0.0,
    );
  }
}

extension PathGeoJson on Path {
  /// Converts to a RFC 7946 LineString geometry.
  LineString toGeoJson() => LineString(
        coordinates: [for (final wp in waypoints) wp.toGeoJson().coordinates],
      );

  /// Converts a RFC 7946 LineString geometry to a [Path].
  static Path fromGeoJson(final Map<String, dynamic> json) {
    final List<dynamic> coords = json['coordinates'] as List<dynamic>;
    return Path([
      for (final dynamic pos in coords)
        WayPoint(
          ((pos as List<dynamic>)[1] as num).toDouble(),
          (pos[0] as num).toDouble(),
          pos.length > 2 ? (pos[2] as num).toDouble() : 0.0,
        ),
    ]);
  }
}
