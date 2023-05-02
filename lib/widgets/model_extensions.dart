import 'package:flutter/material.dart';

import '../models/trail.dart';
import '../models/user.dart';

extension FitnessLevelExtended on FitnessLevel {
  String toStringLocalized(BuildContext context) {
    // TODO: Locale
    switch (this) {
      case FitnessLevel.child:
        return 'Infantil';
      case FitnessLevel.sedentary:
        return 'Sedentario';
      case FitnessLevel.beginner:
        return 'Principiante';
      case FitnessLevel.average:
        return 'Promedio';
      case FitnessLevel.athletic:
        return 'Deportista';
    }
  }

  String getTipLocalized(BuildContext context) {
    // TODO: Locale
    switch (this) {
      case FitnessLevel.child:
        return 'Niño/a de 6-8 años.';
      case FitnessLevel.sedentary:
        return 'Adulto sedentario o niño/a de 9-11 años.';
      case FitnessLevel.beginner:
        return 'Adulto principiante o adolescente de 12-14 años.';
      case FitnessLevel.average:
        return 'Adulto medio o adolescente de 15-17 años.';
      case FitnessLevel.athletic:
        return 'Adulto deportista';
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

  String toStringLocalized(BuildContext context) {
    // TODO: Locale
    switch (this) {
      case MIDLevel.easy:
        return 'Fácil';
      case MIDLevel.moderate:
        return 'Moderado';
      case MIDLevel.challenging:
        return 'Exigente';
      case MIDLevel.hard:
        return 'Complicado';
      case MIDLevel.extreme:
        return 'Extremo';
    }
  }

  String getTipLocalized(BuildContext context) {
    // TODO: Locale
    switch (this) {
      case MIDLevel.easy:
        return 'Medio exento de riesgos, caminos y cruces bien definidos, marcha por superficie lisa.';
      case MIDLevel.moderate:
        return 'Hay algún factor de riesgo, señalización que indica la continuidad, marcha por caminos de firme regular.';
      case MIDLevel.challenging:
        return 'Hay varios factor de riesgo, exige la identificación de accidentes geográficos y puntos del itinerario, Marcha por sendas escalonadas o terreno irregular.';
      case MIDLevel.hard:
        return 'Hay bastantes factores de riesgo, técnicas de orientación y navegación fuera de traza, precisa usar de las manos para mantener el equilibrio.';
      case MIDLevel.extreme:
        return 'Hay muchos factores de riesgo, la navegación es interrumpida por obstáculos que hay que bordear, requiere pasos de escalada para la progresión.';
      default:
        // Protection code.
        throw UnimplementedError(this.toString());
    }
  }
}
