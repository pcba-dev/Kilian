import './trail.dart';

class TrailCalculator {
  const TrailCalculator();

// TODO
  Duration computeDuration(final TrailSegment segment) {
    return new Duration(hours: 1, minutes: 20);
  }

  Duration computeTotalDuration(final Trail trail) {
    // Initialize total duration.
    Duration totalDuration = Duration.zero;
    for (final TrailSegment segment in trail.segments) {
      final Duration segmentDuration = computeDuration(segment);
      totalDuration = totalDuration + segmentDuration;
    }
    return totalDuration;
  }
}
