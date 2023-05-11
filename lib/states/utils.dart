import '../models/trail.dart';
import '../models/user.dart';
import '../view-models/trail.dart';

TrailViewModel computeTrailView({required final UserParameters params, required final Trail trail}) {
  // Initialize total duration.
  Duration totalDuration = Duration.zero;
  Duration totalResting = Duration.zero;
  Duration remainder = Duration.zero;

  final List<TrailSegmentViewModel> segments = [];
  for (int i = 0; i < trail.segments.length; ++i) {
    final Duration duration = params.calculator.computeDuration(trail.segments[i], fitness: params.fitness);
    Duration resting = params.calculator.computeResting(trail.segments[i], fitness: params.fitness);

    resting = remainder + resting;
    if (resting.inMinutes < 10) {
      // Cumulated resting time is less than 10min.

      // Update remainder resting time and set resting time to 0.
      remainder = resting;
      resting = Duration.zero;
    } else {
      // Reset remainder.
      remainder = Duration.zero;
    }

    if (i == trail.segments.length - 1) {
      // Last segment.
      resting = remainder + resting;
    }

    // Round resting to 5min slots.
    resting = new Duration(minutes: (resting.inMinutes / 5).round() * 5);

    segments.add(new TrailSegmentViewModel(
      trail.segments[i].hdist,
      trail.segments[i].dalt,
      trail.segments[i].mid,
      index: i,
      duration: duration,
      resting: resting,
    ));

    totalDuration += duration;
    totalResting += resting;
  }

  final TrailViewModel trailView = new TrailViewModel(
    segments,
    duration: totalDuration,
    resting: totalResting,
  );

  return trailView;
}
