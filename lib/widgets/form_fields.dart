import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A [TextFormField] that contains only accepts numbers.
///
/// This is a convenience widget that configures [TextFormField] widget such that only accepts inputs which
/// are double or integer numbers.
class NumberFormField extends TextFormField {
  NumberFormField({
    final num? initialValue,
    final int? precision,
    final int? scale,
    final bool signed = true,
    super.key,
    super.focusNode,
    super.decoration,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.autofocus,
    super.readOnly,
    super.showCursor,
    super.obscureText,
    super.controller,
    super.onChanged,
    super.onFieldSubmitted,
    super.onSaved,
    super.validator,
    super.textInputAction,
  }) : super(
          initialValue: initialValue?.toString(),
          keyboardType: TextInputType.number,
          enableSuggestions: false,
          maxLines: 1,
          inputFormatters: [
            TextInputFormatter.withFunction(
              (oldV, newV) => _numbersFormatter(oldV, newV, precision: precision, scale: scale, signed: signed),
            )
          ],
        );

  NumberFormField.int({
    final int? initialValue,
    final int? precision,
    final bool signed = true,
    super.key,
    super.focusNode,
    super.decoration,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.autofocus,
    super.readOnly,
    super.showCursor,
    super.obscureText,
    super.controller,
    super.onChanged,
    super.onFieldSubmitted,
    super.onSaved,
    super.validator,
    super.textInputAction,
  }) : super(
          initialValue: initialValue?.toString(),
          keyboardType: TextInputType.number,
          enableSuggestions: false,
          maxLines: 1,
          inputFormatters: [
            TextInputFormatter.withFunction(
              (oldV, newV) => _onlyIntegersFormatter(oldV, newV, precision: precision, signed: signed),
            )
          ],
        );

  static TextEditingValue _onlyIntegersFormatter(
    final TextEditingValue oldValue,
    final TextEditingValue newValue, {
    final int? precision,
    final bool signed = true,
  }) {
    if (!signed && newValue.text.contains('-')) {
      return oldValue;
    }

    if (newValue.text.isEmpty || newValue.text == '-') {
      return newValue;
    } else {
      // Check if the input can be parsed into an Int and returns the previous input otherwise.
      final int? newVal = int.tryParse(newValue.text);

      if (newVal == null) {
        return oldValue;
      } else {
        // Check for number of digits.
        if (precision != null) {
          return math.pow(10, precision) > newVal.abs() ? newValue : oldValue;
        }
        return newValue;
      }
    }
  }

  static TextEditingValue _numbersFormatter(
    final TextEditingValue oldValue,
    final TextEditingValue newValue, {
    final int? precision,
    final int? scale,
    final bool signed = true,
  }) {
    if (!signed && newValue.text.contains('-')) {
      return oldValue;
    }

    if (newValue.text.isEmpty || newValue.text == '-') {
      return newValue;
    } else {
      // Check if the input can be parsed into an Int and returns the previous input otherwise.
      final double? newVal = double.tryParse(newValue.text);

      if (newVal == null) {
        return oldValue;
      } else {
        // Check for precision and number of decimals.
        if (precision != null || scale != null) {
          // Remove sign and decimal point/comma.
          final String plain = newValue.text.replaceAll(RegExp(r'[-.,]?'), '');

          // Remove whole part.
          final String decimals = newValue.text.replaceFirst(RegExp(r'-?\d*[.,]?'), '');

          return !(precision != null && plain.length > precision) && !(scale != null && decimals.length > scale)
              ? newValue
              : oldValue;
        }
        return newValue;
      }
    }
  }
}
