import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kilian/widgets/responsive.dart';

import './painting.dart';

class TipWidget extends StatelessWidget {
  const TipWidget({
    required this.tip,
    this.forceDialog = false,
    super.key,
  });

  final String tip;

  /// Flag to force showing a dialog instead of a text label when is not Web.
  final bool forceDialog;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return (kIsWeb && forceDialog && !mediaQuery.isDesktop) || !kIsWeb
        ? new _PlatformTipWidget(tip: tip)
        : new _WebTipWidget(tip: tip);
  }
}

class _WebTipWidget extends StatelessWidget {
  const _WebTipWidget({required this.tip, super.key});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return new Tooltip(
      margin: kMarginAllHalf,
      padding: kMarginAll,
      message: tip,
      textStyle: const TextStyle(fontSize: 15, color: Colors.white),
      triggerMode: TooltipTriggerMode.tap,
      decoration: BoxDecoration(color: Colors.grey),
      child: const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
    );
  }
}

class _PlatformTipWidget extends StatelessWidget {
  const _PlatformTipWidget({required this.tip, super.key});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: const Icon(Icons.info_outline, color: Colors.blueGrey, size: 20),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => new Dialog(
            child: new Padding(
              padding: kMarginAllDouble,
              child: new Text(tip, style: const TextStyle(fontSize: 15)),
            ),
          ),
        );
      },
    );
  }
}
