import 'package:flutter/widgets.dart';

/// Default margin around widgets.
const double kMarginSize = 8.0;

// Bootstrap breakpoints
// Small devices (landscape phones, 576px and up)
// Medium devices (tablets, 768px and up)
// Large devices (desktops, 992px and up)
// X-Large devices (large desktops, 1200px and up)
// XX-Large devices (larger desktops, 1400px and up)

/// Padding/margin.
const EdgeInsetsGeometry kMarginAll = EdgeInsets.all(kMarginSize);
const EdgeInsetsGeometry kMarginAllHalf = EdgeInsets.all(0.5 * kMarginSize);
const EdgeInsetsGeometry kMarginAllDouble = EdgeInsets.all(2 * kMarginSize);

/// Spacing.
const SizedBox kSpacingVertical = const SizedBox(height: kMarginSize);
const SizedBox kSpacingVerticalHalf = const SizedBox(height: 0.5 * kMarginSize);
const SizedBox kSpacingVerticalDouble = const SizedBox(height: 2 * kMarginSize);
const SizedBox kSpacingVerticalTriple = const SizedBox(height: 3 * kMarginSize);
const SizedBox kSpacingHorizontal = const SizedBox(width: kMarginSize);
const SizedBox kSpacingHorizontalHalf = const SizedBox(width: 0.5 * kMarginSize);
const SizedBox kSpacingHorizontalDouble = const SizedBox(width: 2 * kMarginSize);

/// Borders.
const BorderRadius kBorderRadius = const BorderRadius.all(Radius.circular(8));
const ShapeBorder kRoundedBorder = const RoundedRectangleBorder(borderRadius: kBorderRadius);
