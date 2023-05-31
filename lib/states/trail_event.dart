import 'package:flutter/foundation.dart';

import '../models/trail.dart';

/// Cubit events base class for trail mutations.
@immutable
abstract class TrailEvent {
  const TrailEvent();
}

class AddSegmentEvent extends TrailEvent {
  /// New segment data.
  final TrailSegment segment;

  const AddSegmentEvent(this.segment);
}

class RemoveSegmentEvent extends TrailEvent {
  /// Segment to be removed position index.
  final int index;

  const RemoveSegmentEvent(this.index);
}

class ReplaceSegmentEvent extends TrailEvent {
  /// Segment position index in the trail.
  final int index;

  /// New segment data.
  final TrailSegment segment;

  const ReplaceSegmentEvent(this.index, this.segment);
}

class ReorderSegmentEvent extends TrailEvent {
  /// Segment old position index.
  final int oldPos;

  /// Segment new position index.
  final int newPos;

  const ReorderSegmentEvent(this.oldPos, this.newPos);
}
