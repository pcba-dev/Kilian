import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kilian/models/user.dart';

import '../states/app_state.dart';
import '../states/user_parameters_action.dart';
import '../widgets/painting.dart';
import '../widgets/user.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, UserParameters>(
      converter: (store) => store.state.parameters,
      builder: (_, params) {
        return new SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 2 * kMarginSize, vertical: 3 * kMarginSize),
          // TODO: Locale
          title: new Text("Configuración", textAlign: TextAlign.center),
          children: [
            new FitnessSelector(
              value: params.fitness,
              onChanged: _onChangeFitness,
            )
          ],
        );
      },
    );
  }
}

void _onChangeFitness(final FitnessLevel? fitness) {
  if (fitness != null) {
    AppStore.instance.dispatch(new ChangeFitnessAction(fitness));
  }
}
