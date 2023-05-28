// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrailSegment _$TrailSegmentFromJson(Map<String, dynamic> json) => TrailSegment(
      (json['hdist'] as num).toDouble(),
      (json['dalt'] as num).toDouble(),
      $enumDecode(_$MIDLevelEnumMap, json['mid']),
    );

Map<String, dynamic> _$TrailSegmentToJson(TrailSegment instance) =>
    <String, dynamic>{
      'hdist': instance.hdist,
      'dalt': instance.dalt,
      'mid': _$MIDLevelEnumMap[instance.mid]!,
    };

const _$MIDLevelEnumMap = {
  MIDLevel.easy: 'easy',
  MIDLevel.moderate: 'moderate',
  MIDLevel.challenging: 'challenging',
  MIDLevel.hard: 'hard',
  MIDLevel.extreme: 'extreme',
};

Trail<T> _$TrailFromJson<T extends TrailSegment>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Trail<T>(
      (json['segments'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$TrailToJson<T extends TrailSegment>(
  Trail<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'segments': instance.segments.map(toJsonT).toList(),
    };
