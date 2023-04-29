import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import './trail.dart';

part 'user.g.dart';

@JsonSerializable(genericArgumentFactories: true)
@immutable
class UserTrail<T extends Trail> {
  final T trail;

  final UserParameters params;

  const UserTrail({
    required this.trail,
    required this.params,
  });

  /// JSON serialization.
  factory UserTrail.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$UserTrailFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) => _$UserTrailToJson(this, toJsonT);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTrail && runtimeType == other.runtimeType && trail == other.trail && params == other.params;

  @override
  int get hashCode => trail.hashCode ^ params.hashCode;
}

@JsonSerializable()
@immutable
class UserParameters {
  /// Fitness level.
  final FitnessLevel fitness;

  const UserParameters({this.fitness = FitnessLevel.average});

  /// JSON serialization.
  factory UserParameters.fromJson(Map<String, dynamic> json) => _$UserParametersFromJson(json);

  Map<String, dynamic> toJson() => _$UserParametersToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is UserParameters && runtimeType == other.runtimeType && fitness == other.fitness;

  @override
  int get hashCode => fitness.hashCode;
}

/// Fitness level.
enum FitnessLevel {
  child, // Child aged 6-8 years old.
  sedentary, // Sedentary adult or child aged 9-11 years old.
  beginner, // Beginner adult or early-adolescent aged 12-14 years old.
  average, // Average adult or late-adolescent aged 15-17 years old.
  athletic, // Athletic adult.
}
