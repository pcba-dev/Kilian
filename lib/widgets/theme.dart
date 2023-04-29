import 'package:flutter/material.dart';

abstract class AppColors {
  /// Primary Color: Mint Tulip.
  static const Color primary = const Color.fromRGBO(185, 255, 230, 1);

  /// Secondary Color: Khaki.
  static const Color secondary = const Color.fromRGBO(255, 180, 70, 1);
}

final ThemeData kTheme = new ThemeData(
    colorScheme: ThemeData().colorScheme.copyWith(primary: AppColors.primary, secondary: AppColors.secondary));
