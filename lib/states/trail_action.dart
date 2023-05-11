import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import '../models/trail.dart';
import '../view-models/trail.dart';
import 'app_action.dart';
import 'app_state.dart';
import 'utils.dart' as utils;

Reducer<AppState> trailReducer = (
  final AppState previous,
  final dynamic action,
) {
  late final TrailViewModel trail;
  if (action is AddSegmentAction) {
    trail = addSegmentReducer(previous, action);
  } else if (action is RemoveSegmentAction) {
    trail = removeSegmentReducer(previous, action);
  } else if (action is ReplaceSegmentAction) {
    trail = replaceSegmentReducer(previous, action);
  } else if (action is ReorderSegmentAction) {
    trail = reorderSegmentsReducer(previous, action);
  } else {
    trail = previous.trail;
  }

  return new AppState(
    parameters: previous.parameters,
    trail: trail,
  );
};

@immutable
abstract class TrailAction extends AppAction {
  const TrailAction();
}

class AddSegmentAction extends TrailAction {
  /// New segment data.
  final TrailSegment segment;

  const AddSegmentAction(this.segment);
}

class RemoveSegmentAction extends TrailAction {
  /// Segment to be removed position index.
  final int index;

  const RemoveSegmentAction(this.index);
}

class ReplaceSegmentAction extends TrailAction {
  /// Segment position index in the trail.
  final int index;

  /// New segment data.
  final TrailSegment segment;

  const ReplaceSegmentAction(this.index, this.segment);
}

class ReorderSegmentAction extends TrailAction {
  /// Segment old position index.
  final int oldPos;

  /// Segment new position index.
  final int newPos;

  const ReorderSegmentAction(this.oldPos, this.newPos);
}

/// REDUCERS:

/// REDUX reducer for [AddSegmentAction].
TrailViewModel addSegmentReducer(
  final AppState previous,
  final AddSegmentAction action,
) {
  final List<TrailSegment> segments = new List.from(previous.trail.segments)..add(action.segment);

  return utils.computeTrailView(params: previous.parameters, trail: new Trail(segments));
}

/// REDUX reducer for [RemoveSegmentAction].
TrailViewModel removeSegmentReducer(
  final AppState previous,
  final RemoveSegmentAction action,
) {
  final List<TrailSegment> segments = new List.from(previous.trail.segments)..removeAt(action.index);

  return utils.computeTrailView(params: previous.parameters, trail: new Trail(segments));
}

/// REDUX reducer for [ReplaceSegmentAction].
TrailViewModel replaceSegmentReducer(
  final AppState previous,
  final ReplaceSegmentAction action,
) {
  final List<TrailSegment> segments = new List.from(previous.trail.segments)
    ..removeAt(action.index)
    ..insert(action.index, action.segment);

  return utils.computeTrailView(params: previous.parameters, trail: new Trail(segments));
}

/// REDUX reducer for [ReorderSegmentAction].
TrailViewModel reorderSegmentsReducer(
  final AppState previous,
  final ReorderSegmentAction action,
) {
  final List<TrailSegment> segments = new List.from(previous.trail.segments);

  final TrailSegment segment = segments.removeAt(action.oldPos);
  segments.insert(action.newPos > action.oldPos ? action.newPos - 1 : action.newPos, segment);

  return utils.computeTrailView(params: previous.parameters, trail: new Trail(segments));
}
