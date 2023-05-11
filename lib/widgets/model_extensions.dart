import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/trail.dart';
import '../models/user.dart';

extension FitnessLevelExtended on FitnessLevel {
  String toStringLocalized(BuildContext context) {
    switch (this) {
      case FitnessLevel.child:
        return context.l10n.fitnessChild;
      case FitnessLevel.sedentary:
        return context.l10n.fitnessSedentary;
      case FitnessLevel.beginner:
        return context.l10n.fitnessBeginner;
      case FitnessLevel.average:
        return context.l10n.fitnessAverage;
      case FitnessLevel.athletic:
        return context.l10n.fitnessAthletic;
    }
  }

  String getTipLocalized(BuildContext context) {
    switch (this) {
      case FitnessLevel.child:
        return context.l10n.fitnessChildTip;
      case FitnessLevel.sedentary:
        return context.l10n.fitnessSedentaryTip;
      case FitnessLevel.beginner:
        return context.l10n.fitnessBeginnerTip;
      case FitnessLevel.average:
        return context.l10n.fitnessAverageTip;
      case FitnessLevel.athletic:
        return context.l10n.fitnessAthleticTip;
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
    switch (this) {
      case MIDLevel.easy:
        return context.l10n.midLevelEasy;
      case MIDLevel.moderate:
        return context.l10n.midLevelModerate;
      case MIDLevel.challenging:
        return context.l10n.midLevelChallenging;
      case MIDLevel.hard:
        return context.l10n.midLevelHard;
      case MIDLevel.extreme:
        return context.l10n.midLevelExtreme;
    }
  }

  String getTipLocalized(BuildContext context) {
    switch (this) {
      case MIDLevel.easy:
        return context.l10n.midLevelEasyTip;
      case MIDLevel.moderate:
        return context.l10n.midLevelModerateTip;
      case MIDLevel.challenging:
        return context.l10n.midLevelChallengingTip;
      case MIDLevel.hard:
        return context.l10n.midLevelHardTip;
      case MIDLevel.extreme:
        return context.l10n.midLevelExtremeTip;
      default:
        // Protection code.
        throw UnimplementedError(this.toString());
    }
  }
}
