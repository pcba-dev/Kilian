import '../models/trail.dart';

class TrailSegmentViewModel extends TrailSegment {
  const TrailSegmentViewModel(
    super.hdist,
    super.dalt,
    super.mid, {
    required this.duration,
    required this.resting,
  });

  /// Segment duration.
  final Duration duration;

  /// Trail cumulative duration.
  final Duration resting;
}

class TrailViewModel extends Trail<TrailSegmentViewModel> {
  const TrailViewModel(super.segments, {required this.duration, required this.resting}) : super();

  /// Total trail hiking duration.
  final Duration duration;

  /// Total trail resting and breaks duration.
  final Duration resting;
}

extension Duration2Human on Duration {
  /// Returns a human readble string representation of this [Duration].
  ///
  /// Returns a string with hours, minutes, seconds, and microseconds, in the
  /// following format: `HHh MMmin`. For example,
  /// ```dart
  /// var d = const Duration(days: 1, hours: 1, minutes: 33, microseconds: 500);
  /// print(d.toHumanString()); // 25h 33min
  ///
  /// d = const Duration(hours: 1, minutes: 10, microseconds: 500);
  /// print(d.toHumanString()); // 1h 10min
  /// ```
  String toHumanString() {
    final int microseconds = inMicroseconds;
    final String sign = (microseconds < 0) ? '-' : '';

    final int hours = microseconds ~/ Duration.microsecondsPerHour;

    final int minutes = microseconds ~/ Duration.microsecondsPerMinute - hours * 60;
    final String minutesPadding = minutes < 10 ? '0' : '';

    return "$sign${hours.abs()}h ${minutesPadding}${minutes}min";
  }
}
