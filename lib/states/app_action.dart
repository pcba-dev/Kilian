import 'package:flutter/foundation.dart';
import 'package:kilian/states/trail_action.dart';

import 'package:redux/redux.dart';

import 'app_state.dart';
import 'user_parameters_action.dart';

/// REDUX actions base class.
@immutable
abstract class AppAction {
  const AppAction();
}

Reducer<AppState> appStateReducer = combineReducers([
  new TypedReducer<AppState, TrailAction>(trailReducer),
  new TypedReducer<AppState, UserParametersAction>(userParametersReducer),
]);
