import 'dart:math' as math;

import 'package:kilian/models/user.dart';

import './trail.dart';

abstract class TrailCalculator {
  const TrailCalculator({this.fitness = FitnessLevel.average});

  final FitnessLevel fitness;

  Duration computeDuration(final TrailSegment segment);

  Duration computeResting(final TrailSegment segment);
}

class StandardTrailCalculator extends TrailCalculator {
  const StandardTrailCalculator({super.fitness});

  /// Horizontal distance speed: 4km/h
  static const double _kHSpeed = 4000 / 60;

  /// D+ speed: +400m/h
  static const double _kDplusSpeed = 400 / 60;

  /// D- speed: -600m/h
  static const double _kDminusSpeed = 600 / 60;

  /// Threshold to define flat trail segment: +/-50m in 1k
  static const double _kThresholdH = 50 / 1000;

  @override
  Duration computeDuration(final TrailSegment segment) {
    // Compute the time portion required to cover the horizontal distance.
    final double hdistTime = segment.hdist / _kHSpeed;

    // Compute the time portion required to cover the altitude difference.
    double daltTime = 0;
    if (segment.dalt.abs() / segment.hdist > _kThresholdH) {
      if (segment.dalt > 0) {
        daltTime = segment.dalt / _kDplusSpeed;
      } else {
        daltTime = segment.dalt.abs() / _kDminusSpeed;
      }
    }

    // Trail segment base time is computed as the sum of the time of the most important
    // portion plus half the time of the other portion.
    double time = math.max(hdistTime, daltTime) + 0.5 * math.min(hdistTime, daltTime);

    // Correct the base time with fitness and M.I.D. factors.
    time = time * _kMIDFactors[segment.mid]! * _kFitnessFactors[fitness]!;

    // Round to 5min slots.
    time = (time / 5).round() * 5;

    return new Duration(minutes: time.round());
  }

  @override
  Duration computeResting(final TrailSegment segment) {
    final Duration duration = computeDuration(segment);

    // Rest 10min every 1h.
    double resting = duration.inMinutes / 6;

    // Round to 5min slots.
    resting = resting < 5 ? 0 : (resting / 5).round() * 5;

    return new Duration(minutes: resting.round());
  }

  static const Map<MIDLevel, double> _kMIDFactors = {
    MIDLevel.easy: 0.9,
    MIDLevel.moderate: 1,
    MIDLevel.challenging: 1.25,
    MIDLevel.hard: 1.5,
    MIDLevel.extreme: 2.0,
  };

  static const Map<FitnessLevel, double> _kFitnessFactors = {
    FitnessLevel.child: 2,
    FitnessLevel.sedentary: 1.5,
    FitnessLevel.beginner: 1.25,
    FitnessLevel.average: 1,
    FitnessLevel.athletic: 0.9,
  };
}
