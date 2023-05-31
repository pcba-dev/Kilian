import 'package:bloc/bloc.dart';

import '../models/calculator.dart';
import '../models/user.dart';
import 'user_parameters_event.dart';

class UserParametersCubit extends Cubit<UserParameters> {
  UserParametersCubit()
      : super(const UserParameters(calculator: const StandardTrailCalculator()));

  /// Handler for [UserParametersEvent]s.
  void add(final UserParametersEvent event) {
    if (event is ChangeFitnessEvent) {
      // Handler for [ChangeFitnessEvent].
      emit(new UserParameters(
          calculator: state.calculator, fitness: event.fitness));
    }
  }
}
