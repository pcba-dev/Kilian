// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTrail<T> _$UserTrailFromJson<T extends Trail<TrailSegment>>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    UserTrail<T>(
      trail: fromJsonT(json['trail']),
      params: UserParameters.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserTrailToJson<T extends Trail<TrailSegment>>(
  UserTrail<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'trail': toJsonT(instance.trail),
      'params': instance.params,
    };

UserParameters _$UserParametersFromJson(Map<String, dynamic> json) => UserParameters(
      fitness: $enumDecode(_$FitnessLevelEnumMap, json['fitness']),
    );

Map<String, dynamic> _$UserParametersToJson(UserParameters instance) => <String, dynamic>{
      'fitness': _$FitnessLevelEnumMap[instance.fitness]!,
    };

const _$FitnessLevelEnumMap = {
  FitnessLevel.child: 'child',
  FitnessLevel.sedentary: 'sedentary',
  FitnessLevel.beginner: 'beginner',
  FitnessLevel.average: 'average',
  FitnessLevel.athletic: 'athletic',
};
