import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import './calculator.dart';
import './trail.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class UserParameters {
  /// Fitness level.
  final FitnessLevel fitness;

  @TrailCalculatorJsonConverter()
  final TrailCalculator calculator;

  const UserParameters({
    required this.calculator,
    this.fitness = FitnessLevel.average,
  });

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
