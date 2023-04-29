import 'package:flutter/material.dart';
import 'package:kilian/widgets/basic.dart';
import 'package:kilian/widgets/painting.dart';

import './model_extensions.dart';
import '../models/user.dart';

class FitnessSelector extends StatelessWidget {
  const FitnessSelector({required this.value, required this.onChanged, super.key});

  /// The value of the currently selected [FitnessLevel].
  final FitnessLevel value;

  /// Called when the user selects an item.
  final ValueChanged<FitnessLevel?> onChanged;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<FitnessLevel>> items = FitnessLevel.values
        .map<DropdownMenuItem<FitnessLevel>>((e) => new DropdownMenuItem<FitnessLevel>(
              value: e,
              child: new Text(e.toStringLocalized(context), maxLines: 1),
            ))
        .toList();

    final String tip =
        FitnessLevel.values.map((e) => "* ${e.toStringLocalized(context)}: ${e.getTipLocalized(context)}").join("\n");

    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2 * kMarginSize),
      child: new SizedBox(
        width: 150,
        child: Row(
          children: <Widget>[
            new Flexible(
              child: new DropdownButtonFormField(
                isExpanded: true,
                isDense: false,
                decoration: const InputDecoration(
                  // TODO: Locale
                  labelText: "Condición física",
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(left: 12),
                ),
                value: value,
                items: items,
                onChanged: onChanged,
              ),
            ),
            kSpacingHorizontal,
            new TipWidget.info(tip: tip),
          ],
        ),
      ),
    );
  }
}
