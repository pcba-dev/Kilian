// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geospatial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
      (json['lat'] as num).toDouble(),
      (json['long'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };

WayPoint _$WayPointFromJson(Map<String, dynamic> json) => WayPoint(
      (json['lat'] as num).toDouble(),
      (json['long'] as num).toDouble(),
      (json['altitude'] as num).toDouble(),
    );

Map<String, dynamic> _$WayPointToJson(WayPoint instance) => <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
      'altitude': instance.altitude,
    };

Path _$PathFromJson(Map<String, dynamic> json) => Path(
      (json['waypoints'] as List<dynamic>)
          .map((e) => WayPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PathToJson(Path instance) => <String, dynamic>{
      'waypoints': instance.waypoints.map((e) => e.toJson()).toList(),
    };
