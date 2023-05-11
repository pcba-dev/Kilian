import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import '../models/calculator.dart';
import '../models/user.dart';
import '../view-models/trail.dart';
import 'app_action.dart';

class AppStore extends Store<AppState> {
  AppStore._(super.reducer, {required super.initialState}) : super();

  static final AppStore instance = AppStore._(appStateReducer, initialState: const AppState.initial());
}

/// REDUX app state.
@immutable
class AppState {
  final UserParameters parameters;

  final TrailViewModel trail;

  const AppState({
    required this.parameters,
    required this.trail,
  });

  const AppState.initial()
      : parameters = const UserParameters(calculator: const StandardTrailCalculator()),
        trail = const TrailViewModel([], duration: Duration.zero, resting: Duration.zero);
}
