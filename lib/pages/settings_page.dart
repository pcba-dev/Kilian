import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';
import '../l10n/l10n.dart';
import '../states/user_parameters_cubit.dart';
import '../states/user_parameters_event.dart';
import '../widgets/painting.dart';
import '../widgets/user.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserParametersCubit, UserParameters>(
      builder: (context, params) {
        return new SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 2 * kMarginSize, vertical: 3 * kMarginSize),
          title: new Text(context.l10n.settingsTitle, textAlign: TextAlign.center),
          children: [
            new FitnessSelector(
              value: params.fitness,
              onChanged: (f) => _onChangeFitness(context, f),
            )
          ],
        );
      },
    );
  }
}

void _onChangeFitness(final BuildContext context, final FitnessLevel? fitness) {
  if (fitness != null) {
    context.read<UserParametersCubit>().add(new ChangeFitnessEvent(fitness));
  }
}
