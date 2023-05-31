import 'package:bloc/bloc.dart';

import '../models/trail.dart';
import 'trail_event.dart';

class TrailCubit extends Cubit<Trail<TrailSegment>> {
  TrailCubit() : super(const Trail<TrailSegment>([]));

  /// Handler for [TrailEvent]s.
  void add(final TrailEvent event) {
    if (event is AddSegmentEvent) {
      // Handler for [AddSegmentEvent].
      emit(new Trail<TrailSegment>(
          new List.from(state.segments)..add(event.segment)));
    } else if (event is RemoveSegmentEvent) {
      // Handler for [RemoveSegmentEvent].
      emit(new Trail<TrailSegment>(
          new List.from(state.segments)..removeAt(event.index)));
    } else if (event is ReplaceSegmentEvent) {
      // Handler for [ReplaceSegmentEvent].
      emit(new Trail<TrailSegment>(new List.from(state.segments)
        ..removeAt(event.index)
        ..insert(event.index, event.segment)));
    } else if (event is ReorderSegmentEvent) {
      // Handler for [ReorderSegmentEvent].
      final List<TrailSegment> segments = new List.from(state.segments);
      final TrailSegment segment = segments.removeAt(event.oldPos);
      segments.insert(
          event.newPos > event.oldPos ? event.newPos - 1 : event.newPos,
          segment);
      emit(new Trail<TrailSegment>(segments));
    }
  }
}
