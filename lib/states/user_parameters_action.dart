import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';

import '../models/user.dart';
import 'app_action.dart';
import 'app_state.dart';
import 'utils.dart' as utils;

@immutable
abstract class UserParametersAction extends AppAction {
  const UserParametersAction();
}

Reducer<AppState> userParametersReducer = (
  final AppState previous,
  final dynamic action,
) {
  late final UserParameters parameters;
  if (action is ChangeFitnessAction) {
    parameters = changeFitnessReducer(previous.parameters, action);
  } else {
    parameters = previous.parameters;
  }
  return new AppState(
    parameters: parameters,
    trail: utils.computeTrailView(params: parameters, trail: previous.trail),
  );
};

class ChangeFitnessAction extends UserParametersAction {
  /// New fitness level.
  final FitnessLevel fitness;

  const ChangeFitnessAction(this.fitness);
}

/// REDUX reducer for [ChangeFitnessAction].
UserParameters changeFitnessReducer(final UserParameters previous, final ChangeFitnessAction action) {
  return new UserParameters(
    calculator: previous.calculator,
    fitness: action.fitness,
  );
}
