// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserParameters _$UserParametersFromJson(Map<String, dynamic> json) =>
    UserParameters(
      calculator: const TrailCalculatorJsonConverter()
          .fromJson(json['calculator'] as Map<String, dynamic>),
      fitness: $enumDecodeNullable(_$FitnessLevelEnumMap, json['fitness']) ??
          FitnessLevel.average,
    );

Map<String, dynamic> _$UserParametersToJson(UserParameters instance) =>
    <String, dynamic>{
      'fitness': _$FitnessLevelEnumMap[instance.fitness]!,
      'calculator':
          const TrailCalculatorJsonConverter().toJson(instance.calculator),
    };

const _$FitnessLevelEnumMap = {
  FitnessLevel.child: 'child',
  FitnessLevel.sedentary: 'sedentary',
  FitnessLevel.beginner: 'beginner',
  FitnessLevel.average: 'average',
  FitnessLevel.athletic: 'athletic',
};
