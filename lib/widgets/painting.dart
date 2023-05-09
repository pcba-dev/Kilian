import 'package:flutter/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// Default margin around widgets.
const double kMarginSize = 8;

// Bootstrap breakpoints:
// Small devices (landscape phones, 576px and up)
// Medium devices (tablets, 768px and up)
// Large devices (desktops, 992px and up)
// X-Large devices (large desktops, 1200px and up)
// XX-Large devices (larger desktops, 1400px and up)
const double kMaxWidthWatch = 300;
const double kMinWidthMobile = 480;
const double kMaxWidthPortrait = 576;
const double kMinWidthTablet = 768;
const double kMinWidthDesktop = 992;
const double kMaxWidthXL = 1400;
const double kMaxWidthXXL = 1800;

const ScreenBreakpoints kBreakPoints = const ScreenBreakpoints(
  desktop: kMinWidthDesktop,
  tablet: kMinWidthTablet,
  watch: kMaxWidthWatch,
);

const RefinedBreakpoints kRefinedBreakpoints = RefinedBreakpoints(
  // Desktop
  desktopExtraLarge: 2 * kMaxWidthXXL,
  desktopLarge: kMaxWidthXXL,
  desktopNormal: kMaxWidthXL,
  desktopSmall: kMinWidthDesktop,
  // Tablet
  tabletExtraLarge: (kMinWidthDesktop - kMinWidthTablet) * 3 / 4 + kMinWidthTablet,
  tabletLarge: (kMinWidthDesktop - kMinWidthTablet) * 2 / 4 + kMinWidthTablet,
  tabletNormal: (kMinWidthDesktop - kMinWidthTablet) * 1 / 4 + kMinWidthTablet,
  tabletSmall: kMinWidthTablet,
  // Mobile
  mobileExtraLarge: (kMinWidthTablet - kMaxWidthPortrait) * 1 / 2 + kMaxWidthPortrait,
  mobileLarge: kMaxWidthPortrait,
  mobileNormal: kMinWidthMobile,
  mobileSmall: kMaxWidthWatch,
);

/// Padding/margin.
const EdgeInsetsGeometry kMarginAll = EdgeInsets.all(kMarginSize);
const EdgeInsetsGeometry kMarginAllHalf = EdgeInsets.all(0.5 * kMarginSize);
const EdgeInsetsGeometry kMarginAllDouble = EdgeInsets.all(2 * kMarginSize);
const EdgeInsetsGeometry kMarginAllTriple = EdgeInsets.all(3 * kMarginSize);

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
const BorderRadius kBorderRadiusMedium = const BorderRadius.all(Radius.circular(12));
const ShapeBorder kRoundedBorder = const RoundedRectangleBorder(borderRadius: kBorderRadius);
const OutlinedBorder kRoundedBorderMedium = const RoundedRectangleBorder(borderRadius: kBorderRadiusMedium);
