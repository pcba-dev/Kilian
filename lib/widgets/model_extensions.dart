import 'package:flutter/material.dart';

import '../models/trail.dart';
import '../models/user.dart';

extension FitnessLevelExtended on FitnessLevel {
  String toStringLocalized(BuildContext context) {
    // TODO: Locale
    switch (this) {
      case FitnessLevel.child:
        return "Infantil";
      case FitnessLevel.sedentary:
        return "Sedentario";
      case FitnessLevel.beginner:
        return "Principiante";
      case FitnessLevel.average:
        return "Promedio";
      case FitnessLevel.athletic:
        return "Deportista";
    }
  }

  String getTipLocalized(BuildContext context) {
    // TODO: Locale
    switch (this) {
      case FitnessLevel.child:
        return "Niño/a de 6-8 años.";
      case FitnessLevel.sedentary:
        return "Adulto sedentario o niño/a de 9-11 años.";
      case FitnessLevel.beginner:
        return "Adulto principiante o adolescente temprano de 12-14 años.";
      case FitnessLevel.average:
        return "Adulto medio o adolescente tardío de 15-17 años.";
      case FitnessLevel.athletic:
        return "Adulto deportista";
      default:
        // Protection code.
        throw UnimplementedError(this.toString());
    }
  }
}

extension MIDLevelExtended on MIDLevel {
  int toNumber() {
    switch (this) {
      case MIDLevel.easy:
        return 1;
      case MIDLevel.moderate:
        return 2;
      case MIDLevel.challenging:
        return 3;
      case MIDLevel.hard:
        return 4;
      case MIDLevel.extreme:
        return 5;
      default:
        // Protection code.
        throw UnimplementedError(this.toString());
    }
  }

  Color get color {
    switch (this) {
      case MIDLevel.easy:
        return Colors.greenAccent;
      case MIDLevel.moderate:
        return Colors.green;
      case MIDLevel.challenging:
        return Colors.amber;
      case MIDLevel.hard:
        return Colors.orange;
      case MIDLevel.extreme:
        return Colors.deepOrange;
      default:
        // Protection code.
        throw UnimplementedError(this.toString());
    }
  }
}
