import 'package:flutter/material.dart';
import 'package:kilian/widgets/painting.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'theme.dart';

extension MediaQueryDataExtended on MediaQueryData {
  /// Device .
  DeviceScreenType get deviceScreenType => getDeviceType(size, kBreakPoints);

  bool get isMobile => deviceScreenType == DeviceScreenType.mobile;

  bool get isTablet => deviceScreenType == DeviceScreenType.tablet;

  bool get isDesktop => deviceScreenType == DeviceScreenType.desktop;

  /// Refined sizes.
  RefinedSize get refinedSize => getRefinedSize(size, refinedBreakpoint: kRefinedBreakpoints);

  bool get isExtraLarge => refinedSize == RefinedSize.extraLarge;

  bool get isLarge => refinedSize == RefinedSize.large;

  bool get isNormal => refinedSize == RefinedSize.normal;

  bool get isSmall => refinedSize == RefinedSize.small;
}

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.centerBody = true,
    this.backgroundColor,
    this.scrollable = false,
    this.onWillPop,
  });

  /// An app bar to display at the top of the scaffold.
  final PreferredSizeWidget? appBar;

  /// The primary content of the scaffold.
  final Widget body;
  final bool centerBody;

  /// The color of the [Material] widget that underlies the entire Scaffold.
  ///
  /// The theme's [ThemeData.scaffoldBackgroundColor] by default.
  final Color? backgroundColor;

  /// When [true] the body is forced to be scrollable.
  final bool scrollable;

  /// Called to veto attempts by the user to dismiss the enclosing [ModalRoute].
  ///
  /// If the callback returns a Future that resolves to false, the enclosing
  /// route will not be popped.
  final WillPopCallback? onWillPop;

  /// A button displayed floating above [body].
  final Widget? floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    // Get media query info.
    final MediaQueryData mediaQueryInfo = MediaQuery.of(context);
    final bool isScrollable =
        scrollable || mediaQueryInfo.isMobile || (mediaQueryInfo.isTablet && mediaQueryInfo.isSmall);

    final Widget child = _responsiveBuilder(child: body, scrollable: isScrollable);

    Widget widget = new Scaffold(
      appBar: appBar,
      body: centerBody ? new Center(child: child) : child,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );

    if (onWillPop != null) {
      widget = new WillPopScope(onWillPop: onWillPop, child: widget);
    }

    return widget;
  }

  /// Responsive UI widget builder.
  Widget _responsiveBuilder({required final bool scrollable, required final Widget child}) {
    if (scrollable) {
      return new SingleChildScrollView(child: child);
    } else {
      return child;
    }
  }
}

class ResponsiveDialog extends StatelessWidget {
  const ResponsiveDialog({
    required this.child,
    super.key,
    this.maxWidth = kMaxWidthPortrait,
    this.dismissible = true,
    this.title,
    this.padding = kMarginAllTriple,
  });

  final Widget child;

  final double maxWidth;

  final bool dismissible;

  final String? title;

  final EdgeInsetsGeometry padding;

  /// Default padding. The same as for the default padding of Flutter [Dialog].
  static const EdgeInsets _defaultMargin = const EdgeInsets.symmetric(horizontal: 40, vertical: 24);

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.of(context).isMobile;
    final EdgeInsets effectiveMargin = MediaQuery.of(context).viewInsets + _defaultMargin;

    late Widget widget;
    if (dismissible) {
      const Widget close = const SizedBox.square(
        dimension: kMinInteractiveDimension,
        child: const CloseButton(),
      );
      const Widget space = const SizedBox(width: kMinInteractiveDimension);
      widget = new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // App-bar with the close button.
          new SizedBox(
            height: kToolbarHeight,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (mobile) close else space,
                // Short titles are placed in the appbar.
                if (title != null && title!.length <= 20) _buildTitle(title!),
                if (mobile) space else close,
              ],
            ),
          ),
          // Long titles are placed below the appbar.
          if (title != null && title!.length > 20)
            new Padding(
              padding: EdgeInsets.symmetric(horizontal: padding.horizontal / 2),
              child: _buildTitle(title!),
            ),
          new Flexible(child: new Padding(padding: padding, child: child)),
        ],
      );
    } else {
      if (title != null) {
        widget = new Padding(
          padding: padding,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(title!),
              new Flexible(child: child),
            ],
          ),
        );
      } else {
        widget = new Padding(padding: padding, child: child);
      }
    }

    widget = new SingleChildScrollView(
      padding: effectiveMargin,
      child: new Card(
        elevation: 24.0, // Default elevation for dialogs (see [Dialog])
        shape: kRoundedBorderMedium,
        child: widget,
      ),
    );

    // Get media query info.
    final MediaQueryData mediaQueryInfo = MediaQuery.of(context);
    if (mediaQueryInfo.deviceScreenType == DeviceScreenType.desktop ||
        mediaQueryInfo.deviceScreenType == DeviceScreenType.tablet) {
      widget = new ConstrainedBox(
        constraints: new BoxConstraints(maxWidth: maxWidth),
        child: widget,
      );
    }

    return new Center(child: widget);
  }

  static Widget _buildTitle(final String title) {
    return new Text(
      title,
      style: const TextStyle(fontSize: 22, color: AppColors.primary),
      textAlign: TextAlign.center,
    );
  }
}
