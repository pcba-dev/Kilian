import 'package:flutter/material.dart';

import './painting.dart';

class TipWidget extends StatelessWidget {
  const TipWidget({
    required this.tip,
    required this.child,
    super.key,
    this.fontColor = Colors.white,
    this.backgroundColor = Colors.blueGrey,
  });

  const TipWidget.info({
    required this.tip,
    super.key,
    this.fontColor = Colors.white,
    this.backgroundColor = Colors.blueGrey,
  }) : child = const Icon(Icons.info_outline, color: Colors.blueGrey, size: 16);

  final String tip;
  final Widget child;
  final Color fontColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return new Tooltip(
      margin: kMarginAllHalf,
      padding: kMarginAllHalf,
      message: tip,
      textStyle: new TextStyle(fontSize: 15, color: fontColor),
      decoration: new BoxDecoration(color: backgroundColor),
      child: child,
    );
  }
}
