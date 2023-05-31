import '../models/user.dart';

/// Cubit events base class for user parameters mutations.
abstract class UserParametersEvent {
  const UserParametersEvent();
}

class ChangeFitnessEvent extends UserParametersEvent {
  /// New fitness level.
  final FitnessLevel fitness;

  const ChangeFitnessEvent(this.fitness);
}
